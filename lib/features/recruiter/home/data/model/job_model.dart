class RecruiterJobModel {
  final bool success;
  final String message;
  final Pagination pagination;
  final List<JobData> data;

  RecruiterJobModel({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory RecruiterJobModel.fromJson(Map<dynamic, dynamic> json) {
    return RecruiterJobModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List?)
          ?.map((item) => JobData.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class Pagination {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  Pagination({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
    );
  }
}

class JobData {
  final String id;
  final String thumbnail;
  final RecruiterInfo recruiter;
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
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final List<String> responsibilities;
  final List<String> benefits;
  final List<String> userImages;
  final int totalApplications;
  final GeoLocation? geoLocation;

  JobData({
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
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.responsibilities,
    required this.benefits,
    required this.userImages,
    required this.totalApplications,
    this.geoLocation,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      recruiter: RecruiterInfo.fromJson(json['recruiter'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      category: json['category'] ?? '',
      jobType: json['job_type'] ?? '',
      jobLevel: json['job_level'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      minSalary: json['min_salary'] ?? 0,
      maxSalary: json['max_salary'] ?? 0,
      location: json['location'] ?? '',
      requiredSkills: (json['required_skills'] as List?)
          ?.map((skill) => skill.toString())
          .toList() ??
          [],
      deadline: json['deadline'] ?? '',
      isDeleted: json['is_deleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      responsibilities: (json['responsibilities'] as List?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      benefits: (json['benefits'] as List?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      userImages: (json['userImages'] as List?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      totalApplications: json['totalapplications'] ?? 0,
      geoLocation: json['gioLocation'] != null
          ? GeoLocation.fromJson(json['gioLocation'])
          : null,
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

class RecruiterInfo {
  final String id;
  final String name;
  final String email;
  final String image;

  RecruiterInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory RecruiterInfo.fromJson(Map<String, dynamic> json) {
    return RecruiterInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class GeoLocation {
  final String type;
  final List<double> coordinates;

  GeoLocation({
    required this.type,
    required this.coordinates,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List?)
          ?.map((coord) => (coord as num).toDouble())
          .toList() ??
          [],
    );
  }
}