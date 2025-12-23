class PostInsightModel {
  final bool success;
  final String message;
  final PostInsightData data;

  PostInsightModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PostInsightModel.fromJson(Map<String, dynamic> json) {
    return PostInsightModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PostInsightData.fromJson(json['data'] ?? {}),
    );
  }
}

class PostInsightData {
  final SummaryData summary;
  final List<ApplicationData> recentApplications;
  final List<ApplicationData> recentQualifiedApplications;

  PostInsightData({
    required this.summary,
    required this.recentApplications,
    required this.recentQualifiedApplications,
  });

  factory PostInsightData.fromJson(Map<String, dynamic> json) {
    return PostInsightData(
      summary: SummaryData.fromJson(json['summary'] ?? {}),
      recentApplications: (json['recentApplications'] as List<dynamic>?)
          ?.map((e) => ApplicationData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      recentQualifiedApplications:
      (json['recentQualifiedApplications'] as List<dynamic>?)
          ?.map((e) => ApplicationData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}

class SummaryData {
  final int total;
  final int qualified;
  final int rejected;
  final int engaged;

  SummaryData({
    required this.total,
    required this.qualified,
    required this.rejected,
    required this.engaged,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      total: json['total'] ?? 0,
      qualified: json['qualified'] ?? 0,
      rejected: json['rejected'] ?? 0,
      engaged: json['engaged'] ?? 0,
    );
  }
}

class ApplicationData {
  final String id;
  final UserData user;
  final String post;
  final String status;
  final int jobMatch;
  final String createdAt;

  ApplicationData({
    required this.id,
    required this.user,
    required this.post,
    required this.status,
    required this.jobMatch,
    required this.createdAt,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json['_id'] ?? '',
      user: UserData.fromJson(json['user'] ?? {}),
      post: json['post'] ?? '',
      status: json['status'] ?? '',
      jobMatch: json['jobMatch'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String image;
  final String designation;
  final String bio;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.designation,
    required this.bio,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      designation: json['designation'] ?? '',
      bio: json['bio'] ?? '',
    );
  }
}