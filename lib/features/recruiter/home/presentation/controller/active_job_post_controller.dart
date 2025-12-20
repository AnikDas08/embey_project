import 'package:embeyi/core/services/storage/storage_services.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/job_model.dart';

class ActiveJobPostController extends GetxController {
  // Observable list for active jobs
  final RxList<Map<String, dynamic>> activeJobs = <Map<String, dynamic>>[].obs;

  final RxList<JobData> recentJobs = <JobData>[].obs;
  final isLoadingJob=false.obs;

  @override
  void onInit() {
    super.onInit();
    getJobs();
  }


  Future<void> getJobs() async {
    isLoadingJob.value = true;
    update();
    try {
      final response = await ApiService.get(
          ApiEndPoint.job_all+"?status=active",
          header: {"Authorization": "Bearer ${LocalStorage.token}"}
      );
      if (response.statusCode == 200) {
        final jobModel = RecruiterJobModel.fromJson(response.data);
        recentJobs.value = jobModel.data.toList(); // Get first 3 jobs for recent
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingJob.value = false;
    update();
  }

  void createNewJobPost() {
    // Handle create new job post action
    Get.snackbar('Create Job', 'Opening job creation form...');
  }

  void viewJobDetails(String jobTitle) {
    // Handle job details view
    Get.snackbar('Job Details', 'Opening $jobTitle details...');
  }
}
