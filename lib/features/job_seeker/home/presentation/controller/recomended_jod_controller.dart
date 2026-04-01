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

  // Job posts list
  RxList<JobPost> jobPost = <JobPost>[].obs;
  RxBool isLoadingJobs = false.obs;
  RxBool isLoadingMore = false.obs;

  // Pagination variables
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalJobs = 0.obs;
  RxBool hasMorePages = true.obs;
  Rx<int?> lastCursor = Rx<int?>(null);

  // Filter parameters
  RxString searchTerm = ''.obs;
  RxString selectedCategory = ''.obs;
  RxInt minSalary = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxBool isLoadingAutoApply = false.obs;
  RxList<String> selectedJobTypes = <String>[].obs;
  RxList<String> selectedJobLevels = <String>[].obs;
  RxString selectedExperienceLevel = ''.obs;
  RxBool autoApplHere = false.obs;

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

  Future<void> toggleAutoApply(bool value) async {
    // Prevent multiple simultaneous requests
    if (isLoadingAutoApply.value) return;

    isLoadingAutoApply.value = true;

    // Store the previous value for rollback if needed
    final previousValue = autoApplHere.value;

    // Optimistically update UI
    autoApplHere.value = value;

    try {
      final response = await ApiService.post(
          "user/auto-apply",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        // Check if the API returns the updated status
        if (response.data['data'] != null &&
            response.data['data']['isAutoApply'] != null) {
          // Update with the actual value from API response
          autoApplHere.value = response.data['data']['isAutoApply'];
        }

        Get.snackbar(
          "Success",
          "Auto Apply ${autoApplHere.value ? 'Enabled' : 'Disabled'}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        print("✅ Auto Apply toggled successfully: ${autoApplHere.value}");
      } else {
        // Revert to previous value on failure
        autoApplHere.value = previousValue;

        Get.snackbar(
          "Error",
          response.message ?? "Failed to toggle Auto Apply",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        print("❌ Failed to toggle Auto Apply");
      }
    } catch (e) {
      // Revert to previous value on exception
      autoApplHere.value = previousValue;

      Utils.errorSnackBar(0, "Error: ${e.toString()}");
      print("❌ Exception in toggleAutoApply: $e");
    } finally {
      isLoadingAutoApply.value = false;
    }
  }

  String _buildQueryParams({int? page}) {
    List<String> params = [];

    // Check if we need to use cursor instead of page
    if (currentPage.value == totalPages.value && lastCursor.value != null) {
      // Use cursor when on the last page
      params.add('cursor=${lastCursor.value}');
    } else {
      // Use page parameter for normal pagination
      params.add('page=${page ?? currentPage.value}');
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

    // Category
    if (selectedCategory.value.isNotEmpty) {
      params.add('category=${selectedCategory.value}');
    }

    // Job types
    if (selectedJobTypes.isNotEmpty) {
      params.add('job_type=${selectedJobTypes.join(',')}');
    }

    // Job levels
    if (selectedJobLevels.isNotEmpty) {
      params.add('job_level=${selectedJobLevels.join(',')}');
    }

    // Experience level
    if (selectedExperienceLevel.value.isNotEmpty) {
      params.add('experience_level=${selectedExperienceLevel.value}');
    }

    return '?${params.join('&')}';
  }

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
        autoApplHere.value = response.data["data"]["isAutoApply"] ?? false;
        print("imageurl 😂😂😂😂: ${image.value}");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    update();
  }

  Future<void> getPost({bool useFilter = false, bool loadMore = false}) async {
    // Prevent duplicate loading
    if (loadMore && (isLoadingMore.value || !hasMorePages.value)) return;

    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoadingJobs.value = true;
      currentPage.value = 1; // Reset to first page
      lastCursor.value = null; // Reset cursor
    }

    update();

    try {
      int pageToLoad = loadMore ? currentPage.value + 1 : 1;
      String endpoint = '${ApiEndPoint.job_post}${_buildQueryParams(page: pageToLoad)}';

      print("============ JOB POST REQUEST ============");
      print("Endpoint: $endpoint");
      print("Page: $pageToLoad");
      print("Load More: $loadMore");
      print("Using Cursor: ${currentPage.value == totalPages.value && lastCursor.value != null}");

      final response = await ApiService.get(
          endpoint,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jobPostResponse = JobPostResponse.fromJson(response.data);

        // Update pagination info
        if (response.data['pagination'] != null) {
          totalPages.value = response.data['pagination']['totalPage'] ?? 1;
          totalJobs.value = response.data['pagination']['total'] ?? 0;
          currentPage.value = response.data['pagination']['page'] ?? 1;

          // Store the cursor value for next request
          lastCursor.value = response.data['pagination']['cursor'];

          hasMorePages.value = currentPage.value < totalPages.value;

          print("Pagination - Current: ${currentPage.value}, Total: ${totalPages.value}, Cursor: ${lastCursor.value}");
        }

        if (jobPostResponse.data != null && jobPostResponse.data!.isNotEmpty) {
          if (loadMore) {
            // Append new jobs to existing list
            jobPost.addAll(jobPostResponse.data!);
            print("✅ Added ${jobPostResponse.data!.length} more jobs. Total: ${jobPost.length}");
          } else {
            // Replace list with new jobs
            jobPost.value = jobPostResponse.data!;
            print("✅ Loaded ${jobPost.length} jobs");

            if (jobPost.isNotEmpty) {
              final firstJob = jobPost[0];
              print("First Job Title: ${firstJob.title}");
              print("First Job Location: ${firstJob.location}");
              print("First Job Salary: ${firstJob.minSalary} - ${firstJob.maxSalary}");
            }
          }
        } else {
          if (!loadMore) {
            jobPost.value = [];
            print("⚠️ No jobs found in response");
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
        if (!loadMore) jobPost.value = [];
        print("❌ Error response: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("❌ Exception in getPost: $e");
      print("Stack trace: $stackTrace");
      Utils.errorSnackBar(0, "Failed to load jobs: ${e.toString()}");
      if (!loadMore) jobPost.value = [];
    } finally {
      isLoadingJobs.value = false;
      isLoadingMore.value = false;
      update();
      print("============ END JOB POST RESPONSE ============");
    }
  }

  // Load next page of jobs
  Future<void> loadMoreJobs() async {
    await getPost(useFilter: true, loadMore: true);
  }

  void applyFilters({
    String? search,
    String? category,
    int? minPrice,
    int? maxPrice,
    List<String>? jobTypes,
    List<String>? jobLevels,
    String? experienceLevel,
  }) {
    if (search != null) searchTerm.value = search;
    if (category != null) selectedCategory.value = category;
    if (minPrice != null) minSalary.value = minPrice;
    if (maxPrice != null) maxSalary.value = maxPrice;
    if (jobTypes != null) selectedJobTypes.value = jobTypes;
    if (jobLevels != null) selectedJobLevels.value = jobLevels;
    if (experienceLevel != null) selectedExperienceLevel.value = experienceLevel;

    getPost(useFilter: true);
  }

  void clearFilters() {
    searchTerm.value = '';
    selectedCategory.value = '';
    minSalary.value = 0;
    maxSalary.value = 100000;
    selectedJobTypes.clear();
    selectedJobLevels.clear();
    selectedExperienceLevel.value = '';

    getPost(useFilter: false);
  }

  void searchJobs(String term) {
    searchTerm.value = term;
    if (term.isNotEmpty) {
      getPost(useFilter: true);
    } else {
      getPost(useFilter: false);
    }
  }

  Future<void> toggleFavorite(String jobId) async {
    if (jobId.isEmpty) return;

    final index = jobPost.indexWhere((job) => job.id == jobId);
    if (index == -1) return;

    final job = jobPost[index];
    final bool originalStatus = job.isFavourite ?? false;

    // Optimistic update
    job.isFavourite = !originalStatus;
    jobPost.refresh();

    try {
      final response = await ApiService.post(
          ApiEndPoint.favourite,
          body: {"post": jobId},
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode != 200) {
        // Rollback on failure
        jobPost[index].isFavourite = originalStatus;
        jobPost.refresh();
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      // Rollback on error
      jobPost[index].isFavourite = originalStatus;
      jobPost.refresh();
      Utils.errorSnackBar(0, "Connection error");
    }
  }

  Future<void> refreshJobs() async {
    await getPost(useFilter: false);
  }
}