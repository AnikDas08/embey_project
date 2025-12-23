import 'dart:convert';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/core_skills_screen.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../data/model/resume_model.dart';

class PersonalInfoController extends GetxController {
  // Text Controllers
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

  // Observable states
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var currentResume = Rxn<Resume>();
  String? resumeId;

  @override
  void onInit() {
    super.onInit();
    // Get resumeId from arguments
    resumeId = Get.arguments as String?;
    print("Received resume ID: $resumeId");

    if (resumeId != null && resumeId!.isNotEmpty) {
      fetchResumeData();
    }
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

  /// Fetch resume data from API (GET)
  Future<void> fetchResumeData() async {
    try {
      isLoading.value = true;

      print("Fetching resume data for ID: $resumeId");

      final response = await ApiService.get("resume/$resumeId");

      print("API Response Status: ${response.statusCode}");
      print("API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle both single object and data wrapper response
        final resumeData = data["data"] ?? data;
        final resume = Resume.fromJson(resumeData);

        currentResume.value = resume;
        _populateFields(resume);

        print("Resume data loaded successfully");
      } else {
        throw Exception('Failed to load resume: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching resume: $e");
      _showError('Failed to load resume data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate text fields with resume data
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

    print("All fields populated successfully");
  }

  Future<void> createPersonalInfo() async {
    if (!_validateFields()) return;
    try {
      isUpdating.value = true;

      // Hardcoded test data - exact copy from Postman
      /*final updateData = {
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
      };*/

      /*final response = await ApiService.post(
        "resume",
        body: updateData,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
        },
      );*/
      /*if(response.statusCode==200){
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Successful created'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Get.back();
      }*/
      final resumeName={
        "resumeName":resumeNameController.text,
      };
      final updateData={
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
      Get.to(()=>CoreSkillsScreen(),arguments: {
        "resumeId": "".toString(),
        "personalInformation":updateData,
        "resumeName":resumeNameController.text,
      });

      // ... rest of the code
    } catch (e) {
      _showError('Failed to create resume: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  /// Update personal information via PATCH API
  Future<void> updatePersonalInfo() async {
    if (!_validateFields()) return;

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

      print("Updating resume with ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Update response status: ${response.statusCode}");
      print("Update response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Personal information updated successfully');

        // Wait a moment before going back
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true); // Return true to indicate successful update
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(errorData['message'] ?? 'Failed to update');
      }
    } catch (e) {
      print("Error updating resume: $e");
      _showError('Failed to update: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  /// Validate required fields
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

  /// Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Set open to work status
  void setOpenToWorkStatus(String status) {
    openToWorkStatusController.text = status;
    print("Open to work status set to: $status");
  }

  /// Show success message
  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }

  /// Show error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
    );
  }

  /// Show validation error
  void _showValidationError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );
  }
}