import 'package:embeyi/core/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/resume_model.dart';

class EducationController extends GetxController {
  // Observable states
  var educations = <Education>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Resume ID
  String? resumeId;

  @override
  void onInit() {
    super.onInit();
    // Get resumeId from arguments
    resumeId = Get.arguments as String?;
    print("Received resume ID for Education: $resumeId");

    if (resumeId != null && resumeId!.isNotEmpty) {
      fetchEducations();
    }
  }

  /// Fetch educations from API (GET)
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
    }
  }

  /// Save educations via PATCH API
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

      print("Saving educations for resume ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Save response status: ${response.statusCode}");
      print("Save response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Educations saved successfully');

        // Wait a moment before going back
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true); // Return true to indicate successful update
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(errorData['message'] ?? 'Failed to save educations');
      }
    } catch (e) {
      print("Error saving educations: $e");
      _showError('Failed to save educations: $e');
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