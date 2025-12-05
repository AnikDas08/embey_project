// controllers/history_controller.dart

import 'package:embeyi/core/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/application_model_here.dart';


class HistoryController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Observables
  RxInt currentTabIndex = 0.obs;
  RxInt interviewFilterIndex = 0.obs; // 0 = Upcoming, 1 = Complete

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  // Data lists
  RxList<Application> allApplications = <Application>[].obs;
  RxList<Application> rejectedApplications = <Application>[].obs;
  RxList<Application> interviewApplications = <Application>[].obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt totalItems = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
      // Load data when tab changes
      loadDataForCurrentTab();
    });

    // Initial load
    loadDataForCurrentTab();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // Set interview filter and reload data
  void setInterviewFilter(int index) {
    interviewFilterIndex.value = index;
    loadInterviewApplications();
  }

  // Load data based on current tab
  void loadDataForCurrentTab() {
    currentPage.value = 1;

    switch (currentTabIndex.value) {
      case 0:
        loadAllApplications();
        break;
      case 1:
        loadRejectedApplications();
        break;
      case 2:
        loadInterviewApplications();
        break;
    }
  }

  // Load all applications
  Future<void> loadAllApplications({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
      currentPage.value++;
    } else {
      isLoading.value = true;
      currentPage.value = 1;
      allApplications.clear();
    }

    try {
      // API Call: GET /application?page=1&limit=10
      final response = await ApiService.get(
        'application?page=${currentPage.value}&limit=10',
      );

      if (response.statusCode == 200 && response.data != null) {
        final applicationResponse = ApplicationResponse.fromJson(response.data);

        if (applicationResponse.success) {
          if (loadMore) {
            allApplications.addAll(applicationResponse.data);
          } else {
            allApplications.value = applicationResponse.data;
          }

          totalPages.value = applicationResponse.pagination.totalPage;
          totalItems.value = applicationResponse.pagination.total;
        } else {
          Get.snackbar(
            'Error',
            applicationResponse.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load rejected applications
  Future<void> loadRejectedApplications({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
      currentPage.value++;
    } else {
      isLoading.value = true;
      currentPage.value = 1;
      rejectedApplications.clear();
    }

    try {
      // API Call: GET /application?status=REJECTED&page=1&limit=10
      final response = await ApiService.get(
        'application?status=REJECTED&page=${currentPage.value}&limit=10',
      );

      if (response.statusCode == 200 && response.data != null) {
        final applicationResponse = ApplicationResponse.fromJson(response.data);

        if (applicationResponse.success) {
          if (loadMore) {
            rejectedApplications.addAll(applicationResponse.data);
          } else {
            rejectedApplications.value = applicationResponse.data;
          }

          totalPages.value = applicationResponse.pagination.totalPage;
          totalItems.value = applicationResponse.pagination.total;
        } else {
          Get.snackbar(
            'Error',
            applicationResponse.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load interview applications
  Future<void> loadInterviewApplications({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
      currentPage.value++;
    } else {
      isLoading.value = true;
      currentPage.value = 1;
      interviewApplications.clear();
    }

    try {
      final interviewType = interviewFilterIndex.value == 0 ? 'upcoming' : 'complete';

      // API Call: GET /application?status=INTERVIEW&interview_type=upcoming&page=1&limit=10
      // or: GET /application?status=INTERVIEW&interview_type=complete&page=1&limit=10
      final response = await ApiService.get(
        'application?status=INTERVIEW&interview_type=$interviewType&page=${currentPage.value}&limit=10',
      );

      if (response.statusCode == 200 && response.data != null) {
        final applicationResponse = ApplicationResponse.fromJson(response.data);

        if (applicationResponse.success) {
          if (loadMore) {
            interviewApplications.addAll(applicationResponse.data);
          } else {
            interviewApplications.value = applicationResponse.data;
          }

          totalPages.value = applicationResponse.pagination.totalPage;
          totalItems.value = applicationResponse.pagination.total;
        } else {
          Get.snackbar(
            'Error',
            applicationResponse.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Refresh current tab
  Future<void> refreshCurrentTab() async {
    loadDataForCurrentTab();
  }

  // Get current list based on tab
  List<Application> getCurrentList() {
    switch (currentTabIndex.value) {
      case 0:
        return allApplications;
      case 1:
        return rejectedApplications;
      case 2:
        return interviewApplications;
      default:
        return [];
    }
  }

  // Load more for current tab
  void loadMoreForCurrentTab() {
    switch (currentTabIndex.value) {
      case 0:
        loadAllApplications(loadMore: true);
        break;
      case 1:
        loadRejectedApplications(loadMore: true);
        break;
      case 2:
        loadInterviewApplications(loadMore: true);
        break;
    }
  }
}