import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/job_model.dart';

class ActiveJobPostController extends GetxController {
  // Observables
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final RxBool isLoadingJob = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final RxInt currentPage = 1.obs;

  // Scroll Controller for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
    getJobs(isInitial: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Detects when user scrolls to the bottom
  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.9) {
        if (!isLoadingMore.value && hasMoreData.value && !isLoadingJob.value) {
          getJobs(isInitial: false);
        }
      }
    });
  }

  Future<void> getJobs({bool isInitial = false}) async {
    if (isInitial) {
      isLoadingJob.value = true;
      currentPage.value = 1;
      hasMoreData.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await ApiService.get(
          "${ApiEndPoint.job_all}?status=active&page=${currentPage.value}",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final jobModel = RecruiterJobModel.fromJson(response.data);
        final List<JobData> fetchedJobs = jobModel.data;

        if (isInitial) {
          recentJobs.assignAll(fetchedJobs);
        } else {
          recentJobs.addAll(fetchedJobs);
        }

        // Handle Pagination Logic
        if (response.data['pagination'] != null) {
          int totalPages = response.data['pagination']['totalPage'] ?? 1;
          hasMoreData.value = currentPage.value < totalPages;
          if (hasMoreData.value) currentPage.value++;
        } else {
          hasMoreData.value = false;
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoadingJob.value = false;
      isLoadingMore.value = false;
    }
  }

  void createNewJobPost() {
    Get.snackbar('Success', 'Redirecting to create job...');
  }
}