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

  // ✅ CRITICAL FIX: Changed from List<JobPost>? to RxList
  RxList<JobPost> jobPost = <JobPost>[].obs;
  RxBool isLoadingJobs = false.obs;

  // Filter parameters
  RxString searchTerm = ''.obs;
  RxString selectedCategory = ''.obs;
  RxInt minSalary = 0.obs;
  RxInt maxSalary = 100000.obs;
  RxList<String> selectedJobTypes = <String>[].obs;
  RxList<String> selectedJobLevels = <String>[].obs;
  RxString selectedExperienceLevel = ''.obs;
  String categoryId = "";
  RxBool isNotification = false.obs;
  RxBool autoApplHere = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getBanner();
    fetchCategories();
    getPost();
    readNotification();
  }

  @override
  void onClose() {
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
        autoApplHere.value = response.data["data"]["isAutoApply"] ?? false;
        print("imageurl 😂😂😂😂: ${image.value}");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
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
            "Content-Type": "application/json",
          }
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final count = data["unreadCount"];
        isNotification.value = count != 0;
      }
    } catch (e) {
      // Handle error silently
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
    autoApplHere.value = value;

    try {
      final response = await ApiService.post(
          "user/auto-apply",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Auto Apply ${value ? 'Enabled' : 'Disabled'}");
      } else {
        Get.snackbar("Error", "Auto Apply ${value ? 'Enabled' : 'Disabled'}");
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
  }

  String _buildQueryParams() {
    List<String> params = [];

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

    return params.isEmpty ? '' : '?${params.join('&')}';
  }

  Future<void> getPost({bool useFilter = false}) async {
    isLoadingJobs.value = true;

    try {
      String endpoint;

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
        final jobPostResponse = JobPostResponse.fromJson(response.data);

        print("Parsed Success: ${jobPostResponse.success}");
        print("Parsed Message: ${jobPostResponse.message}");
        print("Data is null? ${jobPostResponse.data == null}");
        print("Data length: ${jobPostResponse.data?.length ?? 0}");

        // ✅ CRITICAL FIX: Use .value assignment for RxList
        if (jobPostResponse.data != null && jobPostResponse.data!.isNotEmpty) {
          jobPost.value = jobPostResponse.data!;
          print("✅ Job posts assigned: ${jobPost.length} items");

          if (jobPost.isNotEmpty) {
            final firstJob = jobPost[0];
            print("First Job Title: ${firstJob.title}");
            print("First Job Location: ${firstJob.location}");
            print("First Job Salary: ${firstJob.minSalary} - ${firstJob.maxSalary}");
          }
        } else {
          jobPost.clear();
          print("⚠️ No jobs found in response");
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
        jobPost.clear();
        print("❌ Error response: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("❌ Exception in getPost: $e");
      print("Stack trace: $stackTrace");
      Utils.errorSnackBar(0, "Failed to load jobs: ${e.toString()}");
      jobPost.clear();
    } finally {
      isLoadingJobs.value = false;
      print("============ END JOB POST RESPONSE ============");
    }
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

    // ✅ FIX: Updated to work with RxList
    final index = jobPost.indexWhere((job) => job.id == jobId);
    if (index == -1) {
      print("Error: Job ID not found in the list.");
      return;
    }

    final job = jobPost[index];
    final isCurrentlySaved = job.isFavourite ?? false;

    // Optimistic Update
    job.isFavourite = !isCurrentlySaved;
    jobPost.refresh(); // Trigger RxList update

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
  }
}