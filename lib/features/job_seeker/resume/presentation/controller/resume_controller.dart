import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../../data/model/resume_model.dart';

class ResumeController extends GetxController {
  // Loading states
  var isLoading = false.obs;
  var isLoadingDetails = false.obs;
  var isUpdating = false.obs;
  var isLoadingMore = false.obs; // For pagination loading
  var isexternal = false;

  // Data
  var resumes = <Resume>[].obs;
  var currentResume = Rxn<Resume>();
  var errorMessage = ''.obs;

  // Pagination variables
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalItems = 0.obs;
  var hasMoreData = true.obs;
  final int pageLimit = 10;

  // PDF Upload states
  var selectedPdfFile = Rxn<File>();
  var selectedFileName = ''.obs;

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
  TextEditingController resumeNameTextController = TextEditingController();

  // ScrollController for detecting scroll end
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchResumes();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        // When user scrolls near bottom, load more
        if (!isLoadingMore.value && hasMoreData.value) {
          loadMoreResumes();
        }
      }
    });
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
    resumeNameTextController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Pick PDF File
  Future<void> pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        selectedPdfFile.value = File(result.files.single.path!);
        selectedFileName.value = result.files.single.name;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Clear PDF Selection
  void clearPdfSelection() {
    selectedPdfFile.value = null;
    selectedFileName.value = '';
    resumeNameTextController.clear();
  }

  // Fetch resumes with pagination (initial load or refresh)
  Future<void> fetchResumes({bool isRefresh = false}) async {
    try {
      // Reset pagination on refresh
      if (isRefresh) {
        currentPage.value = 1;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.get(
        "${ApiEndPoint.resumeData}?page=${currentPage.value}&limit=$pageLimit",
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse pagination info
        if (data['pagination'] != null) {
          totalPages.value = data['pagination']['totalPage'] ?? 1;
          totalItems.value = data['pagination']['total'] ?? 0;
          hasMoreData.value = currentPage.value < totalPages.value;
        }

        // Parse resume data
        final resumeResponse = ResumeResponse.fromJson(data);

        // Replace list on refresh, append on load more
        if (isRefresh || currentPage.value == 1) {
          resumes.value = resumeResponse.data;
        } else {
          resumes.addAll(resumeResponse.data);
        }

        print("resumes loaded: ${resumes.length}/${totalItems.value}");
      }
    } catch (e) {
      errorMessage.value = 'Failed to load resumes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Load more resumes (pagination)
  Future<void> loadMoreResumes() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await ApiService.get(
        "${ApiEndPoint.resumeData}?page=${currentPage.value}&limit=$pageLimit",
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Update pagination info
        if (data['pagination'] != null) {
          totalPages.value = data['pagination']['totalPage'] ?? 1;
          hasMoreData.value = currentPage.value < totalPages.value;
        }

        // Add new resumes to list
        final resumeResponse = ResumeResponse.fromJson(data);
        resumes.addAll(resumeResponse.data);

        print("loaded more resumes: ${resumes.length}/${totalItems.value}");
      }
    } catch (e) {
      currentPage.value--; // Revert page if error
      Get.snackbar(
        'Error',
        'Failed to load more resumes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Fetch single resume details by ID
  Future<void> fetchResumeById(String resumeId) async {
    try {
      isLoadingDetails.value = true;
      errorMessage.value = '';

      final response = await ApiService.get("resume/$resumeId");

      if (response.statusCode == 200) {
        final data = response.data;
        final resume = Resume.fromJson(data["data"]);
        currentResume.value = resume;
        isexternal = resume.is_external_resume ?? false;
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

  // Post External Resume (Upload PDF)
  Future<void> postExternalResume() async {
    if (resumeNameTextController.text.trim().isEmpty) {
      _showValidationError('Please enter resume name');
      return;
    }

    if (selectedPdfFile.value == null) {
      _showValidationError('Please select a PDF file');
      return;
    }

    try {
      isUpdating.value = true;
      errorMessage.value = '';

      var body = {
        "name": resumeNameTextController.text.trim(),
      };

      final response = await ApiService.multipartImage(
        "resume/external-resume",
        body: body,
        method: "POST",
        files: [
          {
            "name": "resume",
            "image": selectedPdfFile.value!.path,
          }
        ],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'Success',
          'Resume uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        clearPdfSelection();
        await fetchResumes(isRefresh: true);

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      } else {
        throw Exception('Failed to upload resume');
      }
    } catch (e) {
      _showError('Failed to upload resume: $e');
      rethrow;
    } finally {
      isUpdating.value = false;
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

      final response =
      await ApiService.patch("resume/$resumeId", body: updateData);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Personal information updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await fetchResumes(isRefresh: true);
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Resume created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await fetchResumes(isRefresh: true);
        Get.back();
      } else {
        throw Exception('Failed to create resume');
      }
    } catch (e) {
      _showError('Failed to create resume: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // Delete resume
  Future<void> deleteResume(String resumeId) async {
    try {
      final response =
      await ApiService.delete(ApiEndPoint.resumeData + "/" + resumeId);

      if (response.statusCode == 200) {
        await fetchResumes(isRefresh: true);
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