import 'package:get/get.dart';
import '../../../../../core/services/api/api_service.dart';
import '../../data/model/job_details_model.dart';

class JobDetailsController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rx<JobPostModel?> jobData = Rx<JobPostModel?>(null);

  String jobId = "";
  String url = "";
  bool isNotSystem = false;
  String minSalary = "";
  String maxSalary = "";
  String recruiter_company = "";
  String salary_status = "";
  String location = "";
  String deadline = "";
  List<String> requiredSkills = [];
  List<String> responsibilities = [];
  List<String> benefits = [];

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    if (jobId.isNotEmpty) {
      fetchJobDetails();
    }
  }

  void _loadArguments() {
    try {
      final args = Get.arguments;
      if (args != null) {
        if (args is String) {
          jobId = args;
        } else if (args is Map) {
          jobId = args['jobId']?.toString() ?? "";
        }
      }
    } catch (e) {
      print('Error loading arguments: $e');
      jobId = "";
    }
  }

  Future<void> fetchJobDetails() async {
    try {
      isLoading.value = true;

      if (jobId.isEmpty) {
        Get.snackbar('Error', 'Job ID is required');
        return;
      }

      final response = await ApiService.get('job-post/$jobId');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data['data'] != null) {
          jobData.value = JobPostModel.fromJson(data['data']);

          // Safely extract additional fields
          url = data['data']['job_url']?.toString() ?? "";
          isNotSystem = data['data']['is_third_party_job'] ?? false;
          recruiter_company = data['data']['recruiter_company']?.toString() ?? "";
          salary_status = data['data']['salary_status']?.toString() ?? "";
          location = data['data']['location']?.toString() ?? "";
          deadline = data['data']['deadline']?.toString() ?? "";

          // Safely extract lists
          if (data['data']['responsibilities'] != null) {
            try {
              responsibilities = List<String>.from(
                  data['data']['responsibilities'].map((e) => e?.toString() ?? "")
              );
            } catch (e) {
              responsibilities = [];
            }
          }

          if (data['data']['benefits'] != null) {
            try {
              benefits = List<String>.from(
                  data['data']['benefits'].map((e) => e?.toString() ?? "")
              );
            } catch (e) {
              benefits = [];
            }
          }

          if (data['data']['required_skills'] != null) {
            try {
              requiredSkills = List<String>.from(
                  data['data']['required_skills'].map((e) => e?.toString() ?? "")
              );
            } catch (e) {
              requiredSkills = [];
            }
          }
        } else {
          Get.snackbar('Error', 'Invalid response data');
        }
      } else {
        Get.snackbar('Error', 'Failed to load job details');
      }
    } catch (e) {
      print('Error fetching job details: $e');
      Get.snackbar('Error', 'Failed to load job details: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  String getJobTitle() => jobData.value?.title ?? 'Job Title';

  String getRecuirterId() => jobData.value?.recruiter.id ?? '';

  String getUrl() => url;

  String getLocation() => location.isNotEmpty ? location : (jobData.value?.location ?? 'Location');

  String getSalary() {
    final min = jobData.value?.minSalary ?? 0;
    final max = jobData.value?.maxSalary ?? 0;
    if (min == 0 && max == 0) return 'Salary not specified';
    return '\$${min} - \$${max}';
  }

  String getJobType() {
    final type = jobData.value?.jobType ?? 'FULL_TIME';
    return type.replaceAll('_', ' ');
  }

  String getExperience() => jobData.value?.experienceLevel ?? 'Experience';

  String getDeadline() {
    if (deadline.isNotEmpty) {
      try {
        final deadlineDate = DateTime.parse(deadline);
        return '${deadlineDate.day} ${_getMonthName(deadlineDate.month)}';
      } catch (e) {
        // If parsing fails, try to use jobData deadline
      }
    }

    final jobDeadline = jobData.value?.deadline;
    if (jobDeadline == null) return 'N/A';
    return '${jobDeadline.day} ${_getMonthName(jobDeadline.month)}';
  }

  String getPostedDate() {
    final createdAt = jobData.value?.createdAt;
    if (createdAt == null) return 'Recently';
    final diff = DateTime.now().difference(createdAt).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return '1 Day Ago';
    return '$diff Days Ago';
  }

  String getCompanyName() {
    if (recruiter_company.isNotEmpty) return recruiter_company;
    return jobData.value?.recruiter.name ?? 'Company';
  }

  String getCompanyLogo() => jobData.value?.recruiter.image ?? '';

  String getThumbnail() => jobData.value?.thumbnail ?? '';

  String getDescription() => jobData.value?.description ?? 'No description available';

  String getCategory() => jobData.value?.category ?? '';

  List<String> getRequiredSkills() {
    if (requiredSkills.isNotEmpty) return requiredSkills;
    return jobData.value?.requiredSkills ?? [];
  }

  bool isFullTime() => jobData.value?.jobType == 'FULL_TIME';

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month < 1 || month > 12) return 'Jan';
    return months[month - 1];
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}

