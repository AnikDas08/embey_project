import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/app_utils.dart';
import 'package:embeyi/core/utils/enum/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/config/route/job_seeker_routes.dart';
import '../../../../../../core/services/api/api_service.dart';
import '../../../../../../core/config/api/api_end_point.dart';
import '../../../../../../core/services/storage/storage_keys.dart';
import '../../../../../../core/services/storage/storage_services.dart';

class SignInController extends GetxController {
  /// Sign in Button Loading variable
  bool isLoading = false;

  /// Sign in form key , help for Validation

  /// email and password Controller here
  TextEditingController emailController = TextEditingController(
    text: kDebugMode ? '' : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'password' : "",
  );

  /// Sign in Api call here

  Future<void> signInUser() async {
    isLoading = true;
    update();

    Map<String, String> body = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    var response = await ApiService.post(
      ApiEndPoint.signIn,
      body: body,
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      var data = response.data;
      String apiRole = data['data']["role"]; // "EMPLOYEE" or "RECRUITER"

      print("User Role : 🤣🤣🤣🤣 $apiRole");

      // Check if roles match BEFORE saving anything
      bool roleMatches = (LocalStorage.userRole == UserRole.employer && apiRole == "RECRUITER") ||
          (LocalStorage.userRole == UserRole.jobSeeker && apiRole == "EMPLOYEE");

      if (!roleMatches) {
        isLoading = false;
        update();

        Get.snackbar(
          "Error",
          "You are trying to login as the wrong user type",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return; // Exit here if roles don't match
      }

      // If we reach here, roles match - proceed with login
      isLoading = false;
      update();

      Get.snackbar(
        "Success",
        "Login successful",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Save user data
      LocalStorage.token = data['data']["createToken"];
      LocalStorage.userId = data['data']["userId"];
      LocalStorage.isLogIn = true;

      LocalStorage.setBool(LocalStorageKeys.isLogIn, LocalStorage.isLogIn);
      LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);
      LocalStorage.setString(LocalStorageKeys.token, LocalStorage.token);

      if(apiRole == "EMPLOYEE"){
        LocalStorage.setString(LocalStorageKeys.userRole, UserRole.jobSeeker.toString());
      } else {
        LocalStorage.setString(LocalStorageKeys.userRole, UserRole.employer.toString());
      }

      print("User Role Saved: ${LocalStorage.userRole}");

      emailController.clear();
      passwordController.clear();

      // Navigate to appropriate screen
      if(LocalStorage.userRole == UserRole.employer) {
        Get.offAllNamed(RecruiterRoutes.home); // Replace with your route
      } else {
        Get.offAllNamed(JobSeekerRoutes.home); // Replace with your route
      }

    } else {
      isLoading = false;
      update();
      Get.snackbar(response.statusCode.toString(), response.message);
    }
  }
}
