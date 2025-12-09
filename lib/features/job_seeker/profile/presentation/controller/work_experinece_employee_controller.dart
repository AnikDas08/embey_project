import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';

class WorkExperienceController extends GetxController {
  bool isLoading = false;

  UserData? profileData;
  RxString name = "".obs;
  RxString profileImage = "".obs;

  // Work Experience list
  RxList<WorkExperience> workExperienceList = <WorkExperience>[].obs;

  // Text controllers for add/edit work experience
  final titleController = TextEditingController();
  final companyController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  RxBool isCurrentJob = false.obs;

  String? currentWorkExperienceId;
  String startDateApi = "";
  String endDateApi = "";

  @override
  void onInit() {
    super.onInit();
    getProfileRepo();
  }

  @override
  void onClose() {
    titleController.dispose();
    companyController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }

  // Set work experience data for editing
  void setWorkExperienceForEdit(WorkExperience workExperience) {
    currentWorkExperienceId = workExperience.id;
    titleController.text = workExperience.title ?? '';
    companyController.text = workExperience.company ?? '';
    descriptionController.text = workExperience.description ?? '';
    locationController.text = workExperience.location ?? '';
    isCurrentJob.value = workExperience.isCurrentJob ?? false;

    // Format dates for display
    if (workExperience.startDate != null) {
      try {
        DateTime date = DateTime.parse(workExperience.startDate!);
        startDateController.text = DateFormat('dd MMM yyyy').format(date);
        startDateApi = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        startDateController.text = '';
      }
    }

    if (workExperience.endDate != null && !isCurrentJob.value) {
      try {
        DateTime date = DateTime.parse(workExperience.endDate!);
        endDateController.text = DateFormat('dd MMM yyyy').format(date);
        endDateApi = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        endDateController.text = '';
      }
    }
  }

  // Clear work experience form
  void clearWorkExperienceForm() {
    currentWorkExperienceId = null;
    titleController.clear();
    companyController.clear();
    startDateController.clear();
    endDateController.clear();
    descriptionController.clear();
    locationController.clear();
    isCurrentJob.value = false;
    startDateApi = "";
    endDateApi = "";
  }

  /// Select Start Date
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      startDateController.text = DateFormat('dd MMM yyyy').format(picked);
      startDateApi = DateFormat('yyyy-MM-dd').format(picked);
      update();
    }
  }

  /// Select End Date
  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      endDateController.text = DateFormat('dd MMM yyyy').format(picked);
      endDateApi = DateFormat('yyyy-MM-dd').format(picked);
      update();
    }
  }

  /// Validate Fields
  bool _validateFields() {
    if (titleController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter job title");
      return false;
    }

    if (companyController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter company name");
      return false;
    }

    if (startDateController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please select start date");
      return false;
    }

    if (!isCurrentJob.value && endDateController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please select end date or mark as current job");
      return false;
    }

    if (locationController.text.trim().isEmpty) {
      Utils.errorSnackBar(0, "Please enter location");
      return false;
    }

    return true;
  }

  /// Add Work Experience
  Future<void> addWorkExperience() async {
    final token = LocalStorage.token;
    if (token.isEmpty) {
      Utils.errorSnackBar(0, "Token not found, please login again");
      return;
    }

    if (!_validateFields()) {
      return;
    }

    isLoading = true;
    update();

    try {
      final data = {
        'title': titleController.text.trim(),
        'company': companyController.text.trim(),
        'startDate': startDateApi,
        'endDate': isCurrentJob.value ? "" : endDateApi,
        'description': descriptionController.text.trim(),
        'location': locationController.text.trim(),
        'isCurrentJob': isCurrentJob.value,
      };

      print("============ ADD WORK EXPERIENCE ============");
      print("Body: $data");

      final response = await ApiService.post(
          'user/work-experience',
          body: data,
          header: {"Authorization": "Bearer $token"}
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        Utils.successSnackBar("Success", 'Work experience added successfully');
        getProfileRepo();
        Get.back();
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      print("❌ Error adding work experience: $e");
      Utils.errorSnackBar(0, "Failed to add work experience: ${e.toString()}");
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Update Work Experience
  Future<void> updateWorkExperience() async {
    if (currentWorkExperienceId == null) return;

    final token = LocalStorage.token;
    if (token.isEmpty) {
      Utils.errorSnackBar(0, "Token not found, please login again");
      return;
    }

    if (!_validateFields()) {
      return;
    }

    isLoading = true;
    update();

    try {
      final data = {
        'title': titleController.text.trim(),
        'company': companyController.text.trim(),
        'startDate': startDateApi,
        'endDate': isCurrentJob.value ? null : endDateApi,
        'description': descriptionController.text.trim(),
        'location': locationController.text.trim(),
        'isCurrentJob': isCurrentJob.value,
      };

      final response = await ApiService.patch(
          'user/work-experience/$currentWorkExperienceId',
          body: data,
          header: {"Authorization": "Bearer $token"}
      );

      if (response.statusCode == 200) {
        Utils.successSnackBar("Success", 'Work experience updated successfully');
        getProfileRepo();
        //Get.snackbar("Success", "Word experience updated successful");
        Get.back();
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, "Failed to update work experience: ${e.toString()}");
    } finally {
      isLoading = false;
      update();
    }
  }


  /// Delete Work Experience
  Future<void> deleteWorkExperience(String workExperienceId) async {
    try {
      final response = await ApiService.delete(
          "user/work-experience/$workExperienceId",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        workExperienceList.removeWhere((exp) => exp.id == workExperienceId);
        update();
        Utils.successSnackBar("Success", "Work experience deleted successfully");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, "Failed to delete work experience: ${e.toString()}");
    }
  }

  /// Get Profile with Work Experience
  Future<void> getProfileRepo() async {
    isLoading = true;
    update();

    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final profileModel = ProfileModel.fromJson(response.data);
        profileData = profileModel.data;

        name.value = profileData?.name ?? "";
        profileImage.value = profileData?.image ?? "";

        // Parse Work Experience List
        if (response.data['data']['workExperiences'] != null) {
          workExperienceList.value = (response.data['data']['workExperiences'] as List)
              .map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList();

          print("✅ Loaded ${workExperienceList.length} work experience records");
        } else {
          workExperienceList.clear();
          print("⚠️ No work experience records found");
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}