import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PlatformReviewController extends GetxController {
  final isLoading = false.obs;
  final selectedRating = 0.obs;

  void updateRating(int index) {
    if (selectedRating.value == index + 1) {
      selectedRating.value = index;
    } else {
      selectedRating.value = index + 1;
    }
  }

  void resetRating() {
    selectedRating.value = 0;
  }

  Future<bool> submitReview({
    required int rating,
    required String comment,
  }) async {
    try {
      isLoading.value = true;

      final response = await ApiService.post(
        "review",
        body: {
          "rating": rating,
          "comment": comment,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Review Sent Successfully",
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to send review",
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}