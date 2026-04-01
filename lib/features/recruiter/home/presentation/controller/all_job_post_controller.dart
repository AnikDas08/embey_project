import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/job_model.dart';

class AllJobPostController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final RxBool isLoadingJobs = false.obs;

  // Pagination Variables
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

  void setupScrollListener() {
    scrollController.addListener(() {
      // Check if the controller is attached to any scroll view
      if (!scrollController.hasClients) return;

      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.9) {
        if (!isLoadingMore.value && hasMoreData.value && !isLoadingJobs.value) {
          loadMoreJobs();
        }
      }
    });
  }

  Future<void> getJobs({int page = 1, bool isInitial = false}) async {
    if (isInitial) {
      isLoadingJobs.value = true;
      currentPage.value = 1;
      hasMoreData.value = true;
    }

    try {
      final status = selectedTabIndex.value == 0 ? "active" : "closed";
      final response = await ApiService.get(
          "${ApiEndPoint.job_all}?status=$status&page=$page",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final jobModel = RecruiterJobModel.fromJson(response.data);
        final List<JobData> newJobs = jobModel.data ?? [];

        // Pagination Logic
        if (response.data['pagination'] != null) {
          totalPages.value = response.data['pagination']['totalPage'] ?? 1;
          currentPage.value = page;
          hasMoreData.value = currentPage.value < totalPages.value;
        } else {
          hasMoreData.value = false;
        }

        if (isInitial) {
          recentJobs.assignAll(newJobs);
        } else {
          // Append data for infinite scroll
          recentJobs.addAll(newJobs);
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoadingJobs.value = false;
      update();
    }
  }

  Future<void> loadMoreJobs() async {
    isLoadingMore.value = true;
    update();
    await getJobs(page: currentPage.value + 1);
    isLoadingMore.value = false;
    update();
  }

  void selectTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;

    // Reset scroll and data when switching tabs
    if (scrollController.hasClients) {
      scrollController.jumpTo(0.0);
    }

    getJobs(page: 1, isInitial: true);
  }

  /// Fix for Bottom Nav: Reset and Refresh everything


  Future<void> refreshData() async {
    // reset all flags to "un-stick" the scroll
    currentPage.value = 1;
    hasMoreData.value = true;
    isLoadingJobs.value = false;
    isLoadingMore.value = false;

    await getJobs(page: 1, isInitial: true);

    // Jump back to top so the listener starts fresh
    if (scrollController.hasClients) {
      scrollController.jumpTo(0.0);
    }
  }

  void createNewJobPost() => RecruiterRoutes.goToCreateJobPost();

  void viewJobDetails(String jobId) {
    Get.toNamed(RecruiterRoutes.jobCardDetails, arguments: {"postId": jobId});
  }

  void editJobPost(String jobId) {
    // RecruiterRoutes.goToEditJobPost();
  }
}