// lib/features/company/controllers/company_overview_controller.dart

import 'package:embeyi/core/config/api/api_end_point.dart';
import 'package:embeyi/features/job_seeker/jobs/data/model/company_jobitem_model.dart';
import 'package:get/get.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../data/model/company_overview_model.dart';

class CompanyOverviewController extends GetxController {
  String? id;
  final RxBool isLoading = true.obs;
  final Rx<CompanyOverviewModel?> companyData = Rx<CompanyOverviewModel?>(null);

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments as String?;
    if (id != null) {
      fetchCompanyDetails();
    }
  }

  Future<void> fetchCompanyDetails() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get('user/recruiter/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        companyData.value = CompanyOverviewModel.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to load company details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load company details: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Getter methods for easy access
  String get companyName => companyData.value!.data.user.name ?? 'Company Name';

  String get companyImage => companyData.value?.data.user.cover ?? '';

  String get companyLogo => companyData.value?.data.user.image ?? '';
  String get overviewDescription => companyData.value?.data.user.overview ?? '';
  String get  aboutDescription=> companyData.value?.data?.user?.aboutUs ?? '';

  String get tagline => companyData.value?.data?.user?.role ?? 'Recruiter';

  /*String get overviewDescription {
    final user = companyData.value?.data?.user;
    if (user == null) return '';

    return 'Welcome to ${user.name ?? 'our company'}!\n\n'
        'Role: ${user.role ?? 'Not specified'}\n'
        'Status: ${user.status ?? 'Active'}\n'
        'Verified: ${user.verified == true ? 'Yes' : 'No'}\n\n'
        'Email: ${user.email ?? 'Not provided'}\n'
        'Member since: ${_formatDate(user.createdAt)}';
  }*/

  List<String> get galleryImages {
    final gallery = companyData.value?.data?.gallery;
    if (gallery == null || gallery.isEmpty) return [];


    return gallery.map((img) {
      if (img.startsWith('http')) return img;
      // Assuming your API returns relative paths like "/image/..."
      return '${ApiEndPoint.imageUrl}$img';
    }).toList();
  }

  /*String get aboutDescription {
    final user = companyData.value?.data?.user;
    if (user == null) return '';

    return 'About ${user.name ?? 'Us'}\n\n'
        'We are a ${user.role?.toLowerCase() ?? 'professional'} dedicated to connecting talented individuals with great opportunities.\n\n'
        'Our Status: ${user.status ?? 'Active'}\n'
        'Verified Account: ${user.verified == true ? 'Yes' : 'No'}\n\n'
        'Skills: ${user.skills?.isNotEmpty == true ? user.skills!.join(', ') : 'Not specified'}\n'
        'Education: ${user.educations?.length ?? 0} entries\n'
        'Work Experience: ${user.workExperiences?.length ?? 0} entries';
  }*/

  List<CompanyJobItemdata> get companyJobs {
    final jobs = companyData.value?.data?.recentJobs;
    if (jobs == null || jobs.isEmpty) return [];


    return jobs.map((job) {
      // Handle thumbnail URL
      String? thumbnailUrl;
      if (job.thumbnail != null) {
        if (job.thumbnail!.startsWith('http')) {
          thumbnailUrl = job.thumbnail;
        } else {
          thumbnailUrl = '${ApiEndPoint.imageUrl}${job.thumbnail}';
        }
      }

      return CompanyJobItemdata(
        id: job.id,
        title: job.title ?? 'Job Title',
        location: job.location ?? 'Location not specified',
        salary: job.formattedSalary,
        thumbnail: thumbnailUrl,
        jobType: job.jobType,
        jobLevel: job.jobLevel,
        experienceLevel: job.experienceLevel,
        deadline: job.deadline,
        description: job.description,
      );
    }).toList();
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}