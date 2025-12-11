// controllers/chat_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';

class JobSeekerHelpSupportController extends GetxController {

  TextEditingController subjectController=TextEditingController();
  TextEditingController messageController=TextEditingController();

  bool isLoading = false;

  Future<void> sendContactData() async {
    //Get.toNamed(AppRoutes.complete_profile_screen);
    //return;

    isLoading = true;
    update();

    Map<String, String> body = {
      "sub":subjectController.text,
      "msg":messageController.text
    };

    /*var response = await ApiService.post(
      ApiEndPoint.contracSupport,
      body: body,
    );

    if (response.statusCode == 200) {
      //var data = response.data;
      Get.back();
      Get.snackbar("Successful", "Succefully send the message to Admin");
    }*/

    isLoading = false;
    update();
  }

}