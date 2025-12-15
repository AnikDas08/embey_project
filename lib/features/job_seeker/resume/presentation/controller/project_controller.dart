import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/screen/profile/education_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/resume_model.dart';
import '../screen/education_screen.dart';

class ProjectController extends GetxController {
  // Observable states
  var projects = <Project>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  var isCreating = false.obs;

  // Resume ID (empty string means create mode)
  //Map<dynamic,dynamic>? resumeId;
  String? resumeId;
  Map<dynamic,dynamic>? personalInfo;
  String? resumeName;
  List<dynamic>? coreFeatures;
  List<dynamic>? workExperiences;

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
    if(resumeId!=""){
      fetchProjects();
    }
  }

  /// Fetch projects from API (GET) - Only for edit mode
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

  /// Create new resume with projects (POST) - For create mode
  Future<void> createResumeWithProjects() async {
    if (projects.isEmpty) {
      _showValidationError('Please add at least one project');
      return;
    }

    try {
      isCreating.value = true;

      // Convert projects to JSON format (no _id for new projects)
      final projectsJson = projects.map((project) {
        return {
          'title': project.title,
          'description': project.description,
          if (project.link != null && project.link!.isNotEmpty)
            'link': project.link,
        };
      }).toList();

      /*final body = {
        "resume_name":resumeName,
        "personalInfo":personalInfo,
        "core_features":coreFeatures,
        "workExperiences":workExperiences,
        "projects": projectsJson,  // ✅ Use your dynamic projects here
      };

      final response = await ApiService.post(
        "resume",
        body: body,
      );*/
      Get.to(()=>EducationScreenResume(),arguments: {
        "resumeId":"".toString(),
        "personalInformation":personalInfo,
        "resumeName":resumeName.toString(),
        "coreFeatures":coreFeatures,
        "workExperiences":workExperiences,
        "projects":projectsJson
      });
    } catch (e) {
      print("Error creating resume: $e");
      _showError('Failed to create resume: $e');
    } finally {
      isCreating.value = false;
    }
  }

  /// Add new project
  void addProject(Project project) {
    projects.add(project);
    print("Project added: ${project.title}");
    print("Total projects: ${projects.length}");
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
      print("Remaining projects: ${projects.length}");
    }
  }

  /// Save/Update projects via PATCH API - Only for edit mode
  Future<void> updateProjects() async {
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

      print("Updating projects for resume ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Update response status: ${response.statusCode}");
      print("Update response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Projects updated successfully');

        // Wait a moment before going back
        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true); // Return true to indicate successful update
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(errorData['message'] ?? 'Failed to update projects');
      }
    } catch (e) {
      print("Error updating projects: $e");
      _showError('Failed to update projects: $e');
    } finally {
      isSaving.value = false;
    }
  }

  /// Get projects as JSON for resume creation
  List<Map<String, dynamic>> getProjectsJson() {
    return projects.map((project) {
      return {
        'title': project.title,
        'description': project.description,
        if (project.link != null && project.link!.isNotEmpty)
          'link': project.link,
      };
    }).toList();
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