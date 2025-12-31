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
  RxBool isLoadingMore = false.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalJobs = 0.obs;
  RxBool hasMoreData = true.obs;
  final int itemsPerPage = 10; // Adjust based on your API

  // Filter parameters
  RxString searchTerm = ''.obs;
  RxString selectedCategory = ''.obs;
  RxInt minSalary = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxList<String> selectedJobTypes = <String>[].obs;
  RxList<String> selectedJobLevels = <String>[].obs;
  RxString selectedExperienceLevel = ''.obs;

  // Store the original categoryId that should always be applied
  String categoryId = "";

  // Scroll controller for infinite scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    // Get arguments from navigation
    categoryId = Get.arguments['categoryId'];
    categoryName.value = Get.arguments['categoryName'];

    // Set selectedCategory to always filter by this category
    selectedCategory.value = categoryId;

    print("Initial Category ID: $categoryId");

    // Setup scroll listener for infinite scroll
    scrollController.addListener(_onScroll);

    // Fetch initial jobs for this category
    getPost(resetPage: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Scroll listener for pagination
  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom (200px threshold)
      if (!isLoadingMore.value && hasMoreData.value && !isLoadingJobs.value) {
        loadMoreJobs();
      }
    }
  }

  // --- Build Query Parameters ---
  String _buildQueryParams({int? page}) {
    List<String> params = [];

    // Add pagination
    final pageNum = page ?? currentPage.value;
    params.add('page=$pageNum');

    // ALWAYS include category filter
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
  Future<void> getPost({bool resetPage = false}) async {
    if (resetPage) {
      currentPage.value = 1;
      hasMoreData.value = true;
      jobPost.clear();
    }

    isLoadingJobs.value = true;
    update();

    try {
      // Build endpoint with query parameters
      String queryParams = _buildQueryParams(page: currentPage.value);
      String endpoint = '${ApiEndPoint.job_post}$queryParams';

      print("============ JOB POST REQUEST ============");
      print("Endpoint: $endpoint");
      print("Category ID: ${selectedCategory.value}");
      print("Page: ${currentPage.value}");

      final response = await ApiService.get(
          endpoint,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final jobPostResponse = JobPostResponse.fromJson(response.data);

        // Update pagination info
        if (jobPostResponse.pagination != null) {
          totalPages.value = jobPostResponse.pagination!.totalPage ?? 1;
          totalJobs.value = jobPostResponse.pagination!.total ?? 0;

          // Check if there's more data
          hasMoreData.value = currentPage.value < totalPages.value;

          print("Pagination - Page: ${currentPage.value}/${totalPages.value}, Total: ${totalJobs.value}");
        }

        if (jobPostResponse.data != null && jobPostResponse.data!.isNotEmpty) {
          if (resetPage) {
            jobPost.value = jobPostResponse.data!;
          } else {
            jobPost.addAll(jobPostResponse.data!);
          }
          print("✅ Job posts loaded: ${jobPostResponse.data!.length} items (Total: ${jobPost.length})");
        } else {
          if (resetPage) {
            jobPost.value = [];
          }
          hasMoreData.value = false;
          print("⚠️ No jobs found in response");

          // Only show snackbar if filters are applied and it's the first page
          if (resetPage && (searchTerm.value.isNotEmpty ||
              minSalary.value > 0 ||
              selectedJobTypes.isNotEmpty ||
              selectedJobLevels.isNotEmpty ||
              selectedExperienceLevel.value.isNotEmpty)) {
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
        if (resetPage) {
          jobPost.value = [];
        }
        hasMoreData.value = false;
        print("❌ Error response: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("❌ Exception in getPost: $e");
      print("Stack trace: $stackTrace");
      Utils.errorSnackBar(0, "Failed to load jobs: ${e.toString()}");
      if (resetPage) {
        jobPost.value = [];
      }
      hasMoreData.value = false;
    } finally {
      isLoadingJobs.value = false;
      update();
      print("============ END JOB POST RESPONSE ============");
    }
  }

  // --- Load More Jobs (Pagination) ---
  Future<void> loadMoreJobs() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    try {
      String queryParams = _buildQueryParams(page: currentPage.value);
      String endpoint = '${ApiEndPoint.job_post}$queryParams';

      print("============ LOADING MORE JOBS ============");
      print("Endpoint: $endpoint");
      print("Page: ${currentPage.value}");

      final response = await ApiService.get(
          endpoint,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final jobPostResponse = JobPostResponse.fromJson(response.data);

        // Update pagination info
        if (jobPostResponse.pagination != null) {
          totalPages.value = jobPostResponse.pagination!.totalPage ?? 1;
          hasMoreData.value = currentPage.value < totalPages.value;
        }

        if (jobPostResponse.data != null && jobPostResponse.data!.isNotEmpty) {
          jobPost.addAll(jobPostResponse.data!);
          print("✅ Loaded ${jobPostResponse.data!.length} more jobs (Total: ${jobPost.length})");
        } else {
          hasMoreData.value = false;
          print("⚠️ No more jobs to load");
        }
      } else {
        hasMoreData.value = false;
        currentPage.value--; // Revert page increment on error
        print("❌ Error loading more: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception loading more: $e");
      hasMoreData.value = false;
      currentPage.value--; // Revert page increment on error
    } finally {
      isLoadingMore.value = false;
      update();
      print("============ END LOADING MORE ============");
    }
  }

  // --- Refresh (Pull to Refresh) ---
  Future<void> refreshJobs() async {
    await getPost(resetPage: true);
  }

  // --- Search Jobs ---
  void searchJobs(String term) {
    searchTerm.value = term;
    getPost(resetPage: true);
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

    // Fetch jobs with new filters (reset to page 1)
    getPost(resetPage: true);
  }

  // --- Clear Filters (Keep Category) ---
  void clearFilters() {
    searchTerm.value = '';
    minSalary.value = 0;
    maxSalary.value = 100000;
    selectedJobTypes.clear();
    selectedJobLevels.clear();
    selectedExperienceLevel.value = '';

    // Fetch jobs without extra filters (reset to page 1)
    getPost(resetPage: true);
  }

  // --- Toggle Favorite ---
  Future<void> toggleFavorite(String jobId) async {
    if (jobId.isEmpty) return;

    final index = jobPost.indexWhere((job) => job.id == jobId);
    if (index == -1) {
      print("Error: Job ID not found in the list.");
      return;
    }

    final job = jobPost[index];
    final isCurrentlySaved = job.isFavourite ?? false;

    // Optimistic update
    job.isFavourite = !isCurrentlySaved;
    jobPost.refresh();
    update();

    try {
      final response = await ApiService.post(
          ApiEndPoint.favourite,
          body: {"post": jobId},
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode != 200) {
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