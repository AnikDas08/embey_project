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

  // Initialize as empty list instead of null
  List<JobPost>? jobPost = [];
  RxBool isLoadingJobs = false.obs;

  // Filter parameters
  RxString searchTerm = ''.obs;
  // This holds the categoryId passed from the previous screen
  RxString selectedCategory = ''.obs;
  RxInt minSalary = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxList<String> selectedJobTypes = <String>[].obs; // FULL_TIME, PART_TIME
  RxList<String> selectedJobLevels = <String>[].obs; // ENTRY_LEVEL, MID_LEVEL
  RxString selectedExperienceLevel = ''.obs; // 0-1yrs, 1-3yrs
  String categoryId = "";

  @override
  void onInit() {
    super.onInit();
    /*if (Get.arguments != null) {
      // 1. Store the ID from arguments
      categoryId = Get.arguments as String;
      // 2. Set the observable filter parameter
      selectedCategory.value = categoryId;
    }*/
    categoryId= Get.arguments['categoryId'];
    categoryName.value = Get.arguments['categoryName'];
    print("Initial Category ID: $categoryId");
    // 3. Call getPost to fetch jobs using the stored filter state.
    getPost(useFilter: true);
  }

  @override
  void onClose() {
    super.onClose();
  }

  // --- Filter Helper ---

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

    // Category (Uses selectedCategory which was set in onInit)
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

  // --- Core getPost Method (Refined to use filter parameters) ---

  Future<void> getPost({bool useFilter = false}) async { // Removed String categoryId argument
    isLoadingJobs.value = true;
    update();

    try {
      String endpoint;

      // Build the full query string (includes initial category filter from onInit)
      String queryParams = _buildQueryParams();

      if (useFilter && queryParams.isNotEmpty) {
        endpoint = '${ApiEndPoint.job_post}$queryParams';
      } else {
        // Fallback endpoint if no filters are applied
        endpoint = ApiEndPoint.job_post;
      }

      print("============ JOB POST REQUEST ============");
      print("Endpoint: $endpoint");

      final response = await ApiService.get(
          endpoint, // Use the dynamically built endpoint
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final jobPostResponse = JobPostResponse.fromJson(response.data);

        if (jobPostResponse.data != null && jobPostResponse.data!.isNotEmpty) {
          jobPost = jobPostResponse.data;
          print("✅ Job posts assigned: ${jobPost?.length} items");
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

  // --- Toggle Favorite Method (The final, correct logic) ---

  Future<void> toggleFavorite(String jobId) async {
    if (jobId.isEmpty) return;

    // 1. Find the index and get a reference to the job object
    final index = jobPost?.indexWhere((job) => job.id == jobId);
    if (index == null || index == -1) {
      print("Error: Job ID not found in the list.");
      return;
    }

    final job = jobPost![index];
    final isCurrentlySaved = job.isFavourite ?? false;

    // 2. Optimistic Update: Change the state immediately and update the UI
    job.isFavourite = !isCurrentlySaved;
    update(); // Triggers the GetBuilder/GetX widget to refresh

    try {
      // 3. Perform the asynchronous API call
      final response = await ApiService.post(
          ApiEndPoint.favourite,
          body: {
            "post": jobId,
          },
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        // Success: Optimistic state holds.
        Get.snackbar(
          "Success",
          isCurrentlySaved ? "Job removed from favorites" : "Job marked as favorite",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // 4. API Failure: Revert the local state and update the UI
        job.isFavourite = isCurrentlySaved;
        update();
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      // 5. Exception: Revert the local state and update the UI
      job.isFavourite = isCurrentlySaved;
      update();
      Utils.errorSnackBar(0, "Failed to toggle favorite: ${e.toString()}");
    }
  }
}