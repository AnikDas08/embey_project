// job_post_response.dart

class JobPostResponse {
  final bool? success;
  final String? message;
  final Pagination? pagination;
  final List<JobPost>? data;

  JobPostResponse({
    this.success,
    this.message,
    this.pagination,
    this.data,
  });

  factory JobPostResponse.fromJson(Map<dynamic, dynamic> json) {
    return JobPostResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => JobPost.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'pagination': pagination?.toJson(),
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class Pagination {
  final int? total;
  final int? limit;
  final int? page;
  final int? totalPage;

  Pagination({
    this.total,
    this.limit,
    this.page,
    this.totalPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      limit: json['limit'],
      page: json['page'],
      totalPage: json['totalPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
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
  final DateTime deadline;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
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
      requiredSkills: (json['required_skills'] as List<dynamic>?)
          ?.map((skill) => skill.toString())
          .toList() ??
          [],
      deadline: DateTime.parse(json['deadline'] ?? DateTime.now().toIso8601String()),
      isDeleted: json['is_deleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'thumbnail': thumbnail,
      'recruiter': recruiter,
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

  // Helper method to get salary range as string
  String getSalaryRange() {
    return '\$$minSalary - \$$maxSalary';
  }

  // Helper method to check if deadline has passed
  bool isExpired() {
    return DateTime.now().isAfter(deadline);
  }

  // Helper method to format job type
  String getFormattedJobType() {
    return jobType.replaceAll('_', ' ').toLowerCase().split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

// Usage Example:
//
// import 'dart:convert';
//
// void main() {
//   String jsonString = '...'; // Your JSON string
//
//   final Map<String, dynamic> jsonData = json.decode(jsonString);
//   final JobPostResponse response = JobPostResponse.fromJson(jsonData);
//
//   print('Total jobs: ${response.pagination.total}');
//
//   for (var job in response.data) {
//     print('Title: ${job.title}');
//     print('Location: ${job.location}');
//     print('Salary: ${job.getSalaryRange()}');
//     print('Skills: ${job.requiredSkills.join(", ")}');
//     print('---');
//   }
// }