// Model Classes
class JobPostModel {
  final String id;
  final String thumbnail;
  final Recruiter recruiter;
  final String title;
  final String description;
  final String status;
  final String category;
  final String jobType;
  final String jobLevel;
  final String experienceLevel;
  final int minSalary;
  final int maxSalary;
  final String location;
  final List<String> requiredSkills;
  final DateTime deadline;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobPostModel({
    this.id = "",
    this.thumbnail = "",
    Recruiter? recruiter,
    this.title = "",
    this.description = "",
    this.status = "",
    this.category = "",
    this.jobType = "",
    this.jobLevel = "",
    this.experienceLevel = "",
    this.minSalary = 0,
    this.maxSalary = 0,
    this.location = "",
    List<String>? requiredSkills,
    DateTime? deadline,
    this.isDeleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : recruiter = recruiter ?? Recruiter(),
        requiredSkills = requiredSkills ?? [],
        deadline = deadline ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      try {
        if (value is String) return DateTime.parse(value);
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }

    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      try {
        if (value is List) {
          return value.map((e) => e?.toString() ?? "").where((s) => s.isNotEmpty).toList();
        }
        return [];
      } catch (e) {
        return [];
      }
    }

    return JobPostModel(
      id: json['_id']?.toString() ?? "",
      thumbnail: json['thumbnail']?.toString() ?? "",
      recruiter: json['recruiter'] != null
          ? Recruiter.fromJson(json['recruiter'] as Map<String, dynamic>)
          : Recruiter(),
      title: json['title']?.toString() ?? "",
      description: json['description']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      category: json['category']?.toString() ?? "",
      jobType: json['job_type']?.toString() ?? "",
      jobLevel: json['job_level']?.toString() ?? "",
      experienceLevel: json['experience_level']?.toString() ?? "",
      minSalary: (json['min_salary'] is int) ? json['min_salary'] : 0,
      maxSalary: (json['max_salary'] is int) ? json['max_salary'] : 0,
      location: json['location']?.toString() ?? "",
      requiredSkills: parseStringList(json['required_skills']),
      deadline: parseDateTime(json['deadline']),
      isDeleted: json['is_deleted'] ?? false,
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'thumbnail': thumbnail,
      'recruiter': recruiter.toJson(),
      'title': title,
      'description': description,
      'status': status,
      'category': category,
      'job_type': jobType,
      'job_level': jobLevel,
      'experience_level': experienceLevel,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'location': location,
      'required_skills': requiredSkills,
      'deadline': deadline.toIso8601String(),
      'is_deleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Recruiter {
  final String id;
  final String name;
  final String email;
  final String image;

  Recruiter({
    this.id = "",
    this.name = "",
    this.email = "",
    this.image = "",
  });

  factory Recruiter.fromJson(Map<String, dynamic> json) {
    return Recruiter(
      id: json['_id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      email: json['email']?.toString() ?? "",
      image: json['image']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}