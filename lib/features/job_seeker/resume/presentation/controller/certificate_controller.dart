import 'package:embeyi/core/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/resume_model.dart';

class CertificationController extends GetxController {
  // Observable states
  var certifications = <Certification>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Resume ID
  String? resumeId;

  @override
  void onInit() {
    super.onInit();
    // Get resumeId from arguments
    resumeId = Get.arguments as String?;
    print("Received resume ID for Certifications: $resumeId");

    if (resumeId != null && resumeId!.isNotEmpty) {
      fetchCertifications();
    }
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }

  /// Fetch certifications from API (GET)
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
      _showSuccess('Certification removed successfully');
    }
  }

  /// Save certifications via PATCH API
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
        };
      }).toList();

      final updateData = {
        'certifications': certificationsJson,
      };

      print("Saving certifications for resume ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Save response status: ${response.statusCode}");
      print("Save response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Certifications saved successfully');

        // Wait a moment before going back
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true); // Return true to indicate successful update
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(
            errorData['message'] ?? 'Failed to save certifications');
      }
    } catch (e) {
      print("Error saving certifications: $e");
      _showError('Failed to save certifications: $e');
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