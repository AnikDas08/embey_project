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
      } else {
        Utils.errorSnackBar(response.statusCode, response.message);
      }
    } catch (e) {
      Utils.errorSnackBar(0, e.toString());
    }
    isLoadingProfile.value = false;
    update();
  }

  Future<void> readNotification()async{
    try{
      final response = await ApiService.get(
          "notification",
          header: {
            "Content-Type": "application/json",
          }
      );
      if(response.statusCode==200){
        final data = response.data['data'];
        final count=data["unreadCount"];
        if(count!=0){
          notificationCount.value=true;
        }
        else{
          notificationCount.value=false;
        }
      }
    }
    catch(e){

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

  void refreshData() {
    getProfile();
    getJobs();
  }
}