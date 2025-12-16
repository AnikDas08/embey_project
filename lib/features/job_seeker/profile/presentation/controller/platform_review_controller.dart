import 'dart:convert';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PlatformReviewController extends GetxController {
  final isLoading = false.obs;

  Future<bool> submitReview({
    required int rating,
    required String comment,
  }) async {
    try {
      isLoading.value = true;

      // Replace with your actual API endpoint
      final response=await ApiService.post(
        "review",
        body: {
          "rating": rating,
          "comment": comment,
        },
      );
      if(response.statusCode==200){
        Get.snackbar("Success", "Review Send Successfully");
        isLoading.value = false;
        return true;
      }
      else{
        Get.snackbar("Error", "Failed to send review");
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