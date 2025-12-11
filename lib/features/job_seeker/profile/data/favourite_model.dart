class FavouriteResponse {
  final bool success;
  final String message;
  final List<FavouriteItem> data;
  final Pagination pagination;

  FavouriteResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory FavouriteResponse.fromJson(Map<dynamic, dynamic> json) {
    return FavouriteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => FavouriteItem.fromJson(item))
          .toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : Pagination(total: 0, limit: 0, page: 0, totalPage: 0),
    );
  }
}

class FavouriteItem {
  final String id;
  final String user;
  final JobPost post;
  final String createdAt;
  final String updatedAt;

  FavouriteItem({
    required this.id,
    required this.user,
    required this.post,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavouriteItem.fromJson(Map<String, dynamic> json) {
    return FavouriteItem(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      post: JobPost.fromJson(json['post'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class JobPost {
  final String id;
  final String thumbnail;
  final String recruiter;
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
  final List<dynamic> responsibilities;
  final List<dynamic> benefits;
  final GeoLocation? geoLocation;

  JobPost({
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
    required this.responsibilities,
    required this.benefits,
    this.geoLocation,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      recruiter: json['recruiter'] ?? '',
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
      requiredSkills: json['required_skills'] != null
          ? List<String>.from(json['required_skills'])
          : [],
      deadline: json['deadline'] ?? '',
      isDeleted: json['is_deleted'] ?? false,
      responsibilities: json['responsibilities'] ?? [],
      benefits: json['benefits'] ?? [],
      geoLocation: json['gioLocation'] != null
          ? GeoLocation.fromJson(json['gioLocation'])
          : null,
    );
  }

  // Helper method to format salary range
  String get salaryRange {
    return '\$${minSalary}k - \$${maxSalary}k/month';
  }

  // Helper method to format job type
  String get formattedJobType {
    return jobType.replaceAll('_', ' ').toLowerCase().capitalize ?? jobType;
  }

  // Helper method to format deadline
  String get formattedDeadline {
    try {
      final date = DateTime.parse(deadline);
      return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year.toString().substring(2)}';
    } catch (e) {
      return deadline;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
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
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : [],
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
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

extension StringExtension on String {
  String? get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}