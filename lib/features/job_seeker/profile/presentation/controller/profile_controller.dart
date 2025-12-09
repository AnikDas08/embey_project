import 'package:embeyi/core/component/pop_up/otp_pop_up.dart';
import 'package:embeyi/core/component/pop_up/password_pop_up.dart';
import 'package:embeyi/features/recruiter/profile/presentation/screen/payment_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:embeyi/core/utils/helpers/other_helper.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/config/route/job_seeker_routes.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';

class ProfileController extends GetxController {
  /// Language List here
  List languages = ["English", "French", "Arabic"];

  /// form key here
  final formKey = GlobalKey<FormState>();

  /// select Language here
  String selectedLanguage = "English";

  /// select image here
  String? image;

  /// edit button loading here
  bool isLoading = false;

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

  /// all controller here
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<TextEditingController> otpControllers = [];

  @override
  void onInit() {
    super.onInit();
    getProfileRepo();
    getSubscriptionPlan();
  }

  /// select image function here
  getProfileImage() async {
    image = await OtherHelper.openGalleryForProfile();
    update();
  }

  /// select language  function here
  selectLanguage(int index) {
    selectedLanguage = languages[index];
    update();
    Get.back();
  }

  Future<void> getProfileRepo()async{
    isLoading = true;
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final profileModel = ProfileModel.fromJson(response.data);
        profileData = profileModel.data;
        name.value = response.data["data"]["name"] ?? "";
        profileImage.value = response.data["data"]["image"] ?? "";
        designation.value = response.data["data"]["designation"] ?? "";
        gender.value = response.data["data"]["gender"] ?? "";
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
        summary.value=response.data["data"]["bio"]??'';
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    finally{
      isLoading = false;
      update();
    }
  }

  Future<void> getSubscriptionPlan()async{
    try {
      final response = await ApiService.get(
          ApiEndPoint.subscriptionPlan,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        subscriptionPlan.value=response.data["data"]["name"];
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
  }

  /// update profile function here
  Future<void> editProfileRepo() async {
    if (!formKey.currentState!.validate()) return;

    if (!LocalStorage.isLogIn) return;
    isLoading = true;
    update();

    Map<String, String> body = {
      "fullName": nameController.text,
      "phone": numberController.text,
    };

    var response = await ApiService.multipart(
      ApiEndPoint.user,
      body: body,
      imagePath: image,
      imageName: "image",
    );

    if (response.statusCode == 200) {
      var data = response.data;

      LocalStorage.userId = data['data']?["_id"] ?? "";
      LocalStorage.myImage = data['data']?["image"] ?? "";
      LocalStorage.myName = data['data']?["fullName"] ?? "";
      LocalStorage.myEmail = data['data']?["email"] ?? "";

      LocalStorage.setString("userId", LocalStorage.userId);
      LocalStorage.setString("myImage", LocalStorage.myImage);
      LocalStorage.setString("myName", LocalStorage.myName);
      LocalStorage.setString("myEmail", LocalStorage.myEmail);

      Utils.successSnackBar("Successfully Profile Updated", response.message);
      Get.toNamed(JobSeekerRoutes.profile);
    } else {
      Utils.errorSnackBar(response.statusCode, response.message);
    }

    isLoading = false;
    update();
  }

  static void showPaymentHistoryPopUp() {
    _showPasswordPopUp();
  }

  static void _showPasswordPopUp() {
    TextEditingController passwordController = TextEditingController();
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PasswordPopUp(
        passwordController: passwordController,
        onContinue: () {
          // Handle password submission
          String password = passwordController.text;
          print('Password entered: $password');
          Navigator.pop(context);
          _showOtpPopUp();
          // Navigate to next screen or perform action
        },
      ),
    );
  }

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

  static void _showOtpPopUp() {
    List<TextEditingController> otpControllers = [];
    for (int i = 0; i < 4; i++) {
      otpControllers.add(TextEditingController());
    }
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => OtpPopUp(
        controllers: otpControllers,
        onVerify: () {
          // Handle OTP verification
          String otp = otpControllers
              .map((controller) => controller.text)
              .join();
          // ignore: avoid_print
          print('OTP entered: $otp');
          Navigator.pop(context);
          Get.to(() => const PaymentHistoryScreen());
        },
        onResend: () {
          // Handle resend OTP
          for (var controller in otpControllers) {
            controller.clear();
          }
          // Call API to resend OTP
        },
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
