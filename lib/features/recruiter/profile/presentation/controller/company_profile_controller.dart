import 'package:embeyi/core/utils/constants/app_icons.dart';
import 'package:embeyi/features/recruiter/profile/data/model/company_job_item_model.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/home_model.dart';
import '../../../home/data/model/job_model.dart';

class CompanyProfileController extends GetxController {
  // State management
  final RxInt selectedTabIndex = 0.obs;

  // Company data
  RxString companyImage = "".obs;
  RxString companyLogo = "".obs;
  RxString companyName = ''.obs;
  RxString companyBio = ''.obs;
  RxString aboutUs = ''.obs;
  RxString companyOverview = ''.obs;
  RxString mission = ''.obs;

  // Contact Info
  RxString website = ''.obs;
  RxString address = ''.obs;
  RxString contact = ''.obs;
  RxString email = ''.obs;

  // Overview details
  RxInt totalEmployees = 0.obs;
  RxString companyType = ''.obs;
  RxInt founded = 0.obs;
  RxString revenue = ''.obs;

  // Overview Summary
  RxInt activePosts = 0.obs;
  RxInt pendingRequest = 0.obs;
  RxInt shortlistRequest = 0.obs;
  RxInt interviewRequest = 0.obs;

  // Gallery images
  RxList<String> galleryImages = <String>[].obs;

  // Loading states
  RxBool isLoadingProfile = false.obs;
  RxBool isLoadingImage = false.obs;

  final Rx<RecruiterProfileData?> profileData = Rx<RecruiterProfileData?>(null);

  final RxInt selectedTabIndexJobs = 0.obs; // 0 = Active, 1 = Closed
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final RxBool isLoadingJob = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCompanyProfile();
    getGalleryImages();
  }

  Future<void> getCompanyProfile() async {
    isLoadingProfile.value = true;
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.user,
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        // Basic info
        companyImage.value = data['image'] ?? '';
        companyLogo.value = data['cover'] ?? '';
        companyName.value = data['name'] ?? '';
        companyBio.value = data['bio'] ?? '';
        aboutUs.value = data['about_us'] ?? '';
        companyOverview.value = data['company_overview'] ?? '';
        mission.value = data['mission'] ?? '';

        // Contact Info
        if (data['contactInfo'] != null) {
          website.value = data['contactInfo']['website'] ?? '';
          address.value = data['contactInfo']['address'] ?? '';
          contact.value = data['contactInfo']['contact'] ?? '';
          email.value = data['contactInfo']['email'] ?? '';
        }

        // Overview
        if (data['overview'] != null) {
          totalEmployees.value = data['overview']['total_employees'] ?? 0;
          companyType.value = data['overview']['company_type'] ?? '';
          founded.value = data['overview']['founded'] ?? 0;
          revenue.value = data['overview']['revenue'] ?? '';
        }

        // Overview Summary
        if (data['overviewSummury'] != null) {
          activePosts.value = data['overviewSummury']['activePosts'] ?? 0;
          pendingRequest.value = data['overviewSummury']['pendingRequest'] ?? 0;
          shortlistRequest.value = data['overviewSummury']['shortlistRequest'] ?? 0;
          interviewRequest.value = data['overviewSummury']['interviewRequest'] ?? 0;
        }

        // Store full profile data if needed
        final profileModel = RecruiterProfileModel.fromJson(response.data);
        profileData.value = profileModel.data;
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingProfile.value = false;
    update();
  }

  Future<void> getJobs() async {
    isLoadingJob.value = true;

    // Clear list so the UI shows the loader clearly when switching tabs
    recentJobs.clear();

    try {
      // Determine status string based on tab index
      final statusQuery = selectedTabIndexJobs.value == 0 ? "active" : "closed";

      final response = await ApiService.get(
        "${ApiEndPoint.job_all}?status=$statusQuery",
      );

      if (response.statusCode == 200) {
        final jobModel = RecruiterJobModel.fromJson(response.data);
        recentJobs.value = jobModel.data;
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    } finally {
      isLoadingJob.value = false;
    }
  }

  void selectTab(int index) {
    if (selectedTabIndexJobs.value == index) return; // Prevent redundant calls
    selectedTabIndexJobs.value = index;
    getJobs();
  }

  Future<void> getGalleryImages() async {
    isLoadingImage.value = true;
    update();
    try {
      final response = await ApiService.get(
          "user/gallery",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as List;

        // Clear existing images
        galleryImages.clear();

        // Extract image URLs from the list
        for (var item in data) {
          if (item['image'] != null) {
            String imageUrl = item['image'];
            // If the image path doesn't start with http, add the base URL
            if (!imageUrl.startsWith('http')) {
              imageUrl = ApiEndPoint.imageUrl + imageUrl;
            }
            galleryImages.add(imageUrl);
          }
        }
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingImage.value = false;
    update();
  }

  // Refresh data
  Future<void> refreshData() async {
    await Future.wait([
      getCompanyProfile(),
      getGalleryImages(),
    ]);
  }

  // Methods
  void onTabSelected(int index) {
    selectedTabIndex.value = index;
    // If user switches to the Jobs tab (index 2), fetch the initial list
    if (index == 2 && recentJobs.isEmpty) {
      getJobs();
    }
  }
}