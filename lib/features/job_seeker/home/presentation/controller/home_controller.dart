import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/home_model.dart';
import '../../data/model/job_post.dart';

class HomeController extends GetxController {
  RxString name = "".obs;
  RxString image = "".obs;
  RxString designation = "".obs;
  RxString categoryImage = "".obs;
  RxString categoryName = "".obs;
  UserData? profileData;
  RxList<String> bannerImages = <String>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  RxList<JobPost> jobPost = <JobPost>[].obs;
  RxBool isLoadingJobs = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isSearching = false.obs; // New flag for search loading

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
  RxInt notificationCounts = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxList<String> selectedJobTypes = <String>[].obs;
  RxList<String> selectedJobLevels = <String>[].obs;
  RxString selectedExperienceLevel = ''.obs;
  String categoryId = "";
  RxBool isNotification = false.obs;
  RxBool autoApplHere = false.obs;
  RxBool isLoadingAutoApply = false.obs;


  // Debouncing for search
  Worker? _searchDebouncer;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getBanner();
    fetchCategories();
    getPost();
    readNotification();

    // Setup debounced search
    _searchDebouncer = debounce(
      searchTerm,
          (_) => _performSearch(),
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onClose() {
    _searchDebouncer?.dispose();
    super.onClose();
  }

  Future<void> getProfile() async {
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final profileModel = ProfileModel.fromJson(response.data);
        profileData = profileModel.data;
        name.value = response.data["data"]["name"] ?? "";
        image.value = response.data["data"]["image"] ?? "";
        designation.value = response.data["data"]["designation"] ?? "No Designation Selected";

        // Set the actual auto-apply status from API
        autoApplHere.value = response.data["data"]["isAutoApply"] ?? false;

        print("imageurl 😂😂😂😂: ${image.value}");
        print("Auto Apply Status: ${autoApplHere.value}");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
  }

  void countNotification()async{
    final response=await ApiService.get(
      "notification"
    );
    if(response.statusCode==200){
      notificationCounts.value=response.data["data"]["unreadCount"];
    }
  }

  Future<void> getBanner() async {
    try {
      final response = await ApiService.get(
          ApiEndPoint.banner,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final List<dynamic>? dataList = response.data["data"];
        if (dataList != null && dataList.isNotEmpty) {
          final List<String> images = dataList
              .map<String>((item) => item["cover_image"] ?? "")
              .where((image) => image.isNotEmpty)
              .toList();

          bannerImages.value = images;
        } else {
          bannerImages.clear();
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
  }
  Future<void> readNotification() async {
    try {
      final response = await ApiService.get(
          "notification",
          header: {
            "Authorization": "Bearer ${LocalStorage.token}",
            "Content-Type": "application/json",
          }
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final count = data["unreadCount"] ?? 2;

        notificationCounts.value = count;
        isNotification.value = count > 0;

        print("🔔 Unread notifications: $count");
      } else {
        print("⚠️ Failed to fetch notification count: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching notification count: $e");
    }
  }
  Future<void> fetchCategories() async {
    try {
      final response = await ApiService.get(
        ApiEndPoint.Categorys,
        header: {
          "Authorization": "Bearer ${LocalStorage.token}",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        categories.value = data.map((item) {
          categoryImage.value = item['image'] ?? "assets/images/noImage.png";
          categoryName.value = item['name'] ?? "";
          categoryId = item['_id'] ?? "";
          return {
            "id": item['_id'] ?? "",
            "name": item['name'] ?? "",
            "image": item['image'] ?? "assets/images/noImage.png",
          };
        }).toList();
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Failed to load categories",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
        if (response.data != null &&
            response.data['data'] != null &&
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

    if (searchTerm.value.isNotEmpty) {
      params.add('searchTerm=${Uri.encodeComponent(searchTerm.value)}');
    }

    if (minSalary.value > 0) {
      params.add('minPrice=${minSalary.value}');
    }
    if (maxSalary.value < 100000) {
      params.add('maxPrice=${maxSalary.value}');
    }

    if (selectedCategory.value.isNotEmpty) {
      params.add('category=${selectedCategory.value}');
    }

    if (selectedJobTypes.isNotEmpty) {
      params.add('job_type=${selectedJobTypes.join(',')}');
    }

    if (selectedJobLevels.isNotEmpty) {
      params.add('job_level=${selectedJobLevels.join(',')}');
    }

    if (selectedExperienceLevel.value.isNotEmpty) {
      params.add('experience_level=${selectedExperienceLevel.value}');
    }

    return '?${params.join('&')}';
  }

  Future<void> getPost({
    bool useFilter = false,
    bool loadMore = false,
    bool isSearch = false
  }) async {
    // Prevent duplicate loading
    if (loadMore && (isLoadingMore.value || !hasMorePages.value)) return;

    // Use different loading flags for search vs regular loading
    if (isSearch) {
      if (isSearching.value) return; // Prevent multiple search requests
      isSearching.value = true;
    } else if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoadingJobs.value = true;
      currentPage.value = 1; // Reset to first page
    }

    try {
      int pageToLoad = loadMore ? currentPage.value + 1 : 1;
      String endpoint = '${ApiEndPoint.job_post}${_buildQueryParams(page: pageToLoad)}';

      print("============ JOB POST REQUEST ============");
      print("Endpoint: $endpoint");
      print("Page: $pageToLoad");
      print("Load More: $loadMore");
      print("Is Search: $isSearch");

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
          }
        } else {
          if (!loadMore) {
            jobPost.clear();
            print("⚠️ No jobs found");
          }
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
        if (!loadMore) jobPost.clear();
      }
    } catch (e, stackTrace) {
      print("❌ Exception in getPost: $e");
      print("Stack trace: $stackTrace");
      Utils.errorSnackBar(0, "Failed to load jobs: ${e.toString()}");
      if (!loadMore) jobPost.clear();
    } finally {
      if (isSearch) {
        isSearching.value = false;
      } else if (loadMore) {
        isLoadingMore.value = false;
      } else {
        isLoadingJobs.value = false;
      }
      print("============ END JOB POST RESPONSE ============");
    }
  }

  // Perform search without losing focus
  Future<void> _performSearch() async {
    print("🔍 Performing search for: ${searchTerm.value}");
    await getPost(useFilter: true, isSearch: true);
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

  // Updated search method - just updates the observable, debouncer handles the rest
  void searchJobs(String term) {
    searchTerm.value = term;
    // The debouncer will automatically trigger _performSearch() after 500ms
  }

  Future<void> toggleFavorite(String jobId) async {
    if (jobId.isEmpty) return;

    final index = jobPost.indexWhere((job) => job.id == jobId);
    if (index == -1) {
      print("Error: Job ID not found in the list.");
      return;
    }

    final job = jobPost[index];
    final isCurrentlySaved = job.isFavourite ?? false;

    // Optimistic Update
    job.isFavourite = !isCurrentlySaved;
    jobPost.refresh();

    try {
      final response = await ApiService.post(
          ApiEndPoint.favourite,
          body: {
            "post": jobId,
          },
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        // Success - optimistic state holds
      } else {
        // Revert on failure
        job.isFavourite = isCurrentlySaved;
        jobPost.refresh();
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      // Revert on exception
      job.isFavourite = isCurrentlySaved;
      jobPost.refresh();
      Utils.errorSnackBar(0, "Failed to toggle favorite: ${e.toString()}");
    }
  }

  Future<void> refreshJobs() async {
    await getPost();
    await getProfile();
  }
}