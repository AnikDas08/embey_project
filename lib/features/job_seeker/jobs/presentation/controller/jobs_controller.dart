import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';
import '../../../home/data/model/job_post.dart';

class JobController extends GetxController {
  RxString name = "".obs;
  RxString image = "".obs;
  RxString designation = "".obs;
  RxString categoryImage = "".obs;
  RxString categoryName = "".obs;
  UserData? profileData;
  RxList<String> bannerImages = <String>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  // Job posts list (changed to RxList for better reactivity)
  RxList<JobPost> jobPost = <JobPost>[].obs;
  RxBool isLoadingJobs = false.obs;

  // Filter parameters
  RxString searchTerm = ''.obs;
  RxString selectedCategory = ''.obs;
  RxInt minSalary = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxList<String> selectedJobTypes = <String>[].obs; // FULL_TIME, PART_TIME, etc.
  RxList<String> selectedJobLevels = <String>[].obs; // ENTRY_LEVEL, MID_LEVEL, etc.
  RxString selectedExperienceLevel = ''.obs; // 0-1yrs, 1-3yrs, etc.

  @override
  void onInit() {
    super.onInit();
    getCategories(); // ✅ Fetch categories first
    getPost();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // --- Get Categories ---
  Future<void> getCategories() async {
    try {
      print("============ FETCHING CATEGORIES ============");

      final response = await ApiService.get(
          ApiEndPoint.Categorys,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      print("Categories Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['data'] != null && data['data'] is List) {
          categories.value = List<Map<String, dynamic>>.from(
              data['data'].map((category) => {
                'id': category['_id'] ?? category['id'] ?? '',
                'name': category['name'] ?? 'Unknown',
                'image': category['image'] ?? '',
              })
          );
          print("✅ Categories loaded: ${categories.length} items");
        } else {
          print("⚠️ No categories found in response");
        }
      } else {
        print("❌ Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception fetching categories: $e");
    }
    print("============ END CATEGORIES RESPONSE ============");
  }

  // --- Build Query Parameters ---
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

    // Category (optional - only if selected)
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

  // --- Get Posts ---
  Future<void> getPost() async {
    isLoadingJobs.value = true;
    update();

    try {
      // Build endpoint with query parameters
      String queryParams = _buildQueryParams();
      String endpoint = '${ApiEndPoint.job_post}$queryParams';

      print("============ JOB POST REQUEST ============");
      print("Endpoint: $endpoint");

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
          if (_hasActiveFilters()) {
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

  // Check if any filters are active
  bool _hasActiveFilters() {
    return searchTerm.value.isNotEmpty ||
        selectedCategory.value.isNotEmpty ||
        minSalary.value > 0 ||
        maxSalary.value < 100000 ||
        selectedJobTypes.isNotEmpty ||
        selectedJobLevels.isNotEmpty ||
        selectedExperienceLevel.value.isNotEmpty;
  }

  // --- Search Jobs ---
  void searchJobs(String term) {
    searchTerm.value = term;
    getPost();
  }

  // --- Apply Filters ---
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

    // Fetch jobs with new filters
    getPost();
  }

  // --- Clear Filters ---
  void clearFilters() {
    searchTerm.value = '';
    selectedCategory.value = '';
    minSalary.value = 0;
    maxSalary.value = 100000;
    selectedJobTypes.clear();
    selectedJobLevels.clear();
    selectedExperienceLevel.value = '';

    // Fetch all jobs without filters
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

  // --- Refresh Jobs ---
  Future<void> refreshJobs() async {
    await getPost();
  }
}