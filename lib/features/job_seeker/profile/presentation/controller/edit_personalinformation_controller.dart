import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';

class EditPersonalController extends GetxController {
  UserData? profileData;
  RxString name = "".obs;
  RxString profileImage = "".obs;
  RxString designation = "".obs;
  RxString subscriptionPlan = "".obs;
  RxString gender = "".obs;
  RxString dateOfBirth = "".obs;
  RxString nationality = "".obs;
  RxString language = "".obs;
  RxString address = "".obs;
  RxString mobile = "".obs;
  RxString email = "".obs;
  RxString linkedin = "".obs;
  RxString summary = "".obs;

  // Form Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController socialMediaController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  // Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString selectedImagePath = "".obs;

  // Loading State
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfileRepo();
  }

  /// Get Profile Data
  Future<void> getProfileRepo() async {
    isLoading.value = true;
    update();

    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final profileModel = ProfileModel.fromJson(response.data);
        profileData = profileModel.data;

        // Update Observable Values
        name.value = response.data["data"]["name"] ?? "";
        profileImage.value = response.data["data"]["image"] ?? "";
        designation.value = response.data["data"]["designation"] ?? "";
        gender.value = response.data["data"]["gender"] ?? "";

        // Format date of birth to local format
        String dobString = response.data["data"]["date_of_birth"] ?? "";
        if (dobString.isNotEmpty) {
          dateOfBirth.value = _formatDateToLocal(dobString);
        } else {
          dateOfBirth.value = "";
        }

        nationality.value = response.data["data"]["nationality"] ?? "";
        language.value = response.data["data"]["language"] ?? "";
        address.value = response.data["data"]["address"] ?? "";
        mobile.value = response.data["data"]["phone"] ?? "";
        email.value = response.data["data"]["email"] ?? "";
        linkedin.value = response.data["data"]["linkedin"] ?? "";
        summary.value = response.data["data"]["bio"] ?? '';

        // Set Controller Values
        _populateControllers();
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Format UTC date to local format (dd MMM yyyy)
  String _formatDateToLocal(String utcDateString) {
    try {
      // Parse the UTC date string
      DateTime utcDate = DateTime.parse(utcDateString);

      // Convert to local time
      DateTime localDate = utcDate.toLocal();

      // Format as "dd MMM yyyy" (e.g., "15 Dec 2024")
      String formattedDate = DateFormat('dd MMM yyyy').format(localDate);

      return formattedDate;
    } catch (e) {
      print("Error formatting date: $e");
      return utcDateString; // Return original if formatting fails
    }
  }

  /// Populate Text Controllers with Profile Data
  void _populateControllers() {
    fullNameController.text = name.value;
    designationController.text = designation.value;
    dateOfBirthController.text = dateOfBirth.value;
    genderController.text = gender.value;
    nationalityController.text = nationality.value;
    addressController.text = address.value;
    phoneController.text = mobile.value;
    socialMediaController.text = linkedin.value;
    summaryController.text = summary.value;
  }

  /// Pick Image from Gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        selectedImagePath.value = image.path;
        update();
      }
    } catch (e) {
      Utils.errorSnackBar(0, "Failed to pick image: ${e.toString()}");
    }
  }

  /// Update Profile Information
  Future<void> editPersonalInformation() async {
    // Check token first
    final token = LocalStorage.token;
    if (token.isEmpty) {
      Utils.errorSnackBar(0, "Token not found, please login again");
      return;
    }

    // Manual validation
    if (fullNameController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter your full name");
      return;
    }

    if (designationController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter your designation");
      return;
    }

    if (dateOfBirthController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please select your date of birth");
      return;
    }

    if (genderController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please select your gender");
      return;
    }

    if (nationalityController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter your nationality");
      return;
    }

    if (addressController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter your address");
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter your phone number");
      return;
    }

    isUpdating.value = true;
    update();

    try {
      // Convert the displayed date back to API format (yyyy-MM-dd)
      String apiDateFormat = _convertToApiDateFormat(dateOfBirthController.text);

      // Prepare body data
      Map<String, String> body = {
        "name": fullNameController.text.trim(),
        "designation": designationController.text.trim(),
        "date_of_birth": apiDateFormat,
        "gender": genderController.text.trim(),
        "nationality": nationalityController.text.trim(),
        "address": addressController.text.trim(),
        "phone": phoneController.text.trim(),
        "linkedin": socialMediaController.text.trim(),
        "bio": summaryController.text.trim(),
      };

      // Get image path (null if no image selected)
      String? imagePath = selectedImagePath.value.isNotEmpty
          ? selectedImagePath.value
          : null;

      print("============ UPDATE PROFILE ============");
      print("Has Image: ${imagePath != null}");
      print("Body: $body");

      // Call multipart API (works with or without image)
      final response = await ApiService.multipart(
        ApiEndPoint.user,
        header: {"Authorization": "Bearer $token"},
        body: body,
        method: "PATCH",
        imageName: "image",
        imagePath: imagePath,
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data['data'];

        Utils.successSnackBar("Success", "Profile updated successfully");
        Get.back();
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      print("❌ Error updating profile: $e");
      Utils.errorSnackBar(0, "Failed to update profile: ${e.toString()}");
    } finally {
      isUpdating.value = false;
      update();
    }
  }

  /// Convert display date format to API format
  String _convertToApiDateFormat(String displayDate) {
    try {
      // Try to parse the display format (dd MMM yyyy)
      DateTime parsedDate = DateFormat('dd MMM yyyy').parse(displayDate);

      // Convert to API format (yyyy-MM-dd)
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      // If parsing fails, try yyyy-MM-dd format (already in API format)
      try {
        DateTime.parse(displayDate);
        return displayDate;
      } catch (e2) {
        print("Error converting date format: $e");
        return displayDate; // Return original if all parsing fails
      }
    }
  }

  /// Select Gender
  void selectGender(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Gender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Male'),
                onTap: () {
                  genderController.text = 'Male';
                  update();
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Female'),
                onTap: () {
                  genderController.text = 'Female';
                  update();
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Other'),
                onTap: () {
                  genderController.text = 'Other';
                  update();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Select Date of Birth
  Future<void> selectDateOfBirth(BuildContext context) async {
    // Parse existing date if available
    DateTime initialDate = DateTime.now().subtract(Duration(days: 365 * 18));

    if (dateOfBirthController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd MMM yyyy').parse(dateOfBirthController.text);
      } catch (e) {
        print("Error parsing existing date: $e");
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format the selected date in display format (dd MMM yyyy)
      String formattedDate = DateFormat('dd MMM yyyy').format(picked);
      dateOfBirthController.text = formattedDate;
      update();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    designationController.dispose();
    dateOfBirthController.dispose();
    genderController.dispose();
    nationalityController.dispose();
    addressController.dispose();
    phoneController.dispose();
    socialMediaController.dispose();
    summaryController.dispose();
    super.dispose();
  }
}