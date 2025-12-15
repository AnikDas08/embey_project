import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/screen/job_seeker_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/resume_model.dart';

class CertificationController extends GetxController {
  // Observable states
  var certifications = <Certification>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  var isCreating = false.obs;

  // Resume ID (empty string means create mode)
  String? resumeId;
  Map<dynamic,dynamic>? personalInfo;
  String? resumeName;
  List<dynamic>? coreFeatures;
  List<dynamic>? workExperiences;
  List<dynamic>? projects;
  List<dynamic>? educations;
  bool get isCreateMode => resumeId == null || resumeId!.isEmpty;

  @override
  void onInit() {
    super.onInit();
    // Get resumeId from arguments
    final arg=Get.arguments as Map<dynamic,dynamic>;
    resumeId=arg["resumeId"]?.toString();
    personalInfo=arg["personalInformation"];
    resumeName=arg["resumeName"]?.toString();
    coreFeatures=arg["coreFeatures"];
    workExperiences=arg["workExperiences"];
    projects=arg["projects"];
    educations=arg["educations"];

    // Only fetch if we have a resumeId (edit mode)
    if (resumeId != null && resumeId!.isNotEmpty) {
      fetchCertifications();
    } else {
      // In create mode, start with empty list
      print("Create mode - starting with empty certification list");
    }
  }

  /// Fetch certifications from API (GET) - Only for edit mode
  Future<void> fetchCertifications() async {
    try {
      isLoading.value = true;

      print("Fetching certifications for resume ID: $resumeId");

      final response = await ApiService.get("resume/$resumeId");

      print("API Response Status: ${response.statusCode}");
      print("API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle both single object and data wrapper response
        final resumeData = data["data"] ?? data;
        final List<dynamic> certificationsList =
            resumeData['certifications'] ?? [];

        certifications.value = certificationsList
            .map((e) => Certification.fromJson(e))
            .toList();

        print(
            "Certifications loaded successfully: ${certifications.length} certifications");
      } else {
        throw Exception(
            'Failed to load certifications: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching certifications: $e");
      _showError('Failed to load certifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new certification
  void addCertification(Certification certification) {
    certifications.add(certification);
    print("Certification added: ${certification.title}");
    print("Total certifications: ${certifications.length}");
  }

  /// Update certification at index
  void updateCertification(int index, Certification certification) {
    if (index >= 0 && index < certifications.length) {
      certifications[index] = certification;
      print("Certification updated at index $index: ${certification.title}");
    }
  }

  /// Remove certification at index
  void removeCertification(int index) {
    if (index >= 0 && index < certifications.length) {
      final removed = certifications[index];
      certifications.removeAt(index);
      print("Certification removed: ${removed.title}");
      print("Remaining certifications: ${certifications.length}");
    }
  }

  /// Create new resume with certifications (POST) - For create mode
  Future<void> createResumeWithCertifications() async {
    if (certifications.isEmpty) {
      _showValidationError('Please add at least one certification');
      return;
    }

    try {
      isCreating.value = true;

      // Convert certifications to JSON format (no _id for new certifications)
      final certificationsJson = certifications.map((certification) {
        return {
          'title': certification.title,
          if (certification.description != null &&
              certification.description!.isNotEmpty)
            'description': certification.description,
          if (certification.link != null && certification.link!.isNotEmpty)
            'link': certification.link,
        };
      }).toList();

      final body = {
        "resume_name":resumeName,
        "personalInfo":personalInfo,
        "core_features":coreFeatures,
        "workExperiences":workExperiences,
        "projects":projects,
        "educations":educations,
        "certifications": certificationsJson,
      };
      print("Creating resume with certifications: 🤣🤣🤣🤣 ");
      print(body);



      final response = await ApiService.post(
        "resume",
        body: body,
      );

      print("Create response status: ${response.statusCode}");
      print("Create response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Successfully created'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Get.offAll(()=>JobSeekerProfileScreen());
      }
    } catch (e) {
      print("Error creating resume: $e");
      _showError('Failed to create resume: $e');
    } finally {
      isCreating.value = false;
    }
  }

  /// Save/Update certifications via PATCH API - Only for edit mode
  Future<void> saveCertifications() async {
    if (certifications.isEmpty) {
      _showValidationError('Please add at least one certification');
      return;
    }

    try {
      isSaving.value = true;

      // Convert certifications to JSON format
      final certificationsJson = certifications.map((certification) {
        return {
          if (certification.id.isNotEmpty) '_id': certification.id,
          'title': certification.title,
          if (certification.description != null &&
              certification.description!.isNotEmpty)
            'description': certification.description,
          if (certification.link != null && certification.link!.isNotEmpty)
            'link': certification.link,
        };
      }).toList();

      final updateData = {
        'certifications': certificationsJson,
      };

      print("Updating certifications for resume ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Update response status: ${response.statusCode}");
      print("Update response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Certifications updated successfully');

        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true);
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(
            errorData['message'] ?? 'Failed to update certifications');
      }
    } catch (e) {
      print("Error updating certifications: $e");
      _showError('Failed to update certifications: $e');
    } finally {
      isSaving.value = false;
    }
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