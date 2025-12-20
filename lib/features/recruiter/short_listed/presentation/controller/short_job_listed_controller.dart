import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../../../../core/services/api/api_service.dart';
import '../../../home/data/model/application_model.dart';

class ShortJobListedController extends GetxController {
  // Observable list for shortlisted candidates
  final RxList<Map<String, dynamic>> shortlistedCandidates =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isLoadingApplications = true.obs;
  final RxList<ApplicationData> applications = <ApplicationData>[].obs;

  @override
  void onInit() {
    super.onInit();
    shortlistedMatch();
  }

  void _loadShortlistedCandidates() {
    shortlistedCandidates.value = [
      {
        'name': 'Kathryn Murphy',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
            'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'profileImage': AppImages.profile,
      },
      {
        'name': 'Esther Howard',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
            'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'profileImage': AppImages.profile,
      },
      {
        'name': 'Jane Cooper',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
            'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'profileImage': AppImages.profile,
      },
      {
        'name': 'Theresa Webb',
        'jobTitle': 'Sr. UI/UX Designer',
        'experience': '5 Years Experience',
        'description':
            'A Dedicated And Reliable Professional With Strong Teamwork And Problem Solving Skills, Committed To Delivering Quality Results On Time',
        'profileImage': AppImages.profile,
      },
    ];
  }

  Future<void> shortlistedMatch() async {
    try {
      isLoading.value = true;
      isLoadingApplications.value = true;

      final response = await ApiService.get("application?status=SHORTLISTED");

      if (response.statusCode == 200) {
        final applicationModelList = ApplicationListModel.fromJson(response.data);

        if (applicationModelList.success) {
          applications.value = applicationModelList.data;

          print("✅ Applications loaded: ${applications.length}");

          // Debug: Print first application to see structure
          if (applications.isNotEmpty) {
            print("📋 Sample application title: ${applications[0].title}");
          }
        }
      }
    } catch (e) {
      print("❌ Error loading applications: $e");
    } finally {
      isLoading.value = false;
      isLoadingApplications.value = false;
    }
  }

  void deleteCandidate(String index) {
    /*final candidateName = shortlistedCandidates[index]['name'];
    shortlistedCandidates.removeAt(index);
    Get.snackbar(
      'Removed',
      '$candidateName has been removed from shortlist',
      snackPosition: SnackPosition.BOTTOM,
    );*/
  }

  void viewCandidateProfile(String candidateIds) {
    Get.toNamed(
        RecruiterRoutes.resume,
        arguments: {
          "applicationId": candidateIds,
          'isShortlist': false,
          'isInterview': true,
          'isReject': true,
        },

    );
  }
}
