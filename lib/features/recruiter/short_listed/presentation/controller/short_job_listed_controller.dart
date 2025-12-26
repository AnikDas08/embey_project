import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_utils.dart';
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

  Future<void> deletePost(String postId)async{
    try{
      final response=await ApiService.delete(
          "application/$postId"
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
