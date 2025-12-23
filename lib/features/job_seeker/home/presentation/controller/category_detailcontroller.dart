import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';
import '../../../home/data/model/job_post.dart';

class CategoryDetailController extends GetxController {
  RxString name = "".obs;
  RxString image = "".obs;
  RxString designation = "".obs;
  RxString categoryImage = "".obs;
  RxString categoryName = "".obs;
  UserData? profileData;
  RxList<String> bannerImages = <String>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  // Job posts list
  RxList<JobPost> jobPost = <JobPost>[].obs;
  RxBool isLoadingJobs = false.obs;

  // Filter parameters
  RxString searchTerm = ''.obs;
  RxString selectedCategory = ''.obs; // This will hold the categoryId
  RxInt minSalary = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxList<String> selectedJobTypes = <String>[].obs; // FULL_TIME, PART_TIME, etc.
  RxList<String> selectedJobLevels = <String>[].obs; // ENTRY_LEVEL, MID_LEVEL, etc.
  RxString selectedExperienceLevel = ''.obs; // 0-1yrs, 1-3yrs, etc.

  // Store the original categoryId that should always be applied
  String categoryId = "";

  @override
  void onInit() {
    super.onInit();

    // Get arguments from navigation
    categoryId = Get.arguments['categoryId'];
    categoryName.value = Get.arguments['categoryName'];

    // ✅ CRITICAL: Set selectedCategory to always filter by this category
    selectedCategory.value = categoryId;

    print("Initial Category ID: $categoryId");

    // Fetch jobs for this category
    getPost();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // --- Build Query Parameters ---
  String _buildQueryParams() {
    List<String> params = [];

    // ✅ ALWAYS include category filter (the main purpose of this screen)
    if (selectedCategory.value.isNotEmpty) {
      params.add('category=${selectedCategory.value}');
    }

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

  // --- Get Posts with Filters ---
  Future<void> getPost() async {
    isLoadingJobs.value = true;
    update();

    try {
      // Build endpoint with query parameters
      String queryParams = _buildQueryParams();
      String endpoint = '${ApiEndPoint.job_post}$queryParams';

      print("============ JOB POST REQUEST ============");
      print("Endpoint: $endpoint");
      print("Category ID: ${selectedCategory.value}");

      final response = await ApiService.get(
          endpoint,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final jobPostResponse = JobPostResponse.fromJson(response.data);

        if (jobPostResponse.data != null && jobPostResponse.data!.isNotEmpty) {
          jobPost.value = jobPostResponse.data!;
          print("✅ Job posts assigned: ${jobPost.length} items");
        } else {
          jobPost.value = [];
          print("⚠️ No jobs found in response");

          // Only show snackbar if filters are applied
          if (searchTerm.value.isNotEmpty ||
              minSalary.value > 0 ||
              selectedJobTypes.isNotEmpty ||
              selectedJobLevels.isNotEmpty ||
              selectedExperienceLevel.value.isNotEmpty) {
            Get.snackbar(
              "No Results",
              "No jobs found matching your criteria",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
        jobPost.value = [];
        print("❌ Error response: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("❌ Exception in getPost: $e");
      print("Stack trace: $stackTrace");
      Utils.errorSnackBar(0, "Failed to load jobs: ${e.toString()}");
      jobPost.value = [];
    } finally {
      isLoadingJobs.value = false;
      update();
      print("============ END JOB POST RESPONSE ============");
    }
  }

  // --- Search Jobs ---
  void searchJobs(String term) {
    searchTerm.value = term;
    getPost(); // Category filter is always included
  }

  // --- Apply Filters ---
  void applyFilters({
    String? search,
    int? minPrice,
    int? maxPrice,
    List<String>? jobTypes,
    List<String>? jobLevels,
    String? experienceLevel,
  }) {
    // Update filter values
    if (search != null) searchTerm.value = search;
    if (minPrice != null) minSalary.value = minPrice;
    if (maxPrice != null) maxSalary.value = maxPrice;
    if (jobTypes != null) selectedJobTypes.value = jobTypes;
    if (jobLevels != null) selectedJobLevels.value = jobLevels;
    if (experienceLevel != null) selectedExperienceLevel.value = experienceLevel;

    // ✅ selectedCategory is NEVER changed - always keeps the original categoryId

    // Fetch jobs with new filters (category is always included)
    getPost();
  }

  // --- Clear Filters (Keep Category) ---
  void clearFilters() {
    searchTerm.value = '';
    minSalary.value = 0;
    maxSalary.value = 100000;
    selectedJobTypes.clear();
    selectedJobLevels.clear();
    selectedExperienceLevel.value = '';

    // ✅ CRITICAL: DO NOT clear selectedCategory - keep the original category filter
    // selectedCategory.value remains as categoryId

    // Fetch jobs without extra filters (but still filtered by category)
    getPost();
  }

  // --- Toggle Favorite ---
  Future<void> toggleFavorite(String jobId) async {
    if (jobId.isEmpty) return;

    // Find the job in the list
    final index = jobPost.indexWhere((job) => job.id == jobId);
    if (index == -1) {
      print("Error: Job ID not found in the list.");
      return;
    }

    final job = jobPost[index];
    final isCurrentlySaved = job.isFavourite ?? false;

    // Optimistic update
    job.isFavourite = !isCurrentlySaved;
    jobPost.refresh(); // Refresh the observable list
    update();

    try {
      final response = await ApiService.post(
          ApiEndPoint.favourite,
          body: {"post": jobId},
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          isCurrentlySaved ? "Job removed from favorites" : "Job marked as favorite",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Revert on failure
        job.isFavourite = isCurrentlySaved;
        jobPost.refresh();
        update();
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      // Revert on exception
      job.isFavourite = isCurrentlySaved;
      jobPost.refresh();
      update();
      Utils.errorSnackBar(0, "Failed to toggle favorite: ${e.toString()}");
    }
  }
}