import 'package:embeyi/core/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/resume_model.dart';

class ProjectController extends GetxController {
  // Observable states
  var projects = <Project>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Resume ID
  String? resumeId;

  @override
  void onInit() {
    super.onInit();
    // Get resumeId from arguments
    resumeId = Get.arguments as String?;
    print("Received resume ID for Projects: $resumeId");

    if (resumeId != null && resumeId!.isNotEmpty) {
      fetchProjects();
    }
  }

  /// Fetch projects from API (GET)
  Future<void> fetchProjects() async {
    try {
      isLoading.value = true;

      print("Fetching projects for resume ID: $resumeId");

      final response = await ApiService.get("resume/$resumeId");

      print("API Response Status: ${response.statusCode}");
      print("API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle both single object and data wrapper response
        final resumeData = data["data"] ?? data;
        final List<dynamic> projectsList = resumeData['projects'] ?? [];

        projects.value = projectsList
            .map((e) => Project.fromJson(e))
            .toList();

        print("Projects loaded successfully: ${projects.length} projects");
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching projects: $e");
      _showError('Failed to load projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new project
  void addProject(Project project) {
    projects.add(project);
    print("Project added: ${project.title}");
  }

  /// Update project at index
  void updateProject(int index, Project project) {
    if (index >= 0 && index < projects.length) {
      projects[index] = project;
      print("Project updated at index $index: ${project.title}");
    }
  }

  /// Remove project at index
  void removeProject(int index) {
    if (index >= 0 && index < projects.length) {
      final removed = projects[index];
      projects.removeAt(index);
      print("Project removed: ${removed.title}");
    }
  }

  /// Save projects via PATCH API
  Future<void> saveProjects() async {
    if (projects.isEmpty) {
      _showValidationError('Please add at least one project');
      return;
    }

    try {
      isSaving.value = true;

      // Convert projects to JSON format
      final projectsJson = projects.map((project) {
        return {
          if (project.id.isNotEmpty) '_id': project.id,
          'title': project.title,
          'description': project.description,
          if (project.link != null && project.link!.isNotEmpty)
            'link': project.link,
        };
      }).toList();

      final updateData = {
        'projects': projectsJson,
      };

      print("Saving projects for resume ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Save response status: ${response.statusCode}");
      print("Save response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Projects saved successfully');

        // Wait a moment before going back
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true); // Return true to indicate successful update
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(errorData['message'] ?? 'Failed to save projects');
      }
    } catch (e) {
      print("Error saving projects: $e");
      _showError('Failed to save projects: $e');
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