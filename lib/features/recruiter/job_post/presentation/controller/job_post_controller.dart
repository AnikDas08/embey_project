import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/job_model.dart';

class RecruiterJobPostController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final RxBool isLoadingJob = false.obs;

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
    getJobs(page: 1, isInitial: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void resetPagination() {
    currentPage.value = 1;
    hasMoreData.value = true;
    isLoadingMore.value = false;
    isLoadingJob.value = false; // Ensure this isn't stuck at true
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      // Trigger when user scrolls 90% down
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.9) {
        if (!isLoadingMore.value && hasMoreData.value && !isLoadingJob.value) {
          loadMoreJobs();
        }
      }
    });
  }

  Future<void> getJobs({int page = 1, bool isInitial = false}) async {
    if (isInitial) {
      isLoadingJob.value = true;
      hasMoreData.value = true;
      currentPage.value = 1;
    }

    try {
      final statusQuery = selectedTabIndex.value == 0 ? "active" : "closed";
      final response = await ApiService.get(
        "${ApiEndPoint.job_all}?status=$statusQuery&page=$page",
      );

      if (response.statusCode == 200) {
        final jobModel = RecruiterJobModel.fromJson(response.data);
        final List<JobData> fetchedJobs = jobModel.data ?? [];

        if (response.data['pagination'] != null) {
          totalPages.value = response.data['pagination']['totalPage'] ?? 1;
          currentPage.value = page;
          // Check if we have more pages to load
          hasMoreData.value = currentPage.value < totalPages.value;
        } else {
          hasMoreData.value = false;
        }

        if (isInitial) {
          recentJobs.assignAll(fetchedJobs);
        } else {
          recentJobs.addAll(fetchedJobs);
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoadingJob.value = false;
    }
  }

  Future<void> loadMoreJobs() async {
    isLoadingMore.value = true;
    await getJobs(page: currentPage.value + 1);
    isLoadingMore.value = false;
  }

  void selectTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
    getJobs(page: 1, isInitial: true);
  }

  Future<void> refreshData() async {
    await getJobs(page: 1, isInitial: true);
  }

  void createNewJobPost() => RecruiterRoutes.goToCreateJobPost();

  void viewJobDetails(String jobId) {
    Get.toNamed(RecruiterRoutes.jobCardDetails, arguments: {"postId": jobId});
  }
}