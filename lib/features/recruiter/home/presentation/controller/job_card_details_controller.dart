import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/app_routes.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:embeyi/features/recruiter/home/data/model/application_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../../../../core/utils/app_utils.dart';
import '../../data/model/job_details_model.dart';

class JobCardDetailsController extends GetxController {
  // Observable properties
  final RxString selectedFilter = ''.obs;
  final RxBool isSaved = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingApplications = true.obs;

  // Changed from Map to ApplicationData
  final RxList<ApplicationData> applications = <ApplicationData>[].obs;

  // Job details - now fetched from API
  final Rx<JobDetailsData?> jobDetails = Rx<JobDetailsData?>(null);
  final jobTitle = ''.obs;
  final location = ''.obs;
  final candidateCount = 0.obs;
  final deadline = ''.obs;
  final isRemote = false.obs;
  final thumbnail = ''.obs;
  final RxList<String> userImages = <String>[].obs;

  // Filter options
  final RxList<String> filters = <String>[
    'Candidate (0)',
    '70-80% MATCH',
    '80-90% Match',
    '90-95+',
  ].obs;

  // Post ID from previous screen
  late String postId;
  TextEditingController deleteReason=TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Get post ID from arguments
    postId = Get.arguments['postId'] ?? '';
    print("job post id : $postId");
    if (postId.isNotEmpty) {
      fetchJobDetails();
    }
  }

  Future<void> fetchJobDetails() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get("job-post/$postId");

      final jobDetailsModel = JobDetailsModel.fromJson(response.data);

      if (jobDetailsModel.success) {
        jobDetails.value = jobDetailsModel.data;

        // Update observable properties
        jobTitle.value = jobDetailsModel.data.title;
        location.value = jobDetailsModel.data.location;
        deadline.value = jobDetailsModel.data.formattedDeadline;
        isRemote.value = jobDetailsModel.data.isRemote;
        thumbnail.value = jobDetailsModel.data.thumbnail;

        // Update candidate count and user images from API
        candidateCount.value = jobDetailsModel.data.totalApplications;
        userImages.value = jobDetailsModel.data.userImages;

        // Update filter labels with actual count
        filters[0] = 'Candidate (${jobDetailsModel.data.totalApplications})';

        // Set initial filter and fetch applications
        selectedFilter.value = filters[0];
        getApplicationValue(); // Fetch all applications initially
      }
    } catch (e) {
      print("Error fetching job details: $e");
      Get.snackbar('Error', 'Failed to load job details: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getApplicationValue({String? matchRange}) async {
    try {
      isLoadingApplications.value = true;

      // Build the API URL based on filter
      String apiUrl = "application?post=$postId";
      if (matchRange != null && matchRange.isNotEmpty) {
        apiUrl += "&match=$matchRange";
      }

      print("Fetching applications from: $apiUrl");

      final response = await ApiService.get(apiUrl);

      print("Applications API Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final applicationModelList = ApplicationListModel.fromJson(response.data);

        if (applicationModelList.success) {
          // Store the applications data
          applications.value = applicationModelList.data;

          print("Applications loaded: ${applications.length}");
        }
      }
    } catch (e) {
      print("Error fetching applications: $e");
      Get.snackbar('Error', 'Failed to load application details: $e');
    } finally {
      isLoadingApplications.value = false;
    }
  }

  Future<void> deletePost()async{
    try{
      final response=await ApiService.delete(
          "job-post/$postId"
      );
      if(response.statusCode==200){
        Utils.successSnackBar("Success", "Successful delete post");
        Get.offAllNamed(RecruiterRoutes.home);
      }
    }
    catch(e){
      Utils.errorSnackBar("Error", e.toString());
    }
  }



  void selectFilter(String filter) {
    selectedFilter.value = filter;

    // Determine the match range based on selected filter
    String? matchRange;


    if (filter.startsWith('Candidate')) {
      // Show all candidates - no match filter
      matchRange = null;
    } else if (filter == '70-80% MATCH') {
      matchRange = '70-80';
    } else if (filter == '80-90% Match') {
      matchRange = '80-90';
    } else if (filter == '90-95+') {
      matchRange = '90-100';
    }

    print("Selected filter: $filter, Match range: $matchRange");

    // Fetch applications with the new filter
    getApplicationValue(matchRange: matchRange);
  }

  void toggleSave() {
    isSaved.value = !isSaved.value;
  }

  void viewPost() {
    Get.snackbar('View Post', 'Opening job post details...');
  }

  void rePost() {
    Get.snackbar('Re-Post', 'Re-posting job...');
  }

  void closePost() {
    Get.snackbar('Close Post', 'Closing job post...');
  }

  void viewCandidateProfile(String applicationId) {
    Get.toNamed(
      RecruiterRoutes.resume,
      arguments: {
        'applicationId': applicationId,
        'isShortlist': true,
        'isInterview': true,
        'isReject': true
      },
    );
  }
}