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
      // Allow success to be null if missing or not a bool
      success: json['success'] as bool?,
      // Allow message to be null if missing or not a string
      message: json['message'] as String?,
      // Allow pagination to be null if missing, or attempt parsing if present
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
      // Allow data list to be null if missing, or map to JobPost list
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => JobPost.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      // Use ?.toJson() for nullable nested objects
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
      // Allow fields to be null if missing or not an int
      total: json['total'] as int?,
      limit: json['limit'] as int?,
      page: json['page'] as int?,
      totalPage: json['totalPage'] as int?,
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
  final String? id;
  final String? thumbnail;
  final String? recruiter;
  final String? title;
  final String? description;
  final String? status;
  final String? category;
  final String? jobType;
  final String? jobLevel;
  final String? experienceLevel;
  final int? minSalary;
  final int? maxSalary;
  final String? location;
  final List<String>? requiredSkills;
  final DateTime? deadline;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JobPost({
    this.id,
    this.thumbnail,
    this.recruiter,
    this.title,
    this.description,
    this.status,
    this.category,
    this.jobType,
    this.jobLevel,
    this.experienceLevel,
    this.minSalary,
    this.maxSalary,
    this.location,
    this.requiredSkills,
    this.deadline,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    // Helper function to safely extract a potential nested 'name' string
    String? _extractNestedName(dynamic map) {
      if (map is Map<String, dynamic>) {
        return map['name'] as String?;
      }
      return map as String?; // Fallback if it's a string directly
    }

    // Safely parse DateTime strings
    DateTime? _parseDateTime(dynamic value) {
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return JobPost(
      id: json['_id'] as String?,
      thumbnail: json['thumbnail'] as String?,
      // Use the helper to extract the recruiter name string (handles nested object or string)
      recruiter: _extractNestedName(json['recruiter']),
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      // Use the helper to extract the category name string (handles nested object or string)
      category: _extractNestedName(json['category']),
      jobType: json['job_type'] as String?,
      jobLevel: json['job_level'] as String?,
      experienceLevel: json['experience_level'] as String?,
      minSalary: json['min_salary'] as int?,
      maxSalary: json['max_salary'] as int?,
      location: json['location'] as String?,
      // List parsing: List<dynamic>? is mapped to List<String>?
      requiredSkills: (json['required_skills'] as List<dynamic>?)
          ?.map((skill) => skill.toString())
          .toList(),
      // Use the safe DateTime parser
      deadline: _parseDateTime(json['deadline']),
      isDeleted: json['is_deleted'] as bool?,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
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
      // Use ?.toIso8601String() for nullable DateTime
      'deadline': deadline?.toIso8601String(),
      'is_deleted': isDeleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper method to get salary range as string
  String getSalaryRange() {
    // Use null-coalescing inside helper methods for presentation
    return '\$${minSalary ?? 0} - \$${maxSalary ?? 0}';
  }

  // Helper method to check if deadline has passed
  bool isExpired() {
    // If deadline is null, consider it not expired or handle as an error/default
    return deadline != null && DateTime.now().isAfter(deadline!);
  }

  // Helper method to format job type
  String getFormattedJobType() {
    final type = jobType ?? '';
    if (type.isEmpty) return 'N/A';

    return type.replaceAll('_', ' ').toLowerCase().split(' ')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}