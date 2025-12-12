import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../../data/model/resume_model.dart';

class ResumeController extends GetxController {
  // Loading states
  var isLoading = false.obs;
  var isLoadingDetails = false.obs;
  var isUpdating = false.obs;

  // Data
  var resumes = <Resume>[].obs;
  var currentResume = Rxn<Resume>();
  var errorMessage = ''.obs;

  // Text Controllers for Personal Info
  final resumeNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final socialMediaController = TextEditingController();
  final githubController = TextEditingController();
  final workAuthorizationController = TextEditingController();
  final clearancesController = TextEditingController();
  final openToWorkStatusController = TextEditingController();
  final summaryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchResumes();
  }

  @override
  void onClose() {
    // Dispose all text controllers
    resumeNameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    socialMediaController.dispose();
    githubController.dispose();
    workAuthorizationController.dispose();
    clearancesController.dispose();
    openToWorkStatusController.dispose();
    summaryController.dispose();
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
        _populateFields(resume);
      } else {
        throw Exception('Failed to load resume');
      }
    } catch (e) {
      _showError('Failed to load resume data: $e');
    } finally {
      isLoadingDetails.value = false;
    }
  }

  // Populate text fields with resume data
  void _populateFields(Resume resume) {
    resumeNameController.text = resume.resumeName;
    fullNameController.text = resume.personalInfo.fullName;
    emailController.text = resume.personalInfo.email;
    phoneController.text = resume.personalInfo.phone;
    addressController.text = resume.personalInfo.address;
    socialMediaController.text = resume.personalInfo.socialMediaLink;
    githubController.text = resume.personalInfo.githubLink;
    workAuthorizationController.text = resume.personalInfo.workAuthorization;
    clearancesController.text = resume.personalInfo.clearance;
    openToWorkStatusController.text = resume.personalInfo.openToWork;
    summaryController.text = resume.personalInfo.summary;
  }

  // Update personal information
  Future<void> updatePersonalInfo(String resumeId) async {
    //if (!_validateFields()) return;

    try {
      isUpdating.value = true;

      final updateData = {
        'resume_name': resumeNameController.text.trim(),
        'personalInfo': {
          'full_name': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'social_media_link': socialMediaController.text.trim(),
          'github_link': githubController.text.trim(),
          'work_authorization': workAuthorizationController.text.trim(),
          'clearance': clearancesController.text.trim(),
          'open_to_work': openToWorkStatusController.text.trim(),
          'summury': summaryController.text.trim(),
          'address': addressController.text.trim(),
        }
      };

      final response = await ApiService.patch(
          "resume/$resumeId",
          body: updateData
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Personal information updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Refresh resume list
        await fetchResumes();
        Get.back();
      } else {
        final errorData = json.decode(response.message);
        throw Exception(errorData['message'] ?? 'Failed to update');
      }
    } catch (e) {
      _showError('Failed to update: $e');
    } finally {
      isUpdating.value = false;
    }
  }



  Future<void> createPersonalInfo() async {
    try {
      isUpdating.value = true;

      // Hardcoded test data - exact copy from Postman
      final updateData = {
        "resume_name": resumeNameController.text,
        "personalInfo": {
          "full_name": fullNameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "social_media_link": socialMediaController.text,
          "github_link": githubController.text,
          "work_authorization": workAuthorizationController.text,
          "clearance": clearancesController.text,
          "open_to_work": openToWorkStatusController.text,
          "summury": summaryController.text,
          "address": addressController.text
        }
      };

      final response = await ApiService.post(
        "resume",
        body: updateData,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
        },
      );

      // ... rest of the code
    } catch (e) {
      _showError('Failed to create resume: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete resume
  Future<void> deleteResume(String resumeId) async {
    try {
      final response = await ApiService.delete(
          ApiEndPoint.resumeData + "/" + resumeId
      );

      if (response.statusCode == 200) {
        await fetchResumes();
        Get.snackbar(
          'Success',
          'Resume deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete resume: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Validate required fields
  bool _validateFields() {
    if (resumeNameController.text.trim().isEmpty) {
      _showValidationError('Please enter resume name');
      return false;
    }
    if (fullNameController.text.trim().isEmpty) {
      _showValidationError('Please enter your full name');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      _showValidationError('Please enter your email');
      return false;
    }
    if (!_isValidEmail(emailController.text.trim())) {
      _showValidationError('Please enter a valid email address');
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      _showValidationError('Please enter your phone number');
      return false;
    }
    return true;
  }

  // Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Set open to work status
  void setOpenToWorkStatus(String status) {
    openToWorkStatusController.text = status;
  }

  // Get resume subtitle for list
  String getResumeSubtitle(Resume resume) {
    if (resume.workExperiences.isNotEmpty) {
      final exp = resume.workExperiences.first;
      return '${exp.designation} with experience at ${exp.company}';
    } else if (resume.personalInfo.summary.isNotEmpty) {
      return resume.personalInfo.summary;
    } else {
      return 'No description available';
    }
  }

  // Show error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Show validation error
  void _showValidationError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}