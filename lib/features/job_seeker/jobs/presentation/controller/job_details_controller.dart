import 'package:get/get.dart';

import '../../../../../core/services/api/api_service.dart';
import '../../data/model/job_details_model.dart';

class JobDetailsController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rx<JobPostModel?> jobData = Rx<JobPostModel?>(null);

  String? jobId;
  String? url;
  bool? isNotSystem;
  String? minSalary;
  String? maxSalary;
  String? recruiter_company;
  String? salary_status;
  String? location;
  String? deadline;
  List<String>? requiredSkills;
  List<String>? responsibilities;
  List<String>? benefits;


  @override
  void onInit() {
    super.onInit();
    jobId = Get.arguments as String?;
    if (jobId != null) {
      fetchJobDetails();
    }
  }

  Future<void> fetchJobDetails() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get('job-post/$jobId');

      if (response.statusCode == 200) {
        final data = response.data;
        jobData.value = JobPostModel.fromJson(data['data']);
        url=response.data["data"]["job_url"]??"";
        isNotSystem=response.data["data"]["is_third_party_job"];
        recruiter_company=response.data["data"]["recruiter_company"]??"";
        salary_status=response.data["data"]["salary_status"]??"";
        location=response.data["data"]["location"]??"";
        deadline=response.data["data"]["deadline"]??"";
        responsibilities = List<String>.from(data["responsibilities"] ?? []);
        benefits = List<String>.from(data["benefits"] ?? []);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load job details');
    } finally {
      isLoading.value = false;
    }
  }

  String getJobTitle() => jobData.value?.title ?? 'Job Title';
  String getRecuirterId() => jobData.value?.recruiter!.id ?? '';
  String getUrl() => jobData.value?.recruiter!.id ?? '';

  String getLocation() => jobData.value?.location ?? 'Location';

  String getSalary() {
    final minSalary = jobData.value?.minSalary ?? 0;
    final maxSalary = jobData.value?.maxSalary ?? 0;
    return '\$${minSalary} - \$${maxSalary}';
  }

  String getJobType() {
    final type = jobData.value?.jobType ?? 'FULL_TIME';
    return type.toString().replaceAll('_', ' ');
  }

  String getExperience() => jobData.value?.experienceLevel ?? 'Experience';

  String getDeadline() {
    final deadline = jobData.value?.deadline;
    if (deadline == null) return 'N/A';
    return '${deadline.day} ${_getMonthName(deadline.month)}';
  }

  String getPostedDate() {
    final createdAt = jobData.value?.createdAt;
    if (createdAt == null) return 'Recently';
    final diff = DateTime.now().difference(createdAt).inDays;
    return '$diff Days Ago';
  }

  String getCompanyName() => jobData.value?.recruiter!.name ?? 'Company';

  String getCompanyLogo() => jobData.value?.recruiter!.image ?? '';

  String getThumbnail() => jobData.value?.thumbnail ?? '';

  String getDescription() => jobData.value?.description ?? 'No description available';

  String getCategory() => jobData.value?.category ?? '';

  List<String> getRequiredSkills() => jobData.value?.requiredSkills ?? [];

  bool isFullTime() => jobData.value?.jobType == 'FULL_TIME';


  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}