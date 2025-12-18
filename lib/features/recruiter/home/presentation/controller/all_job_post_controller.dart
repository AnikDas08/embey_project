import 'package:embeyi/core/config/route/recruiter_routes.dart';
import 'package:get/get.dart';
import 'package:embeyi/core/utils/constants/app_images.dart';

import '../../../../../core/config/api/api_end_point.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../data/model/job_model.dart';

class AllJobPostController extends GetxController {
  // Observable properties
  final RxInt selectedTabIndex = 0.obs;
  final RxList<JobData> recentJobs = <JobData>[].obs;
  final RxList<Map<String, dynamic>> activeJobs = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> closedJobs = <Map<String, dynamic>>[].obs;
  RxBool isLoadingJobs=false.obs;
  String status="active";

  @override
  void onInit() {
    super.onInit();
    getJobs();
  }

  Future<void> getJobs() async {
    isLoadingJobs.value = true;
    update();
    try {
      final status=selectedTabIndex.value==0?"active":"closed";
      final response = await ApiService.get(
          ApiEndPoint.job_all+"?status=${status}",
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
    isLoadingJobs.value = false;
    update();
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
    status=selectedTabIndex.value==0?"active":"closed";
    getJobs();
  }

  List<Map<String, dynamic>> get currentJobs {
    return selectedTabIndex.value == 0 ? activeJobs : closedJobs;
  }

  void createNewJobPost() {
    RecruiterRoutes.goToCreateJobPost();
  }

  void viewJobDetails(String jobTitle) {
    RecruiterRoutes.goToJobCardDetails();
  }

  void editJobPost(String jobTitle) {
    RecruiterRoutes.goToEditJobPost();
  }
}
