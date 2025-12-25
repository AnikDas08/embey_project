import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/home_model.dart';
import '../../data/model/job_post.dart';

class RecomendedJodController extends GetxController {
  RxString name = "".obs;
  RxString image = "".obs;
  RxString designation = "".obs;
  RxString categoryImage = "".obs;
  RxString categoryName = "".obs;
  UserData? profileData;
  RxList<String> bannerImages = <String>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  // Initialize as empty list instead of null
  List<JobPost>? jobPost = [];
  RxBool isLoadingJobs = false.obs;

  // Filter parameters
  RxString searchTerm = ''.obs;
  RxString selectedCategory = ''.obs;
  RxInt minSalary = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxList<String> selectedJobTypes = <String>[].obs; // FULL_TIME, PART_TIME
  RxList<String> selectedJobLevels = <String>[].obs; // ENTRY_LEVEL, MID_LEVEL
  RxString selectedExperienceLevel = ''.obs; // 0-1yrs, 1-3yr
  RxBool autoApplHere=false.obs;

  @override
  void onInit() {
    super.onInit();
    getPost();
    getProfile();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // --- Profile, Banner, and Category Methods (No Change) ---




  // --- Filter Helper (No Change) ---

  // Build query parameters for filter
  String _buildQueryParams() {
    List<String> params = [];

    // Search term
    if (searchTerm.value.isNotEmpty) {
      params.add('searchTerm=${Uri.encodeComponent(searchTerm.value)}');
    }

    // Salary range
    if (minSalary.value > 0) {
      params.add('minPrice=${minSalary.value}');
    }
    if (maxSalary.value < 100000) {
      params.add('maxPrice=${maxSalary.value}');
    }

    // Category
    if (selectedCategory.value.isNotEmpty) {
      params.add('category=${selectedCategory.value}');
    }

    // Job types (multiple)
    if (selectedJobTypes.isNotEmpty) {
      params.add('job_type=${selectedJobTypes.join(',')}');
    }

    // Job levels (multiple)
    if (selectedJobLevels.isNotEmpty) {
      params.add('job_level=${selectedJobLevels.join(',')}');
    }

    // Experience level
    if (selectedExperienceLevel.value.isNotEmpty) {
      params.add('experience_level=${selectedExperienceLevel.value}');
    }

    return params.isEmpty ? '' : '?${params.join('&')}';
  }

  // --- Core getPost Method (Corrected) ---

  Future<void> getProfile() async {
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final profileModel = ProfileModel.fromJson(response.data);
        profileData = profileModel.data;
        autoApplHere.value=response.data["data"]["isAutoApply"] ?? false;
        print("imageurl 😂😂😂😂: ${image.value}");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    update();
  }


  Future<void> toggleAutoApply(bool value) async {
    // Optimistic update
    autoApplHere.value = value;

    try {
      // Replace with your actual API endpoint for auto-apply
      final response = await ApiService.post(
          "user/auto-apply", // Example endpoint
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Auto Apply ${value ? 'Enabled' : 'Disabled'}");
      } else {
        Get.snackbar("Error", "Auto Apply ${value ? 'Enabled' : 'Disabled'}");
      }
    } catch (e) {
      //autoApplHere.value = !value;
      Utils.errorSnackBar(0, e.toString());
    }
  }

  Future<void> getPost({bool useFilter = false}) async {
    isLoadingJobs.value = true;
    update();

    try {
      String endpoint;

      // ✅ FIX: Construct the endpoint by appending the query parameters
      // directly to the base API path to avoid the 404.
      if (useFilter) {
        endpoint = '${ApiEndPoint.job_post}${_buildQueryParams()}';
      } else {
        endpoint = ApiEndPoint.job_post;
      }

      print("============ JOB POST REQUEST ============");
      print("Endpoint: $endpoint");
      print("Using Filter: $useFilter");

      final response = await ApiService.get(
          endpoint,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Parse the response
        final jobPostResponse = JobPostResponse.fromJson(response.data);

        print("Parsed Success: ${jobPostResponse.success}");
        print("Parsed Message: ${jobPostResponse.message}");
        print("Data is null? ${jobPostResponse.data == null}");
        print("Data length: ${jobPostResponse.data?.length ?? 0}");

        // Safely assign data
        if (jobPostResponse.data != null && jobPostResponse.data!.isNotEmpty) {
          jobPost = jobPostResponse.data;
          print("✅ Job posts assigned: ${jobPost?.length} items");

          // Print first job details for debugging
          if (jobPost!.isNotEmpty) {
            final firstJob = jobPost![0];
            print("First Job Title: ${firstJob.title}");
            print("First Job Location: ${firstJob.location}");
            print("First Job Salary: ${firstJob.minSalary} - ${firstJob.maxSalary}");
          }
        } else {
          jobPost = [];
          print("⚠️ No jobs found in response");
          Get.snackbar(
            "No Results",
            "No jobs found matching your criteria",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
        jobPost = [];
        print("❌ Error response: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("❌ Exception in getPost: $e");
      print("Stack trace: $stackTrace");
      Utils.errorSnackBar(0, "Failed to load jobs: ${e.toString()}");
      jobPost = [];
    } finally {
      isLoadingJobs.value = false;
      update();
      print("============ END JOB POST RESPONSE ============");
    }
  }

  // --- Filter and Action Methods (No Change) ---

  // Apply filters from bottom sheet
  void applyFilters({
    String? search,
    String? category,
    int? minPrice,
    int? maxPrice,
    List<String>? jobTypes,
    List<String>? jobLevels,
    String? experienceLevel,
  }) {
    // Update filter values
    if (search != null) searchTerm.value = search;
    if (category != null) selectedCategory.value = category;
    if (minPrice != null) minSalary.value = minPrice;
    if (maxPrice != null) maxSalary.value = maxPrice;
    if (jobTypes != null) selectedJobTypes.value = jobTypes;
    if (jobLevels != null) selectedJobLevels.value = jobLevels;
    if (experienceLevel != null) selectedExperienceLevel.value = experienceLevel;

    // Fetch jobs with filters
    getPost(useFilter: true);
  }

  // Clear all filters
  void clearFilters() {
    searchTerm.value = '';
    selectedCategory.value = '';
    minSalary.value = 0;
    maxSalary.value = 100000;
    selectedJobTypes.clear();
    selectedJobLevels.clear();
    selectedExperienceLevel.value = '';

    // Fetch jobs without filters
    getPost(useFilter: false);
  }

  // Search jobs by term
  void searchJobs(String term) {
    searchTerm.value = term;
    if (term.isNotEmpty) {
      getPost(useFilter: true);
    } else {
      getPost(useFilter: false);
    }
  }

  // Method to toggle favorite
  void toggleFavorite(String jobId) {
    if (jobId.isEmpty) return;

    Get.snackbar(
      "Favorite",
      "Job marked as favorite",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  // Method to refresh jobs
  Future<void> refreshJobs() async {
    await getPost(useFilter: false);
  }
}