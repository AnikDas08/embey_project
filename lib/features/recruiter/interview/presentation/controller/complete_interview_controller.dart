// complete_interview_details_controller.dart

import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/model/interview_details.dart';
// Import your model here
// import 'application_details_model.dart';

class CompleteInterviewDetailsController extends GetxController {
  final Dio _dio = Dio();

  final isLoading = false.obs;
  final applicationData = Rxn<ApplicationData>();
  final errorMessage = ''.obs;

  String? applicationId;
  String baseUrl = 'YOUR_BASE_URL'; // Replace with your actual base URL

  @override
  void onInit() {
    super.onInit();
    // Get application ID from arguments
    if (Get.arguments != null) {
      applicationId = Get.arguments;
      print("Id is : $applicationId");
      fetchApplicationDetails();
    }
  }

  Future<void> fetchApplicationDetails() async {
    if (applicationId == null) {
      errorMessage.value = 'Application ID is missing';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response=await ApiService.get(
        "application/$applicationId?interview_type=complete&status=INTERVIEW",
      );


      if (response.statusCode == 200) {
        final model = ApplicationInterview.fromJson(response.data);
        if (model.success) {
          applicationData.value = model.data;
        } else {
          errorMessage.value = model.message;
        }
      } else {
        errorMessage.value = 'Failed to fetch application details';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        errorMessage.value = e.response?.data['message'] ?? 'Something went wrong';
      } else {
        errorMessage.value = 'Network error. Please check your connection';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadResume() async {
    if (applicationData.value?.resume == null) return;

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final resumeUrl = '$baseUrl${applicationData.value!.resume}';

      // For mobile, you would use path_provider to get the downloads directory
      // For now, this is a placeholder
      final dir = await getExternalStorageDirectory();
      final savePath = '${dir?.path}/resume.pdf';

      await _dio.download(resumeUrl, savePath);

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Resume downloaded successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to download resume',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String getFormattedSalary() {
    if (applicationData.value == null) return '';
    final minSalary = applicationData.value!.post.minSalary;
    final maxSalary = applicationData.value!.post.maxSalary;
    return '\$${minSalary} - \$${maxSalary}';
  }

  String getJobTypeLabel(String jobType) {
    switch (jobType) {
      case 'FULL_TIME':
        return 'Full Time';
      case 'PART_TIME':
        return 'Part Time';
      case 'CONTRACT':
        return 'Contract';
      default:
        return jobType;
    }
  }

  String getJobLevelLabel(String jobLevel) {
    switch (jobLevel) {
      case 'ENTRY_LEVEL':
        return 'Entry Level';
      case 'MID_LEVEL':
        return 'Mid Level';
      case 'SENIOR_LEVEL':
        return 'Senior Level';
      default:
        return jobLevel;
    }
  }

  String getInterviewTypeLabel(String? interviewType) {
    if (interviewType == null) return '';
    switch (interviewType.toLowerCase()) {
      case 'remote':
        return 'Remote';
      case 'onsite':
        return 'On Site';
      case 'hybrid':
        return 'Hybrid';
      default:
        return interviewType;
    }
  }

  String getFormattedDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String getPostedInfo() {
    if (applicationData.value == null) return '';
    try {
      final createdDate = DateTime.parse(applicationData.value!.createdAt);
      final deadline = DateTime.parse(applicationData.value!.post.deadline);
      final now = DateTime.now();
      final difference = now.difference(createdDate).inDays;

      final deadlineFormatted = getFormattedDate(applicationData.value!.post.deadline);

      return 'Posted $difference Days Ago, End Date $deadlineFormatted';
    } catch (e) {
      return '';
    }
  }

  void onMessageTap() {
    // Navigate to message screen with recruiter details
    // Get.toNamed('/message', arguments: {
    //   'recruiterId': applicationData.value?.recruiter.id,
    //   'recruiterName': applicationData.value?.recruiter.name,
    // });
  }
}