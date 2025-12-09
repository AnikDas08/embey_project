import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../core/services/api/api_service.dart';
import '../../../../../../core/config/api/api_end_point.dart';
import '../../../../../../core/utils/app_utils.dart';

class ChangePasswordController extends GetxController {
  bool isLoading = false;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///  change password function

  Future<void> changePasswordRepo() async {
    isLoading = true;
    update();

    Map<String, String> body = {
      "currentPassword": currentPasswordController.text,
      "confirmPassword": confirmPasswordController.text,
      "newPassword": newPasswordController.text,
    };
    var response = await ApiService.post(
      ApiEndPoint.changePassword,
      body: body,
    );

    if (response.statusCode == 200) {
      Get.back();
      Get.snackbar("Success", "Password changed successfully");
      //Utils.successSnackBar(response.statusCode.toString(), response.message);

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();
    } else {
      Get.snackbar(response.statusCode.toString(), response.message);
    }
    isLoading = false;
    update();
  }

  /// dispose Controller
  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
