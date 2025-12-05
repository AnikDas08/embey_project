// lib/features/company/models/company_overview_model.dart

class CompanyOverviewModel {
  final bool? success;
  final String? message;
  final CompanyData? data;

  CompanyOverviewModel({
    this.success,
    this.message,
    this.data,
  });

  factory CompanyOverviewModel.fromJson(Map<dynamic, dynamic> json) {
    return CompanyOverviewModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? CompanyData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CompanyData {
  final User? user;
  final List<String>? gallery;
  final List<RecentJob>? recentJobs;

  CompanyData({
    this.user,
    this.gallery,
    this.recentJobs,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      gallery: json['gallery'] != null
          ? List<String>.from(json['gallery'] as List)
          : null,
      recentJobs: json['recentJobs'] != null
          ? (json['recentJobs'] as List)
          .map((job) => RecentJob.fromJson(job as Map<String, dynamic>))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'gallery': gallery,
      'recentJobs': recentJobs?.map((job) => job.toJson()).toList(),
    };
  }
}

class User {
  final String? id;
  final String? name;
  final String? role;
  final String? email;
  final String? image;
  final String? status;
  final bool? verified;
  final bool? isSocialLogin;
  final List<dynamic>? skills;
  final List<dynamic>? educations;
  final List<dynamic>? workExperiences;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.name,
    this.role,
    this.email,
    this.image,
    this.status,
    this.verified,
    this.isSocialLogin,
    this.skills,
    this.educations,
    this.workExperiences,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      status: json['status'] as String?,
      verified: json['verified'] as bool?,
      isSocialLogin: json['isSocialLogin'] as bool?,
      skills: json['skills'] as List<dynamic>?,
      educations: json['educations'] as List<dynamic>?,
      workExperiences: json['workExperiences'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'email': email,
      'image': image,
      'status': status,
      'verified': verified,
      'isSocialLogin': isSocialLogin,
      'skills': skills,
      'educations': educations,
      'workExperiences': workExperiences,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CompanyJobItem {
  final String title;
  final String location;
  final String salary;

  CompanyJobItem({
    required this.title,
    required this.location,
    required this.salary,
  });
}

class RecentJob {
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
  final String? deadline;
  final GeoLocation? geoLocation;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;

  RecentJob({
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
    this.geoLocation,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory RecentJob.fromJson(Map<String, dynamic> json) {
    return RecentJob(
      id: json['_id'] as String?,
      thumbnail: json['thumbnail'] as String?,
      recruiter: json['recruiter'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      category: json['category'] as String?,
      jobType: json['job_type'] as String?,
      jobLevel: json['job_level'] as String?,
      experienceLevel: json['experience_level'] as String?,
      minSalary: json['min_salary'] as int?,
      maxSalary: json['max_salary'] as int?,
      location: json['location'] as String?,
      requiredSkills: json['required_skills'] != null
          ? List<String>.from(json['required_skills'] as List)
          : null,
      deadline: json['deadline'] as String?,
      geoLocation: json['gioLocation'] != null
          ? GeoLocation.fromJson(json['gioLocation'] as Map<String, dynamic>)
          : null,
      isDeleted: json['is_deleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
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
      'deadline': deadline,
      'gioLocation': geoLocation?.toJson(),
      'is_deleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String get formattedSalary {
    if (minSalary == null && maxSalary == null) return 'Salary not specified';
    if (minSalary != null && maxSalary != null) {
      return '\$${minSalary} - \$${maxSalary}';
    }
    if (minSalary != null) return '\$${minSalary}+';
    return '\$${maxSalary}';
  }

  String get formattedJobType {
    if (jobType == null) return '';
    return jobType!.replaceAll('_', ' ').toLowerCase().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}

class GeoLocation {
  final String? type;
  final List<double>? coordinates;

  GeoLocation({
    this.type,
    this.coordinates,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      type: json['type'] as String?,
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}