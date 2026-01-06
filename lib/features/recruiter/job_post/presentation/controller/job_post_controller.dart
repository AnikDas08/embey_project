import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/job_model.dart';

class RecruiterJobPostController extends GetxController {
  final RxInt selectedTabIndex = 0.obs; // 0 = Active, 1 = Closed
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final RxBool isLoadingJob = false.obs;

  // Pagination variables
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getJobs(page: 1, isInitial: true);
    setupScrollListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.8) {
        if (!isLoadingMore.value && hasMoreData.value) {
          loadMoreJobs();
        }
      }
    });
  }

  /// Fetches jobs based on the current selectedTabIndex
  Future<void> getJobs({int page = 1, bool isInitial = false}) async {
    if (isInitial) {
      isLoadingJob.value = true;
      recentJobs.clear();
      currentPage.value = 1;
      hasMoreData.value = true;
    }

    try {
      // Determine status string based on tab index
      final statusQuery = selectedTabIndex.value == 0 ? "active" : "closed";

      final response = await ApiService.get(
        "${ApiEndPoint.job_all}?status=$statusQuery&page=$page",
      );

      if (response.statusCode == 200) {
        final jobModel = RecruiterJobModel.fromJson(response.data);

        // Update pagination info
        if (response.data['pagination'] != null) {
          totalPages.value = response.data['pagination']['totalPage'] ?? 1;
          currentPage.value = page;

          // Check if there's more data
          hasMoreData.value = currentPage.value < totalPages.value;
        }

        if (isInitial) {
          recentJobs.value = jobModel.data.toList();
        } else {
          recentJobs.addAll(jobModel.data.toList());
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      if (isInitial) {
        isLoadingJob.value = false;
      }
    }
  }

  Future<void> loadMoreJobs() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    isLoadingMore.value = true;

    try {
      await getJobs(page: currentPage.value + 1);
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// This is the key fix: update index AND fetch new data
  void selectTab(int index) {
    if (selectedTabIndex.value == index) return; // Prevent redundant calls
    selectedTabIndex.value = index;

    // Reset pagination when switching tabs
    currentPage.value = 1;
    hasMoreData.value = true;
    recentJobs.clear();

    getJobs(page: 1, isInitial: true);
  }

  /// Refresh data with pull-to-refresh
  Future<void> refreshData() async {
    currentPage.value = 1;
    hasMoreData.value = true;
    await getJobs(page: 1, isInitial: true);
  }

  void createNewJobPost() {
    RecruiterRoutes.goToCreateJobPost();
  }

  // Navigation with arguments
  void viewJobDetails(String jobId) {
    Get.toNamed(RecruiterRoutes.jobCardDetails, arguments: {"postId": jobId});
  }
}