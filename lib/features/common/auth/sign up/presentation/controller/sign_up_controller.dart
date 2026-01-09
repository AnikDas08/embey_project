import 'dart:async';

import 'package:embeyi/core/component/pop_up/success_dialog.dart';
import 'package:embeyi/core/utils/enum/enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:embeyi/core/utils/helpers/other_helper.dart';

import '../../../../../../core/config/route/app_routes.dart';
import '../../../../../../core/services/api/api_service.dart';
import '../../../../../../core/services/storage/storage_keys.dart';
import '../../../../../../core/config/api/api_end_point.dart';
import '../../../../../../core/services/storage/storage_services.dart';
import '../../../../../../core/utils/app_utils.dart';

class SignUpController extends GetxController {
  /// Sign Up Form Key

  bool isPopUpOpen = false;
  bool isLoading = false;
  bool isLoadingVerify = false;
  bool isLoadingResend = false;
  String role="";

  Timer? _timer;
  int start = 0;

  String time = "00:00";

  List selectedOption = ["User", "Consultant"];

  String selectRole = "User";
  String countryCode = "+880";
  String? image;

  String signUpToken = '';

  // Add checkbox state
  bool isTermsAccepted = false;

  static SignUpController get instance => Get.put(SignUpController());

  TextEditingController nameController = TextEditingController(
    text: kDebugMode ? "Namimul Hassan" : "",
  );
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? "developernaimul00@gmail.com" : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : '',
  );
  TextEditingController confirmPasswordController = TextEditingController(
    text: kDebugMode ? 'hello123' : '',
  );
  TextEditingController numberController = TextEditingController(
    text: kDebugMode ? '1865965581' : '',
  );
  TextEditingController otpController = TextEditingController(
    text: kDebugMode ? '' : '',
  );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  onCountryChange(Country value) {
    countryCode = value.dialCode.toString();
  }

  setSelectedRole(value) {
    selectRole = value;
    update();
  }

  openGallery() async {
    image = await OtherHelper.openGallery();
    update();
  }

  // Toggle checkbox state
  toggleTermsAcceptance(bool? value) {
    isTermsAccepted = value ?? false;
    update();
  }

  signUpUser() async {

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Password and Confirm Password do not match"),
        ),
      );
      return; // ⛔ এখানেই থেমে যাবে, API call হবে না
    }

    // Check if terms are accepted
    if (!isTermsAccepted) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Please accept the Terms & Privacy Policy to continue"),
        ),
      );
      return;
    }

    if(LocalStorage.userRole==UserRole.jobSeeker){
      role="EMPLOYEE";
    }
    else{
      role="RECRUITER";
    }

    try{
      isLoading = true;
      update();
      Map<String, String> body = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "role": role,
      };
      var response = await ApiService.post(ApiEndPoint.signUp, body: body);
      if(response.statusCode==200){
        isLoading = false;
        update();
        var data=response.data;
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Get.toNamed(AppRoutes.verifyUser);
      }
      else{
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        isLoading = false;
        update();
      }
    }
    catch(e){
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      isLoading = false;
      update();
    }
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    start = 180; // Reset the start value
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start > 0) {
        start--;
        final minutes = (start ~/ 60).toString().padLeft(2, '0');
        final seconds = (start % 60).toString().padLeft(2, '0');

        time = "$minutes:$seconds";

        update();
      } else {
        _timer?.cancel();
        time = "00:00";
        update();
      }
    });
  }

  /// Resend OTP Api Call
  Future<void> resendOtpRepo() async {
    isLoadingResend = true;
    update();

    if(LocalStorage.userRole==UserRole.jobSeeker){
      role="EMPLOYEE";
    }
    else{
      role="RECRUITER";
    }

    try{
      Map<String, String> body = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "role": role,
      };

      var response = await ApiService.post(ApiEndPoint.signUp, body: body);

      if(response.statusCode == 200){
        isLoadingResend = false;
        update();

        // Clear OTP field for new code
        otpController.clear();

        // Restart timer
        startTimer();

        var data = response.data;
        Utils.successSnackBar("Success", "OTP has been resent to your email");
      }
      else{
        isLoadingResend = false;
        update();
        Utils.errorSnackBar("Error", response.message);
      }
    }
    catch(e){
      isLoadingResend = false;
      update();
      Utils.errorSnackBar("Error", e.toString());
    }
  }

  Future<void> verifyOtpRepo() async {
    isLoadingVerify = true;
    update();
    Map<String, dynamic> body = {
      "oneTimeCode": int.tryParse(otpController.text),
      "email": emailController.text
    };

    var response = await ApiService.post(
      ApiEndPoint.verifyEmail,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = response.data;
      SuccessDialog.show(
        message: 'Your account has been created. Start using the app now.',
        buttonText: 'Proceed to Login',
        onTap: () {
          Get.offAllNamed(AppRoutes.signIn);
        },
      );
    } else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }

    isLoadingVerify = false;
    update();
  }
}