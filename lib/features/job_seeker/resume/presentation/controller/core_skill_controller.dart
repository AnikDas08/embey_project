import 'package:embeyi/core/config/route/app_routes.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/features/job_seeker/profile/presentation/screen/job_seeker_profile_screen.dart';
import 'package:embeyi/features/job_seeker/resume/presentation/screen/project_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../data/model/resume_model.dart';

class CoreSkillsNewController extends GetxController {
  // Observable states
  var coreFeatures = <CoreFeature>[].obs;
  var workExperiences = <WorkExperience>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Resume ID
  String? resumeId;

  // Store all resume data for creation
  Map<String, dynamic>? personalInfo;
  String? resumeName;
  List<Map<String, dynamic>>? educations;
  List<String>? skills;
  List<Map<String, dynamic>>? certifications;
  List<Map<String, dynamic>>? projects;

  @override
  void onInit() {
    super.onInit();

    /*// Get all arguments
    resumeId = Get.arguments;

    print("Received resume ID: $resumeId");
    print("Resume Name: $resumeName");

    if (resumeId != "") {
      fetchCoreSkills();
    }*/
    final arguments=Get.arguments as Map<dynamic,dynamic>?;
    if (arguments != null) {
      //resumeId = arguments["resumeId"];
      personalInfo = arguments["personalInformation"];
      resumeName = arguments["resumeName"]?.toString();
      resumeId=arguments["resumeId"]?.toString();
      print("resume id🤣🤣🤣: $resumeId");
    }
    if(resumeId!=""){
      fetchCoreSkills();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Fetch core features and work experiences from API (GET)
  Future<void> fetchCoreSkills() async {
    try {
      isLoading.value = true;

      print("Fetching core skills for resume ID: $resumeId");

      final response = await ApiService.get("resume/$resumeId");

      print("API Response Status: ${response.statusCode}");
      print("API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final resumeData = data["data"] ?? data;

        // Parse core features
        final List<dynamic> coreFeaturesList =
            resumeData['core_features'] ?? [];
        coreFeatures.value =
            coreFeaturesList.map((e) => CoreFeature.fromJson(e)).toList();

        // Parse work experiences
        final List<dynamic> workExpList = resumeData['workExperiences'] ?? [];
        workExperiences.value =
            workExpList.map((e) => WorkExperience.fromJson(e)).toList();

        print("Loaded ${coreFeatures.length} core features");
        print("Loaded ${workExperiences.length} work experiences");
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      _showError('Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new resume with all data (POST)
  Future<void> createResume() async {
    if (coreFeatures.isEmpty || workExperiences.isEmpty) {
      _showValidationError(
          'Please add at least one core feature and work experience');
      return;
    }

    try {
      isSaving.value = true;

      // Convert core features to JSON
      final coreFeaturesJson = coreFeatures.map((feature) {
        return {
          'title': feature.title,
          'description': feature.description,
        };
      }).toList();

      // Convert work experiences to JSON
      final workExperiencesJson = workExperiences.map((exp) {
        return {
          'title': exp.title,
          'company': exp.company,
          'startDate': exp.startDate,
          if (exp.endDate.isNotEmpty) 'endDate': exp.endDate,
          'description': exp.description,
          if (exp.location != null && exp.location!.isNotEmpty)
            'location': exp.location,
          if (exp.isCurrentJob != null) 'isCurrentJob': exp.isCurrentJob,
          'designation': exp.designation,
        };
      }).toList();


      /*final body={
        "resume_name":resumeName,
        "personalInfo":personalInfo,
        "core_features":coreFeaturesJson,
        "workExperiences":workExperiencesJson
      };*/

      /*// Build complete resume data
      final resumeData = {
        'resume_name': resumeName ?? 'Untitled Resume',
        'personalInfo': personalInfo ?? {},
        'educations': educations ?? [],
        'workExperiences': workExperiencesJson,
        'skills': skills ?? [],
        'core_features': coreFeaturesJson,
        'certifications': certifications ?? [],
        'projects': projects ?? [],
      };*/

      /*final response = await ApiService.post(
        "resume",
        body: body,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
        },
      );*/

      /*if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text('Resume created successfully'),
          ),
        );
        Get.offAll(()=>JobSeekerProfileScreen());
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(errorData['message'] ?? 'Failed to create resume');
      }*/


      Get.to(()=>ProjectScreen(),arguments: {
        "resumeId":"".toString(),
        "personalInformation":personalInfo,
        "resumeName":resumeName.toString(),
        "coreFeatures":coreFeaturesJson,
        "workExperiences":workExperiencesJson,
      });
    } catch (e) {
      print("Error creating resume: $e");
      _showError('Failed to create resume: $e');
    } finally {
      isSaving.value = false;
    }
  }

  /// Update existing resume (PATCH)
  Future<void> updateCoreSkills() async {
    if (coreFeatures.isEmpty || workExperiences.isEmpty) {
      _showValidationError(
          'Please add at least one core feature and work experience');
      return;
    }

    try {
      isSaving.value = true;

      // Convert core features to JSON
      final coreFeaturesJson = coreFeatures.map((feature) {
        return {
          if (feature.id.isNotEmpty) '_id': feature.id,
          'title': feature.title,
          'description': feature.description,
        };
      }).toList();

      // Convert work experiences to JSON
      final workExperiencesJson = workExperiences.map((exp) {
        return {
          if (exp.id.isNotEmpty) '_id': exp.id,
          'title': exp.title,
          'company': exp.company,
          'startDate': exp.startDate,
          if (exp.endDate.isNotEmpty) 'endDate': exp.endDate,
          'description': exp.description,
          if (exp.location != null && exp.location!.isNotEmpty)
            'location': exp.location,
          if (exp.isCurrentJob != null) 'isCurrentJob': exp.isCurrentJob,
          'designation': exp.designation,
        };
      }).toList();

      final updateData = {
        'core_features': coreFeaturesJson,
        'workExperiences': workExperiencesJson,
      };

      print("Updating core skills for resume ID: $resumeId");
      print("Update data: $updateData");

      final response = await ApiService.patch(
        "resume/$resumeId",
        body: updateData,
      );

      print("Update response status: ${response.statusCode}");
      print("Update response: ${response.data}");

      if (response.statusCode == 200) {
        _showSuccess('Core skills updated successfully');

        await Future.delayed(const Duration(milliseconds: 500));
        Get.back(result: true);
      } else {
        final errorData = response.data is Map ? response.data : {};
        throw Exception(
            errorData['message'] ?? 'Failed to update core skills');
      }
    } catch (e) {
      print("Error updating core skills: $e");
      _showError('Failed to update core skills: $e');
    } finally {
      isSaving.value = false;
    }
  }

  /// Core Features Methods
  void addCoreFeature(CoreFeature feature) {
    coreFeatures.add(feature);
    print("Core feature added: ${feature.title}");
  }

  void updateCoreFeature(int index, CoreFeature feature) {
    if (index >= 0 && index < coreFeatures.length) {
      coreFeatures[index] = feature;
      print("Core feature updated at index $index: ${feature.title}");
    }
  }

  void removeCoreFeature(int index) {
    if (index >= 0 && index < coreFeatures.length) {
      final removed = coreFeatures[index];
      coreFeatures.removeAt(index);
      print("Core feature removed: ${removed.title}");
    }
  }

  /// Work Experience Methods
  void addWorkExperience(WorkExperience experience) {
    workExperiences.add(experience);
    print("Work experience added: ${experience.title}");
  }

  void updateWorkExperience(int index, WorkExperience experience) {
    if (index >= 0 && index < workExperiences.length) {
      workExperiences[index] = experience;
      print("Work experience updated at index $index: ${experience.title}");
    }
  }

  void removeWorkExperience(int index) {
    if (index >= 0 && index < workExperiences.length) {
      final removed = workExperiences[index];
      workExperiences.removeAt(index);
      print("Work experience removed: ${removed.title}");
    }
  }

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