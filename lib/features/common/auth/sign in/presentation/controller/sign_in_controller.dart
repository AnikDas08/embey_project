import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/utils/enum/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    text: kDebugMode ? 'developernaimul00@gmail.com' : '',
  );
  TextEditingController passwordController = TextEditingController(
    text: kDebugMode ? 'hello123' : "",
  );

  /// Sign in Api call here

  Future<void> signInUser() async {
    /*if (LocalStorage.userRole == UserRole.jobSeeker) {
      LocalStorage.isLogIn = true;
      Get.toNamed(JobSeekerRoutes.home);
    } else {
      LocalStorage.isLogIn = true;
      Get.toNamed(RecruiterRoutes.home);
    }*/
    //return;

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

      LocalStorage.token = data['data']["createToken"];
      Get.offAllNamed(JobSeekerRoutes.home);
      LocalStorage.userId = data['data']["userId"];

      //LocalStorage.myEmail = data['data']["attributes"]["email"];
      LocalStorage.isLogIn = true;

      LocalStorage.setBool(LocalStorageKeys.isLogIn, LocalStorage.isLogIn);
      LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);
      LocalStorage.setString(LocalStorageKeys.token, LocalStorage.token);
      LocalStorage.setString(LocalStorageKeys.userRole, UserRole.employer.toString());


      // if (LocalStorage.myRole == 'consultant') {
      //   Get.offAllNamed(AppRoutes.doctorHome);
      // } else {
      //   Get.offAllNamed(AppRoutes.patientsHome);
      // }
      Get.offAllNamed(JobSeekerRoutes.home);

      emailController.clear();
      passwordController.clear();
    } else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }

    isLoading = false;
    update();
  }
}
