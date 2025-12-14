import 'dart:convert';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/config/api/api_end_point.dart';

class CoreSkillsController extends GetxController {
  // Text Controller
  final skillController = TextEditingController();

  // Observable states
  var skills = <String>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Suggested skills list
  final List<String> suggestedSkills = [
    'UI/UX Design',
    'Figma',
    'Adobe XD',
    'Sketch',
    'Prototyping',
    'Wireframing',
    'User Research',
    'Interaction Design',
  ];

  // Resume ID
  String? resumeId;

  // API Base URL - UPDATE THIS
  final String baseUrl = 'YOUR_API_BASE_URL';
  final String? authToken = 'YOUR_AUTH_TOKEN';

  @override
  void onInit() {
    super.onInit();
    resumeId = Get.arguments;
    if (resumeId != null) {
      fetchSkills();
    }
  }

  @override
  void onClose() {
    skillController.dispose();
    super.onClose();
  }

  /// Fetch skills from API (GET)
  Future<void> fetchSkills() async {
    try {
      isLoading.value = true;

      /*final response = await http.get(
        Uri.parse('resume/$resumeId'),
      );*/
      final response= await ApiService.get(
        ApiEndPoint.resumeData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> skillsList = data['data']['skills'] ?? [""];
        skills.value = skillsList.map((e) => e.toString()).toList();
      } else {
        throw Exception('Failed to load skills');
      }
    } catch (e) {
      _showError('Failed to load skills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add skill
  void addSkill() {
    final skillText = skillController.text.trim();
    if (skillText.isEmpty) {
      _showValidationError('Please enter a skill name');
      return;
    }

    if (skills.contains(skillText)) {
      _showValidationError('Skill already added');
      return;
    }

    skills.add(skillText);
    skillController.clear();
  }

  /// Remove skill
  void removeSkill(int index) {
    if (index >= 0 && index < skills.length) {
      skills.removeAt(index);
    }
  }

  /// Add suggested skill
  void addSuggestedSkill(String skill) {
    if (!skills.contains(skill)) {
      skills.add(skill);
    }
  }

  /// Check if skill is added
  bool isSkillAdded(String skill) {
    return skills.contains(skill);
  }

  /// Save skills via PATCH API
  Future<void> saveSkills() async {
    if (skills.isEmpty) {
      _showValidationError('Please add at least one skill');
      return;
    }

    try {
      isSaving.value = true;

      final updateData = {
        'skills': skills.toList(),
      };

      final response = await http.patch(
        Uri.parse('$baseUrl/resume/$resumeId'),
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null) 'Authorization': 'Bearer $authToken',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        _showSuccess('Skills saved successfully');
        Get.back(result: true);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to save skills');
      }
    } catch (e) {
      _showError('Failed to save skills: $e');
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
    );
  }
}