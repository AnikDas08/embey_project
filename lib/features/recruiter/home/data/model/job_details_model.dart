class JobDetailsModel {
  final bool success;
  final String message;
  final JobDetailsData data;

  JobDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory JobDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    return JobDetailsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: JobDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class JobDetailsData {
  final String id;
  final String thumbnail;
  final JobRecruiter recruiter;
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
  final String deadline;
  final JobGeoLocation geoLocation;
  final bool isDeleted;
  final List<String> responsibilities;
  final List<String> benefits;
  final String createdAt;
  final String updatedAt;
  final String categoryId;
  final int totalApplications;
  final List<String> userImages;

  JobDetailsData({
    required this.id,
    required this.thumbnail,
    required this.recruiter,
    required this.title,
    required this.description,
    required this.status,
    required this.category,
    required this.jobType,
    required this.jobLevel,
    required this.experienceLevel,
    required this.minSalary,
    required this.maxSalary,
    required this.location,
    required this.requiredSkills,
    required this.deadline,
    required this.geoLocation,
    required this.isDeleted,
    required this.responsibilities,
    required this.benefits,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.totalApplications,
    required this.userImages,
  });

  factory JobDetailsData.fromJson(Map<String, dynamic> json) {
    return JobDetailsData(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      recruiter: JobRecruiter.fromJson(json['recruiter'] ?? {}),
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      category: json['category'] is Map
          ? (json['category']['name'] ?? '')
          : (json['category']?.toString() ?? ''),
      jobType: json['job_type'] ?? '',
      jobLevel: json['job_level'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      minSalary: json['min_salary'] ?? 0,
      maxSalary: json['max_salary'] ?? 0,
      location: json['location'] ?? '',
      requiredSkills: (json['required_skills'] as List?)
          ?.map((skill) => skill is Map ? skill['name'].toString() : skill.toString())
          .toList() ?? [],

      deadline: json['deadline']?.toString() ?? '',

      // gioLocation key check (matches your JSON: "gioLocation")
      geoLocation: JobGeoLocation.fromJson(json['gioLocation'] ?? {}),
      isDeleted: json['is_deleted'] ?? false,
      responsibilities: (json['responsibilities'] as List?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      benefits:
      (json['benefits'] as List?)?.map((item) => item.toString()).toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      categoryId: json['categoryId'] ?? '',
      totalApplications: json['totalapplications'] ?? 0,
      userImages: (json['userImages'] as List?)
          ?.map((image) => image.toString())
          .toList() ??
          [],
    );
  }

  // Helper methods
  bool get isFullTime => jobType == 'FULL_TIME';
  bool get isRemote => jobType == 'REMOTE';

  String get formattedDeadline {
    try {
      final date = DateTime.parse(deadline);
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthShort(date.month)} ${date.year.toString().substring(2)}';
    } catch (e) {
      return deadline;
    }
  }

  String _getMonthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

class JobRecruiter {
  final String id;
  final String name;
  final String email;
  final String image;

  JobRecruiter({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory JobRecruiter.fromJson(Map<String, dynamic> json) {
    return JobRecruiter(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class JobGeoLocation {
  final String type;
  final List<double> coordinates;

  JobGeoLocation({
    required this.type,
    required this.coordinates,
  });

  factory JobGeoLocation.fromJson(Map<String, dynamic> json) {
    return JobGeoLocation(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List?)
          ?.map((coord) => (coord as num).toDouble())
          .toList() ??
          [],
    );
  }
}