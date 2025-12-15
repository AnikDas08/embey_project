import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/certification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/resume_model.dart';

class EducationController extends GetxController {
  // Observable states
  var educations = <Education>[].obs;
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
  bool get isCreateMode => resumeId == null || resumeId!.isEmpty;

  @override
  void onInit() {
    super.onInit();
    // Get resumeId from arguments
    final args=Get.arguments as Map<dynamic,dynamic>;
    resumeId=args["resumeId"]?.toString();
    personalInfo=args["personalInformation"];
    resumeName=args["resumeName"]?.toString();
    coreFeatures=args["coreFeatures"];
    workExperiences=args["workExperiences"];
    projects=args["projects"];
    // Only fetch if we have a resumeId (edit mode)
    if (resumeId != "") {
      fetchEducations();
    } else {
      // In create mode, start with empty list
      print("Create mode - starting with empty education list");
    }
  }

  /// Fetch educations from API (GET) - Only for edit mode
  Future<void> fetchEducations() async {
    try {
      isLoading.value = true;

      print("Fetching educations for resume ID: $resumeId");

      final response = await ApiService.get("resume/$resumeId");

      print("API Response Status: ${response.statusCode}");
      print("API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle both single object and data wrapper response
        final resumeData = data["data"] ?? data;
        final List<dynamic> educationsList = resumeData['educations'] ?? [];

        educations.value = educationsList
            .map((e) => Education.fromJson(e))
            .toList();

        print("Educations loaded successfully: ${educations.length} educations");
      } else {
        throw Exception('Failed to load educations: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching educations: $e");
      _showError('Failed to load educations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new education
  void addEducation(Education education) {
    educations.add(education);
    print("Education added: ${education.degree}");
    print("Total educations: ${educations.length}");
  }

  /// Update education at index
  void updateEducation(int index, Education education) {
    if (index >= 0 && index < educations.length) {
      educations[index] = education;
      print("Education updated at index $index: ${education.degree}");
    }
  }

  /// Remove education at index
  void removeEducation(int index) {
    if (index >= 0 && index < educations.length) {
      final removed = educations[index];
      educations.removeAt(index);
      print("Education removed: ${removed.degree}");
      print("Remaining educations: ${educations.length}");
    }
  }

  /// Create new resume with educations (POST) - For create mode
  Future<void> createResumeWithEducations() async {
    if (educations.isEmpty) {
      _showValidationError('Please add at least one education');
      return;
    }

    try {
      isCreating.value = true;

      // Convert educations to JSON format (no _id for new educations)
      final educationsJson = educations.map((edu) {
        return {
          'degree': edu.degree,
          'institution': edu.institution,
          if (edu.startDate != null) 'startDate': edu.startDate,
          if (edu.endDate != null) 'endDate': edu.endDate,
          if (edu.grade != null) 'grade': edu.grade,
          if (edu.passingYear != null) 'passingYear': edu.passingYear,
        };
      }).toList();

      final body = {
        "educations": educationsJson,
      };

     /* print("Creating resume with educations:");
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
        Get.back();
      }*/
      Get.to(()=>CertificationScreen(),arguments: {
        "resumeId":"".toString(),
        "personalInformation":personalInfo,
        "resumeName":resumeName.toString(),
        "coreFeatures":coreFeatures,
        "workExperiences":workExperiences,
        "projects":projects,
        "educations":educationsJson
      });
    } catch (e) {
      print("Error creating resume: $e");
      _showError('Failed to create resume: $e');
    } finally {
      isCreating.value = false;
    }
  }

  /// Save/Update educations via PATCH API - Only for edit mode
  Future<void> saveEducations() async {
    if (educations.isEmpty) {
      _showValidationError('Please add at least one education');
      return;
    }

    try {
      isSaving.value = true;

      // Convert educations to JSON format
      final educationsJson = educations.map((edu) {
        return {
          if (edu.id.isNotEmpty) '_id': edu.id,
          'degree': edu.degree,
          'institution': edu.institution,
          if (edu.startDate != null) 'startDate': edu.startDate,
          if (edu.endDate != null) 'endDate': edu.endDate,
          if (edu.grade != null) 'grade': edu.grade,
          if (edu.passingYear != null) 'passingYear': edu.passingYear,
        };
      }).toList();

      final updateData = {
        'educations': educationsJson,
      };

      print("Updating educations for resume ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Update response status: ${response.statusCode}");
      print("Update response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Educations updated successfully');

        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true);
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(errorData['message'] ?? 'Failed to update educations');
      }
    } catch (e) {
      print("Error updating educations: $e");
      _showError('Failed to update educations: $e');
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