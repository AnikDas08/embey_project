// add_career_spotlight_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:embeyi/core/component/pop_up/success_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/constants/app_colors.dart';

class AddCareerSpotlightController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final organizationNameController = TextEditingController();
  final locationController = TextEditingController();
  final pricingController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final contactDetailsController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final coverImage = Rx<File?>(null);
  final coverImagePath = ''.obs;

  // Dropdown selections
  final selectedServiceType = Rx<String?>(null);
  final selectedFocusArea = Rx<String?>(null);
  final selectedMode = Rx<String?>(null);
  final selectedContactType = Rx<String?>(null);

  // Date selections
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // Dropdown options
  final serviceTypes = [
    'Hiring',
    'Staffing',
    'Career Coaching',
    'Resume Service',
  ];

  final focusAreas = [
    'Digital Marketing',
    'Data Engineering',
    'Cybersecurity',
    'Software Development',
    'UI/UX Design',
  ];

  final modes = [
    'Remote',
    'Hybrid',
    'On-site',
    'Online',
  ];

  final contactTypes = [
    'email',
    'phone',
    'website',
  ];

  @override
  void onClose() {
    organizationNameController.dispose();
    locationController.dispose();
    pricingController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    contactDetailsController.dispose();
    super.onClose();
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        coverImage.value = File(image.path);
        coverImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        coverImage.value = File(image.path);
        coverImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Show image picker bottom sheet
  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  // Remove selected image
  void removeImage() {
    coverImage.value = null;
    coverImagePath.value = '';
  }

  // Select Start Date
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      startDate.value = picked;

      // If end date is before start date, reset end date
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
    }
  }

  // Select End Date
  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? (startDate.value ?? DateTime.now()),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      endDate.value = picked;
    }
  }

  // Validate form
  bool validateForm() {
    if (coverImage.value == null) {
      Get.snackbar(
        'Required',
        'Please select a cover image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (organizationNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter organization name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedServiceType.value == null) {
      Get.snackbar(
        'Required',
        'Please select service type',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedFocusArea.value == null) {
      Get.snackbar(
        'Required',
        'Please select focus area',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedMode.value == null) {
      Get.snackbar(
        'Required',
        'Please select mode',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter location',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (pricingController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter pricing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (startDate.value == null) {
      Get.snackbar(
        'Required',
        'Please select start date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (endDate.value == null) {
      Get.snackbar(
        'Required',
        'Please select end date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (startTimeController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter start time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (endTimeController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter end time',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedContactType.value == null) {
      Get.snackbar(
        'Required',
        'Please select contact type',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (contactDetailsController.text.trim().isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter contact details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Submit spotlight using ApiService.multipartImage
  Future<void> submitSpotlight() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      // Prepare body data
      Map<String, dynamic> body = {
        'organization_name': organizationNameController.text.trim(),
        'service_type': selectedServiceType.value!,
        'focus_area': selectedFocusArea.value!.toLowerCase().replaceAll(' ', ''),
        'mode': selectedMode.value!,
        'location': locationController.text.trim(),
        'pricing': pricingController.text.trim(),
        'start_date': DateFormat('yyyy-MM-dd').format(startDate.value!),
        'end_date': DateFormat('yyyy-MM-dd').format(endDate.value!),
        'start_time': startTimeController.text.trim(),
        'end_time': endTimeController.text.trim(),

        // 🔥 convert map → json string
        'contact_info': jsonEncode({
          'type': selectedContactType.value!,
          'details': contactDetailsController.text.trim(),
        }),
      };

      // Prepare files list
      List files = [
        {
          'name': 'image',
          'image': coverImagePath.value,
        }
      ];

      // Call ApiService.multipartImage
      final response = await ApiService.multipartImage(
        "spotlight",
        method: 'POST',
        body: body,
        files: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        SuccessDialog.show(message: "Your payment was successful. Please wait for admin approval before your",buttonText: "Done",);
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Career spotlight created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form
        clearForm();

        // Navigate back with success result
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to create spotlight',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    organizationNameController.clear();
    locationController.clear();
    pricingController.clear();
    startTimeController.clear();
    endTimeController.clear();
    contactDetailsController.clear();

    selectedServiceType.value = null;
    selectedFocusArea.value = null;
    selectedMode.value = null;
    selectedContactType.value = null;

    startDate.value = null;
    endDate.value = null;

    removeImage();
  }
}