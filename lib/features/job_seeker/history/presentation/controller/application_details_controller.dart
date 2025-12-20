import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/api/api_service.dart';
import '../../data/model/application_details_models.dart';

class AppliedDetailsController extends GetxController {
  final String applicationId;

  AppliedDetailsController({required this.applicationId});

  Rx<ApplicationDetail?> applicationDetail = Rx<ApplicationDetail?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchApplicationDetails();
  }

  Future<void> fetchApplicationDetails() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get('application/$applicationId');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data['success'] == true && data['data'] != null) {
          applicationDetail.value = ApplicationDetail.fromJson(data['data']);
        } else {
          Get.snackbar(
            'Error',
            data['message'] ?? 'Failed to fetch application details',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String getImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    return ApiEndPoint.imageUrl+ imagePath; // Replace with your actual base URL
  }

  String getDocumentUrl(String docPath) {
    if (docPath.isEmpty) return '';
    if (docPath.startsWith('http')) return docPath;
    return ApiEndPoint.imageUrl + docPath; // Replace with your actual base URL
  }

  String getFileName(String path) {
    if (path.isEmpty) return 'Unknown';
    return path.split('/').last;
  }

  bool get isRejected => applicationDetail.value?.status == 'REJECTED';

  String get currentStatus {
    final detail = applicationDetail.value;
    if (detail == null) return 'Unknown';

    if (detail.history.isNotEmpty) {
      return detail.history.last.title;
    }
    return detail.status;
  }
}