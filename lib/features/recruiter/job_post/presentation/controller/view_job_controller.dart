import 'package:embeyi/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/api/api_service.dart';
import '../../../home/data/model/job_details_model.dart';

class ViewJobController extends GetxController{

  var isLoading = false.obs;
  final Rx<JobDetailsData?> jobDetails = Rx<JobDetailsData?>(null);
  String postId="";

  void onInit() {
    super.onInit();
    postId = Get.arguments['postId'];
    fetchJobDetails();
  }


  Future<void> fetchJobDetails() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get("job-post/$postId");

      final jobDetailsModel = JobDetailsModel.fromJson(response.data);

      if (jobDetailsModel.success) {
        jobDetails.value = jobDetailsModel.data;

      }
    } catch (e) {
      print("Error fetching job details: $e");
      Get.snackbar('Error', 'Failed to load job details: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }


}