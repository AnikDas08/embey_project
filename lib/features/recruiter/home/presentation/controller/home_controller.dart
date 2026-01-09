import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/home_model.dart';
import '../../data/model/job_model.dart';

class RecruiterHomeController extends GetxController {
  // Observable list for recent jobs
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final Rx<RecruiterProfileData?> profileData = Rx<RecruiterProfileData?>(null);
  final RxString companyName = ''.obs;
  final RxString companyImage = ''.obs;
  final RxString companyAddress = ''.obs;
  final RxBool isLoadingJobs = false.obs;
  final RxBool isLoadingProfile = false.obs;
  final RxBool isNotification = false.obs;
  final RxInt activeJobs = 0.obs;
  RxInt notificationCounts = 0.obs;
  final RxInt pendingJobs = 0.obs;
  final RxInt shortListsJobs = 0.obs;
  final RxInt interviewJobs = 0.obs;

  // Pagination variables
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getJobs(page: 1, isInitial: true);
    readNotification();
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
  Future<void> getProfile() async {
    isLoadingProfile.value = true;
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final profileModel = RecruiterProfileModel.fromJson(response.data);
        profileData.value = profileModel.data;

        // Update observables for UI
        companyName.value = profileModel.data.name;
        companyImage.value = profileModel.data.image;
        companyAddress.value = profileModel.data.address;
        activeJobs.value = response.data["data"]["overviewSummury"]["activePosts"];
        pendingJobs.value = response.data["data"]["overviewSummury"]["pendingRequest"];
        shortListsJobs.value = response.data["data"]["overviewSummury"]["shortlistRequest"];
        interviewJobs.value = response.data["data"]["overviewSummury"]["interviewRequest"];

        print("activeJobs: ${activeJobs.value}");
        print("pendingJobs: ${pendingJobs.value}");
        print("shortListsJobs: ${shortListsJobs.value}");
        print("interviewJobs: ${interviewJobs.value}");
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingProfile.value = false;
    update();
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
  Future<void> getJobs({int page = 1, bool isInitial = false}) async {
    if (isInitial) {
      isLoadingJobs.value = true;
      recentJobs.clear();
      currentPage.value = 1;
      hasMoreData.value = true;
    }
    update();
    try {
      final response = await ApiService.get(
          "${ApiEndPoint.job_all}?page=$page",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
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
    }
    if (isInitial) {
      isLoadingJobs.value = false;
    }
    update();
  }
  Future<void> loadMoreJobs() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    isLoadingMore.value = true;
    update();
    try {
      await getJobs(page: currentPage.value + 1);
    } finally {
      isLoadingMore.value = false;
      update();
    }
  }
  /// Refreshes all data on the home screen
  Future<void> refreshData() async {
    currentPage.value = 1;
    hasMoreData.value = true;
    await Future.wait([
      getProfile(),
      getJobs(page: 1, isInitial: true),
      readNotification(),
    ]);
  }
}