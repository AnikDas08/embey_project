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

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      recruiter: Recruiter.fromJson(json['recruiter'] ?? {}),
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
          ?.map((e) => e.toString())
          .toList() ??
          [],
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now(),
      isDeleted: json['is_deleted'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
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
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory Recruiter.fromJson(Map<String, dynamic> json) {
    return Recruiter(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
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