class ResumeResponse {
  final bool success;
  final String message;
  final Pagination pagination;
  final List<Resume> data;

  ResumeResponse({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory ResumeResponse.fromJson(Map<dynamic, dynamic> json) {
    return ResumeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List?)
          ?.map((e) => Resume.fromJson(e))
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

class Resume {
  final String id;
  final String resumeName;
  final String user;
  final PersonalInfo personalInfo;
  final List<Education> educations;
  final List<WorkExperience> workExperiences;
  final List<String> skills;
  final List<CoreFeature> coreFeatures;
  final List<Certification> certifications;
  final List<Project> projects;

  Resume({
    required this.id,
    required this.resumeName,
    required this.user,
    required this.personalInfo,
    required this.educations,
    required this.workExperiences,
    required this.skills,
    required this.coreFeatures,
    required this.certifications,
    required this.projects,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['_id'] ?? '',
      resumeName: json['resume_name'] ?? '',
      user: json['user'] ?? '',
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] ?? {}),
      educations: (json['educations'] as List?)
          ?.map((e) => Education.fromJson(e))
          .toList() ??
          [],
      workExperiences: (json['workExperiences'] as List?)
          ?.map((e) => WorkExperience.fromJson(e))
          .toList() ??
          [],
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? [],
      coreFeatures: (json['core_features'] as List?)
          ?.map((e) => CoreFeature.fromJson(e))
          .toList() ??
          [],
      certifications: (json['certifications'] as List?)
          ?.map((e) => Certification.fromJson(e))
          .toList() ??
          [],
      projects: (json['projects'] as List?)
          ?.map((e) => Project.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class PersonalInfo {
  final String fullName;
  final String email;
  final String phone;
  final String socialMediaLink;
  final String githubLink;
  final String workAuthorization;
  final String clearance;
  final String openToWork;
  final String summary;
  final String address;

  PersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.socialMediaLink,
    required this.githubLink,
    required this.workAuthorization,
    required this.clearance,
    required this.openToWork,
    required this.summary,
    required this.address,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      socialMediaLink: json['social_media_link'] ?? '',
      githubLink: json['github_link'] ?? '',
      workAuthorization: json['work_authorization'] ?? '',
      clearance: json['clearance'] ?? '',
      openToWork: json['open_to_work'] ?? '',
      summary: json['summury'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class Education {
  final String id;
  final String degree;
  final String institution;
  final String? startDate;
  final String? endDate;
  final String? grade;
  final int? passingYear;

  Education({
    required this.id,
    required this.degree,
    required this.institution,
    this.startDate,
    this.endDate,
    this.grade,
    this.passingYear,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['_id'] ?? '',
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      startDate: json['startDate'],
      endDate: json['endDate'],
      grade: json['grade'],
      passingYear: json['passingYear'],
    );
  }
}

class WorkExperience {
  final String id;
  final String title;
  final String company;
  final String startDate;
  final String endDate;
  final String description;
  final String? location;
  final bool? isCurrentJob;
  final String designation;

  WorkExperience({
    required this.id,
    required this.title,
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.location,
    this.isCurrentJob,
    required this.designation,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      description: json['description'] ?? '',
      location: json['location'],
      isCurrentJob: json['isCurrentJob'],
      designation: json['designation'] ?? '',
    );
  }
}

class CoreFeature {
  final String id;
  final String title;
  final String description;

  CoreFeature({
    required this.id,
    required this.title,
    required this.description,
  });

  factory CoreFeature.fromJson(Map<String, dynamic> json) {
    return CoreFeature(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Certification {
  final String id;
  final String title;
  final String description;
  final String? link;

  Certification({
    required this.id,
    required this.title,
    required this.description,
    this.link,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'],
    );
  }
}

class Project {
  final String id;
  final String title;
  final String description;
  final String? link;

  Project({
    required this.id,
    required this.title,
    required this.description,
    this.link,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'],
    );
  }
}