import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:embeyi/core/services/api/api_service.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../data/model/job_details_model.dart';

class JobCardDetailsController extends GetxController {
  // Observable properties
  final RxString selectedFilter = ''.obs;
  final RxBool isSaved = false.obs;
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> candidates = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredCandidates =
      <Map<String, dynamic>>[].obs;

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

  @override
  void onInit() {
    super.onInit();
    // Get post ID from arguments
    postId = Get.arguments['postId'] ?? '';
    print("job post id : $postId");
    if (postId.isNotEmpty) {
      fetchJobDetails();
    }
    _loadMockCandidates();
  }

  Future<void> fetchJobDetails() async {
    try {
      isLoading.value = true;

      // TODO: Replace with your actual API service call
      // Example:
      // final response = await ApiService.getJobDetails(postId);
      // final jobDetailsModel = JobDetailsModel.fromJson(response);

      // For now, using mock data structure
      // You need to replace this with your actual API call
      final response=await ApiService.get("job-post/$postId");

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

        // Set initial filter and apply
        selectedFilter.value = filters[0];
        _applyFilter();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load job details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Mock API call - REPLACE THIS WITH YOUR ACTUAL API SERVICE
  Future<Map<String, dynamic>> _mockApiCall() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    return {
      "success": true,
      "message": "Post fetched successfully",
      "data": {
        "_id": "6934108559cfe9a273319041",
        "thumbnail": "/image/cardpic-1765523424581.png",
        "recruiter": {
          "_id": "6933e58959cfe9a273318e66",
          "name": "delwar",
          "email": "delwarbscse@gmail.com",
          "image": "https://i.ibb.co/z5YHLV9/profile.png"
        },
        "title": "UI/UX Designer",
        "description": "We need a ui/ux designer",
        "status": "active",
        "category": "Graphics Designer",
        "job_type": "FULL_TIME",
        "job_level": "MID_LEVEL",
        "experience_level": "1-3yrs",
        "min_salary": 2000,
        "max_salary": 2000,
        "location": "Cumilla Galaxy",
        "required_skills": ["creative design", "play football"],
        "deadline": "2026-11-13T00:00:00.000Z",
        "gioLocation": {
          "type": "Point",
          "coordinates": [55.718636, -4.942789]
        },
        "is_deleted": false,
        "responsibilities": [],
        "benefits": [],
        "createdAt": "2025-12-06T11:16:21.591Z",
        "updatedAt": "2025-12-12T07:10:24.688Z",
        "__v": 0,
        "categoryId": "69283df2bbe6451e2b25ce4b",
        "totalapplications": 2,
        "userImages": [
          "/image/image-1765355300219.png",
          "/image/image-1765355300219.png"
        ]
      }
    };
  }

  void _loadMockCandidates() {
    candidates.value = [
      {
        'name': 'Ronald Richards',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
        'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'matchPercentage': 90,
        'profileImage': AppImages.profile,
      },
      {
        'name': 'Albert Flores',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
        'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'matchPercentage': 70,
        'profileImage': AppImages.profile,
      },
      {
        'name': 'Cody Fisher',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
        'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'matchPercentage': 40,
        'profileImage': AppImages.profile,
      },
      {
        'name': 'Theresa Webb',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
        'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'matchPercentage': 78,
        'profileImage': AppImages.profile,
      },
      {
        'name': 'Wade Warren',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
        'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'matchPercentage': 81,
        'profileImage': AppImages.profile,
      },
    ];
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedFilter.value.startsWith('Candidate')) {
      filteredCandidates.value = candidates;
    } else if (selectedFilter.value == '70-80% MATCH') {
      filteredCandidates.value = candidates
          .where((c) => c['matchPercentage'] >= 70 && c['matchPercentage'] < 80)
          .toList();
    } else if (selectedFilter.value == '80-90% Match') {
      filteredCandidates.value = candidates
          .where((c) => c['matchPercentage'] >= 80 && c['matchPercentage'] < 90)
          .toList();
    } else if (selectedFilter.value == '90-95+') {
      filteredCandidates.value = candidates
          .where((c) => c['matchPercentage'] >= 90)
          .toList();
    }
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

  void viewCandidateProfile(String candidateName) {
    Get.snackbar('Candidate Profile', 'Opening $candidateName profile...');
    Get.toNamed(
      RecruiterRoutes.resume,
      arguments: {'isShortlist': true, 'isInterview': true, 'isReject': true},
    );
  }
}