import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';

class EducationController extends GetxController {
  bool isLoading = false;

  UserData? profileData;
  RxString name = "".obs;
  RxString profileImage = "".obs;
  RxString designation = "".obs;
  RxString subscriptionPlan = "".obs;
  RxString gender = "".obs;

  // Education list
  RxList<Education> educationList = <Education>[].obs;

  // Text controllers for edit education
  final degreeController = TextEditingController();
  final instituteController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final passingYearController = TextEditingController();
  final gpaController = TextEditingController();

  String? currentEducationId;

  @override
  void onInit() {
    super.onInit();
    getProfileRepo();
  }

  @override
  void onClose() {
    degreeController.dispose();
    instituteController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    passingYearController.dispose();
    gpaController.dispose();
    super.onClose();
  }

  // Set education data for editing
  void setEducationForEdit(Education education) {
    currentEducationId = education.id;
    degreeController.text = education.degree ?? '';
    instituteController.text = education.institute ?? '';

    // Parse session to get start and end dates
    if (education.session != null && education.session!.contains('-')) {
      final dates = education.session!.split('-');
      startDateController.text = dates[0].trim();
      endDateController.text = dates.length > 1 ? dates[1].trim() : '';
    }

    passingYearController.text = education.passingYear?.toString() ?? '';
    gpaController.text = education.grade ?? '';
  }

  Future<void> addItem() async {
    isLoading = true;
    update();
    try {
      final data = {
        'degree': degreeController.text,
        'institute': instituteController.text,
        'startDate': startDateController.text,
        'endDate': endDateController.text,
        'passingYear': int.tryParse(passingYearController.text) ?? 0,
        'grade': gpaController.text,
      };
      final response = await ApiService.post(
        'user/education',
        body: data,
        header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        Utils.successSnackBar("Successful", 'Education added successfully');
        await getProfileRepo(); // Refresh profile data
        Get.back();
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

  // Clear education form
  void clearEducationForm() {
    currentEducationId = null;
    degreeController.clear();
    instituteController.clear();
    startDateController.clear();
    endDateController.clear();
    passingYearController.clear();
    gpaController.clear();
  }

  // Format date helper
  String getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  // Update education (you'll need to implement the API call)
  Future<void> updateEducation() async {
    if (currentEducationId == null) return;

    isLoading = true;
    update();

    try {
      // Prepare session string
      String session = '';
      if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
        session = '${startDateController.text}-${endDateController.text}';
      }

      final data = {
        'degree': degreeController.text,
        'institute': instituteController.text,
        'startDate': startDateController.text,
        'endDate': endDateController.text,
        'passingYear': int.tryParse(passingYearController.text) ?? 0,
        'grade': gpaController.text,
      };

      // TODO: Make API call to update education
      final response = await ApiService.patch(
        'user/education/$currentEducationId',
        body: data,
        header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        Utils.successSnackBar("Successful", 'Education updated successfully');
        await getProfileRepo(); // Refresh profile data
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }

      // For now, just show success and refresh
      //Utils.successSnackBar('Education updated successfully');
      await getProfileRepo();

    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

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

        // Set profile data
        profileData = profileModel.data;
        name.value = profileData?.name ?? "";
        profileImage.value = profileData?.image ?? "";
        designation.value = profileData?.designation ?? "";
        gender.value = profileData?.gender ?? "";

        // Set education list - Properly cast from List<dynamic> to List<Education>
        if (response.data['data']['educations'] != null) {
          educationList.value = (response.data['data']['educations'] as List)
              .map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList();
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