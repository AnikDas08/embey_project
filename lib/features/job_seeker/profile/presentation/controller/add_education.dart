import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';

class AddEducationController extends GetxController{
  Future<void> editPersonalInformation() async {
    // Check token first
    final token = LocalStorage.token;
    if (token.isEmpty) {
      Utils.errorSnackBar(0, "Token not found, please login again");
      return;
    }


    try {

      // Prepare body data
      Map<String, String> body = {
      };


      // Call multipart API (works with or without image)
      final response = await ApiService.post(
        ApiEndPoint.user,
        body: body,
        header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

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
      update();
    }
  }
}