// lib/features/company/models/company_overview_model.dart

class CompanyOverviewModel {
  final bool success;
  final String message;
  final CompanyData data;

  CompanyOverviewModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompanyOverviewModel.fromJson(Map<dynamic, dynamic> json) {
    return CompanyOverviewModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? CompanyData.fromJson(json['data'] as Map<String, dynamic>)
          : CompanyData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class CompanyData {
  final User user;
  final List<String> gallery;
  final List<RecentJob> recentJobs;

  CompanyData({
    User? user,
    List<String>? gallery,
    List<RecentJob>? recentJobs,
  })  : user = user ?? User(),
        gallery = gallery ?? [],
        recentJobs = recentJobs ?? [];

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : User(),
      gallery: json['gallery'] != null
          ? List<String>.from(json['gallery'] as List)
          : [],
      recentJobs: json['recentJobs'] != null
          ? (json['recentJobs'] as List)
          .map((job) => RecentJob.fromJson(job as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'gallery': gallery,
      'recentJobs': recentJobs.map((job) => job.toJson()).toList(),
    };
  }
}

class User {
  final String id;
  final String name;
  final String role;
  final String email;
  final String image;
  final String cover;
  final String overview;
  final String aboutUs;
  final String status;
  final bool verified;
  final bool isSocialLogin;
  final List<dynamic> skills;
  final List<dynamic> educations;
  final List<dynamic> workExperiences;
  final String createdAt;
  final String updatedAt;

  User({
    this.id = "",
    this.name = "",
    this.role = "",
    this.email = "",
    this.image = "",
    this.status = "",
    this.verified = false,
    this.isSocialLogin = false,
    List<dynamic>? skills,
    List<dynamic>? educations,
    List<dynamic>? workExperiences,
    this.createdAt = "",
    this.updatedAt = "",
    this.cover = "",
    this.overview = "",
    this.aboutUs = "",
  })  : skills = skills ?? [],
        educations = educations ?? [],
        workExperiences = workExperiences ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      role: json['role'] ?? "",
      email: json['email'] ?? "",
      image: json['image'] ?? "",
      cover: json['cover'] ?? "",
      status: json['status'] ?? "",
      verified: json['verified'] ?? false,
      isSocialLogin: json['isSocialLogin'] ?? false,
      skills: json['skills'] ?? [],
      educations: json['educations'] ?? [],
      workExperiences: json['workExperiences'] ?? [],
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      overview: json['company_overview'] ?? "",
      aboutUs: json['about_us'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'email': email,
      'image': image,
      'cover': cover,
      'status': status,
      'verified': verified,
      'isSocialLogin': isSocialLogin,
      'skills': skills,
      'educations': educations,
      'workExperiences': workExperiences,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'company_overview': overview,
      'about_us': aboutUs,
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
  final GeoLocation geoLocation;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  RecentJob({
    this.id = "",
    this.thumbnail = "",
    this.recruiter = "",
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
    this.deadline = "",
    GeoLocation? geoLocation,
    this.isDeleted = false,
    this.createdAt = "",
    this.updatedAt = "",
  })  : requiredSkills = requiredSkills ?? [],
        geoLocation = geoLocation ?? GeoLocation();

  factory RecentJob.fromJson(Map<String, dynamic> json) {
    return RecentJob(
      id: json['_id'] ?? "",
      thumbnail: json['thumbnail'] ?? "",
      recruiter: json['recruiter'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      category: json['category'] ?? "",
      jobType: json['job_type'] ?? "",
      jobLevel: json['job_level'] ?? "",
      experienceLevel: json['experience_level'] ?? "",
      minSalary: json['min_salary'] ?? 0,
      maxSalary: json['max_salary'] ?? 0,
      location: json['location'] ?? "",
      requiredSkills: json['required_skills'] != null
          ? List<String>.from(json['required_skills'] as List)
          : [],
      deadline: json['deadline'] ?? "",
      geoLocation: json['gioLocation'] != null
          ? GeoLocation.fromJson(json['gioLocation'] as Map<String, dynamic>)
          : GeoLocation(),
      isDeleted: json['is_deleted'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
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
      'gioLocation': geoLocation.toJson(),
      'is_deleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String get formattedSalary {
    if (minSalary == 0 && maxSalary == 0) return 'Salary not specified';
    if (minSalary > 0 && maxSalary > 0) {
      return '\$${minSalary} - \$${maxSalary}';
    }
    if (minSalary > 0) return '\$${minSalary}+';
    if (maxSalary > 0) return '\$${maxSalary}';
    return 'Salary not specified';
  }

  String get formattedJobType {
    if (jobType.isEmpty) return '';
    return jobType.replaceAll('_', ' ').toLowerCase().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}

class GeoLocation {
  final String type;
  final List<double> coordinates;

  GeoLocation({
    this.type = "",
    List<double>? coordinates,
  }) : coordinates = coordinates ?? [];

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      type: json['type'] ?? "",
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}