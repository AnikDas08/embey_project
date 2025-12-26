import 'package:get/get.dart';

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
  final RxBool notificationCount = false.obs;
  final RxInt activeJobs = 0.obs;
  final RxInt pendingJobs = 0.obs;
  final RxInt shortListsJobs = 0.obs;
  final RxInt interviewJobs = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getJobs();
    readNotification();
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
        print("activeJobs: ${pendingJobs.value}");
        print("activeJobs: ${shortListsJobs.value}");
        print("activeJobs: ${activeJobs.value}");
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
            "Content-Type": "application/json",
          }
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final count = data["unreadCount"];
        if (count != 0) {
          notificationCount.value = true;
        } else {
          notificationCount.value = false;
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> getJobs() async {
    isLoadingJobs.value = true;
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.job_all,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final jobModel = RecruiterJobModel.fromJson(response.data);
        recentJobs.value = jobModel.data.toList();
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingJobs.value = false;
    update();
  }

  /// Refreshes all data on the home screen
  Future<void> refreshData() async {
    // Run all refresh operations in parallel for better performance
    await Future.wait([
      getProfile(),
      getJobs(),
      readNotification(),
    ]);
  }
}