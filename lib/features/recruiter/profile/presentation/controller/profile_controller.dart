import 'package:embeyi/core/component/pop_up/otp_pop_up.dart';
import 'package:embeyi/core/component/pop_up/password_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:embeyi/core/utils/helpers/other_helper.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/config/route/recruiter_routes.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';

class RecruiterProfileController extends GetxController {
  /// Language List here
  List languages = ["English", "French", "Arabic"];

  /// form key here
  final formKey = GlobalKey<FormState>();

  /// select Language here
  String selectedLanguage = "English";

  /// select image here
  String? image;


  /// all controller here
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  final Rx<RecruiterProfileData?> profileData = Rx<RecruiterProfileData?>(null);
  RxBool isLoadingProfile=false.obs;
  RxString name="".obs;
  RxString profileImages="".obs;
  RxString address="".obs;
  RxString mobile="".obs;
  RxString email="".obs;
  RxString linkedin="".obs;
  RxString subscription="".obs;

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

  void onInit() {
    super.onInit();
    getProfile();
  }

  /// update profile function here
  Future<void> getProfile() async {
    isLoadingProfile.value = true;
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final profileModel = RecruiterProfileModel.fromJson(response.data);
        profileData.value = profileModel.data;
        name.value = profileModel.data.name;
        profileImages.value = profileModel.data.image;
        subscription.value = profileModel.data.subscription;
        name.value = profileModel.data.name;
        print("profile image${profileModel.data.image}");

      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingProfile.value = false;
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
          RecruiterRoutes.goToPaymentHistory();
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
}
