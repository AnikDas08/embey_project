import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:embeyi/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../../data/model/resume_model.dart';

class ViewResumeController extends GetxController {
  // Resume ID passed from screen
  final String resumeId;

  // Constructor to receive resumeId
  ViewResumeController({required this.resumeId});

  // Loading states
  var isLoading = false.obs;
  var isLoadingDetails = false.obs;
  var isUpdating = false.obs;

  // Data
  var resumes = <Resume>[].obs;
  var currentResume = Rxn<Resume>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch resume details using the passed resumeId
    fetchResumeById(resumeId);
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fetch all resumes
  Future<void> fetchResumes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.get(
        ApiEndPoint.resumeData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final resumeResponse = ResumeResponse.fromJson(data);
        resumes.value = resumeResponse.data;
        print("resume ❤️❤️❤️❤️❤️ $resumes");
      }
    } catch (e) {
      errorMessage.value = 'Failed to load resumes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch single resume details by ID
  Future<void> fetchResumeById(String resumeId) async {
    try {
      isLoadingDetails.value = true;
      errorMessage.value = '';

      final response = await ApiService.get(
          "resume/$resumeId"
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final resume = Resume.fromJson(data["data"]);
        currentResume.value = resume;
      } else {
        throw Exception('Failed to load resume');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Utils.errorSnackBar("Error", e.toString());
    } finally {
      isLoadingDetails.value = false;
    }
  }
}