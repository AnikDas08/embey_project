import 'package:get/get.dart';

class RecruiterProfileModel {
  final bool success;
  final String message;
  final RecruiterProfileData data;

  RecruiterProfileModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RecruiterProfileModel.fromJson(Map<dynamic, dynamic> json) {
    return RecruiterProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RecruiterProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class RecruiterProfileData {
  final List<dynamic> adminAccess;
  final bool isAutoApply;
  final String id;
  final String name;
  final String role;
  final String email;
  final String image;
  final String coverPhoto;
  final String status;
  final bool verified;
  final bool isSocialLogin;
  final List<dynamic> skills;
  final List<dynamic> educations;
  final List<dynamic> workExperiences;
  final String createdAt;
  final String updatedAt;
  final String bio;
  final String companyOverview;
  final String aboutUs;
  final ContactInfo? contactInfo;
  final String mission;
  final CompanyOverview? overview;
  final String subscription;
  final OverviewSummary? overviewSummary;

  RecruiterProfileData({
    required this.adminAccess,
    required this.isAutoApply,
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.image,
    required this.coverPhoto,
    required this.status,
    required this.verified,
    required this.isSocialLogin,
    required this.skills,
    required this.educations,
    required this.workExperiences,
    required this.createdAt,
    required this.updatedAt,
    required this.bio,
    required this.companyOverview,
    required this.aboutUs,
    this.contactInfo,
    required this.mission,
    this.overview,
    required this.subscription,
    this.overviewSummary,
  });

  // Helper getter for address
  String get address => contactInfo?.address ?? '';

  factory RecruiterProfileData.fromJson(Map<String, dynamic> json) {
    return RecruiterProfileData(
      adminAccess: json['adminaccess'] ?? [],
      isAutoApply: json['isAutoApply'] ?? false,
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      coverPhoto: json['cover'] ?? '',
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
      isSocialLogin: json['isSocialLogin'] ?? false,
      skills: json['skills'] ?? [],
      educations: json['educations'] ?? [],
      workExperiences: json['workExperiences'] ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      bio: json['bio'] ?? '',
      companyOverview: json['company_overview'] ?? '',
      aboutUs: json['about_us'] ?? '',
      contactInfo: json['contactInfo'] != null
          ? ContactInfo.fromJson(json['contactInfo'])
          : null,
      mission: json['mission'] ?? '',
      overview: json['overview'] != null
          ? CompanyOverview.fromJson(json['overview'])
          : null,
      subscription: json['subscription'] ?? '',
      overviewSummary: json['overviewSummury'] != null
          ? OverviewSummary.fromJson(json['overviewSummury'])
          : null,
    );
  }
}

class ContactInfo {
  final String id;
  final String website;
  final String address;
  final String contact;
  final String email;

  ContactInfo({
    required this.id,
    required this.website,
    required this.address,
    required this.contact,
    required this.email,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      id: json['_id'] ?? '',
      website: json['website'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class CompanyOverview {
  final String id;
  final int totalEmployees;
  final String companyType;
  final int founded;
  final String revenue;

  CompanyOverview({
    required this.id,
    required this.totalEmployees,
    required this.companyType,
    required this.founded,
    required this.revenue,
  });

  factory CompanyOverview.fromJson(Map<String, dynamic> json) {
    return CompanyOverview(
      id: json['_id'] ?? '',
      totalEmployees: json['total_employees'] ?? 0,
      companyType: json['company_type'] ?? '',
      founded: json['founded'] ?? 0,
      revenue: json['revenue'] ?? '',
    );
  }
}

class OverviewSummary {
  final int activePosts;
  final int pendingRequest;
  final int shortlistRequest;
  final int interviewRequest;

  OverviewSummary({
    required this.activePosts,
    required this.pendingRequest,
    required this.shortlistRequest,
    required this.interviewRequest,
  });

  factory OverviewSummary.fromJson(Map<String, dynamic> json) {
    return OverviewSummary(
      activePosts: json['activePosts'] ?? 0,
      pendingRequest: json['pendingRequest'] ?? 0,
      shortlistRequest: json['shortlistRequest'] ?? 0,
      interviewRequest: json['interviewRequest'] ?? 0,
    );
  }
}