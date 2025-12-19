import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:embeyi/core/utils/helpers/other_helper.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../home/data/model/job_details_model.dart';

class RecruiterEditJobPostController extends GetxController {
  final jobTitleController = TextEditingController();
  final minSalaryController = TextEditingController();
  final maxSalaryController = TextEditingController();
  final jobLocationController = TextEditingController();
  final companyDescriptionController = TextEditingController();
  final applicationDeadlineController = TextEditingController();

  final selectedJobType = Rx<String?>('FULL_TIME');
  final selectedExperienceLevel = Rx<String?>('1-3yrs');
  final selectedJobLevel = Rx<String?>('MID_LEVEL');
  final selectedCategoryName = Rx<String?>(null);

  final List<String> jobTypes = ['FULL_TIME', 'PART_TIME', 'FREELANCE', 'INTERNSHIP', 'REMOTE'];
  final List<String> experienceLevels = ['0-1yrs', '1-3yrs', '3-5yrs', '5-10yrs', '10+yrs'];
  final List<String> jobLevels = ['ENTRY_LEVEL', 'MID_LEVEL', 'SENIOR_LEVEL'];
  final categories = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final Rx<JobDetailsData?> jobDetails = Rx<JobDetailsData?>(null);
  final RxList<String> skills = <String>[].obs;

  // Image handling - Changed to File type
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString existingImageUrl = ''.obs;
  final RxString selectedImagePath = "".obs;
  final imageChanged = false.obs;
  final ImagePicker _picker = ImagePicker();

  String postId = "";
  String categoryId = "";

  @override
  void onInit() {
    super.onInit();
    postId = Get.arguments['postId'] ?? '';
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      await fetchCategories();
      await fetchJobDetails();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    final response = await ApiService.get("job-category");
    if (response.statusCode == 200) {
      var data = response.data['data'] as List;
      categories.assignAll(data.map((e) => {"id": e['_id'], "name": e['name']}).toList());
    }
  }

  Future<void> fetchJobDetails() async {
    final response = await ApiService.get("job-post/$postId");
    if (response.statusCode == 200) {
      final data = JobDetailsModel.fromJson(response.data).data;
      jobDetails.value = data;
      _populateFields(data);
    }
  }

  void _populateFields(JobDetailsData data) {
    jobTitleController.text = data.title ?? "";
    minSalaryController.text = data.minSalary.toString();
    maxSalaryController.text = data.maxSalary.toString();
    jobLocationController.text = data.location;
    companyDescriptionController.text = data.description;
    applicationDeadlineController.text = data.deadline.split('T').first;
    selectedCategoryName.value = data.category;
    categoryId = data.categoryId;
    selectedJobType.value = data.jobType;
    selectedExperienceLevel.value = data.experienceLevel;
    selectedJobLevel.value = data.jobLevel;
    skills.assignAll(data.requiredSkills);
    existingImageUrl.value = data.thumbnail;
  }

  void setCategory(String name) {
    selectedCategoryName.value = name;
    categoryId = categories.firstWhere((e) => e['name'] == name)['id'];
  }

  // Pick Image - Updated to use File
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        selectedImagePath.value = image.path;
        imageChanged.value = true;
        update();
        debugPrint("Image Path: ${image.path}");
      }
    } catch(e) {
      debugPrint("Error picking image: $e");
    }
  }

  void showAddSkillDialog() {
    final ctrl = TextEditingController();
    Get.dialog(AlertDialog(
      title: const Text('Add Skill'),
      content: TextField(controller: ctrl, autofocus: true),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(onPressed: () {
          if (ctrl.text.isNotEmpty) {
            skills.add(ctrl.text.trim());
            Get.back();
          }
        }, child: const Text('Add')),
      ],
    ));
  }

  void removeSkill(String s) => skills.remove(s);

  Future<void> selectDeadlineDate() async => OtherHelper.openDatePickerDialog(applicationDeadlineController);

  Future<void> submitJobPost() async {
    try {
      isLoading.value = true;
      final Map<String, String> body = {};

      void addIfValid(String key, String? value) {
        if (value != null && value.trim().isNotEmpty) body[key] = value.trim();
      }

      addIfValid('title', jobTitleController.text);
      addIfValid('description', companyDescriptionController.text);
      addIfValid('category', categoryId);
      addIfValid('job_type', selectedJobType.value);
      addIfValid('job_level', selectedJobLevel.value);
      addIfValid('experience_level', selectedExperienceLevel.value);
      addIfValid('min_salary', minSalaryController.text);
      addIfValid('max_salary', maxSalaryController.text);
      addIfValid('location', jobLocationController.text);
      addIfValid('deadline', applicationDeadlineController.text);

      for (int i = 0; i < skills.length; i++) {
        body['required_skills[$i]'] = skills[i];

        debugPrint("========== SUBMITTING JOB POST ==========");
        debugPrint("Has Image: ${selectedImagePath.value.isNotEmpty}");
        debugPrint("Image Path: ${selectedImagePath.value}");
        debugPrint("Body: $body");

        // Check if file exists before uploading
        if (selectedImagePath.value.isNotEmpty) {
          final file = File(selectedImagePath.value);
          final exists = await file.exists();
          debugPrint("File exists: $exists");
          if (exists) {
            final fileSize = await file.length();
            debugPrint("File size: ${fileSize} bytes");
          }
        }
      }

      String? imagePath = selectedImagePath.value.isNotEmpty ? selectedImagePath.value : null;

      final response = (imageChanged.value && imagePath != null)
          ? await ApiService.multipartImage("job-post/$postId",method: 'PATCH',body: body,files: [{"name": "image", "image": imagePath}])
          : await ApiService.patch("job-post/$postId", body: body);


      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(result: true);
        Get.snackbar('Success', 'Post updated successfully', backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}