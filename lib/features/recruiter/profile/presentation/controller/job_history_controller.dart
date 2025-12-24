import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:get/get.dart';
import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../home/data/model/job_model.dart';

class JobHistoryController extends GetxController {
  final RxInt selectedTabIndex = 0.obs; // 0 = Active, 1 = Closed
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final RxBool isLoadingJob = false.obs;

  @override
  void onInit() {
    super.onInit();
    getJobs();
  }

  /// Fetches jobs based on the current selectedTabIndex
  Future<void> getJobs() async {
    isLoadingJob.value = true;

    // Clear list so the UI shows the loader clearly when switching tabs
    recentJobs.clear();

    try {
      // Determine status string based on tab index
      final statusQuery = selectedTabIndex.value == 0 ? "active" : "closed";

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

  /// This is the key fix: update index AND fetch new data
  void selectTab(int index) {
    if (selectedTabIndex.value == index) return; // Prevent redundant calls
    selectedTabIndex.value = index;
    getJobs();
  }

  void createNewJobPost() {
    RecruiterRoutes.goToCreateJobPost();
  }

  // Navigation with arguments
  void viewJobDetails(String jobId) {
    Get.toNamed(RecruiterRoutes.jobCardDetails, arguments: {"postId": jobId});
  }
}