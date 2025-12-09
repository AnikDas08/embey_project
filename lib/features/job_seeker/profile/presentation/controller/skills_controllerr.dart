import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';

class SkillsController extends GetxController {
  // Make all state variables reactive with .obs
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  final Rx<UserData?> profileData = Rx<UserData?>(null);

  // Skills list - already reactive
  final RxList<String> skillsList = <String>[].obs;

  // Text controller for adding skills
  final skillController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getProfileRepo();
  }

  @override
  void onClose() {
    skillController.dispose();
    super.onClose();
  }

  /// Get Profile with Skills
  Future<void> getProfileRepo() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get(ApiEndPoint.user);
      print("response $response");

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          final profileModel = ProfileModel.fromJson(responseData);
          profileData.value = profileModel.data;

          // Parse Skills List with null safety
          final data = responseData['data'];
          if (data != null &&
              data is Map<String, dynamic> &&
              data['skills'] != null) {
            try {
              skillsList.value = List<String>.from(data['skills']);
              print("✅ Loaded ${skillsList.length} skills");
            } catch (e) {
              print("⚠️ Error parsing skills: $e");
              skillsList.clear();
            }
          } else {
            skillsList.clear();
            print("⚠️ No skills found");
          }
        } else {
          Utils.errorSnackBar(0, "Invalid response format");
        }
      } else {
        Utils.errorSnackBar(
            response.statusCode ?? 0,
            response.message ?? "Failed to load profile"
        );
      }
    } catch (e) {
      print("❌ Error in getProfileRepo: $e");
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Add Skill to List
  void addSkill() {
    String skill = skillController.text.trim();

    if (skill.isEmpty) {
      Utils.errorSnackBar(0, "Please enter a skill");
      return;
    }

    // Check if skill already exists (case insensitive)
    bool alreadyExists = skillsList.any(
            (existingSkill) => existingSkill.toLowerCase() == skill.toLowerCase()
    );

    if (alreadyExists) {
      Utils.errorSnackBar(0, "This skill already exists");
      return;
    }

    // Add skill to list (automatically triggers UI update)
    skillsList.add(skill);
    skillController.clear();
  }

  /// Remove Skill from List
  void removeSkill(int index) {
    if (index >= 0 && index < skillsList.length) {
      skillsList.removeAt(index);
    }
  }

  /// Update Skills (Send to API)
  Future<void> updateSkills() async {
    final token = LocalStorage.token;
    if (token == null || token.isEmpty) {
      Utils.errorSnackBar(0, "Token not found, please login again");
      return;
    }

    if (skillsList.isEmpty) {
      Utils.errorSnackBar(0, "Please add at least one skill");
      return;
    }

    isUpdating.value = true;

    try {
      final body = {
        "skills": skillsList.toList(),
      };

      print("============ UPDATE SKILLS ============");
      print("Body: $body");

      final response = await ApiService.patch(
          ApiEndPoint.user,
          body: body,
          header: {"Authorization": "Bearer $token"}
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        Utils.successSnackBar("Success", "Skills updated successfully");

        // Refresh profile data
        await getProfileRepo();

        Get.back();
      } else {
        Utils.errorSnackBar(
            response.statusCode ?? 0,
            response.message ?? "Failed to update skills"
        );
      }
    } catch (e) {
      print("❌ Error updating skills: $e");
      Utils.errorSnackBar(0, "Failed to update skills: ${e.toString()}");
    } finally {
      isUpdating.value = false;
    }
  }

  /// Clear all skills (for testing or reset)
  void clearAllSkills() {
    skillsList.clear();
    skillController.clear();
  }
}