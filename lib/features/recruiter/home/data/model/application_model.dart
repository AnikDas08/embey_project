class ApplicationListModel {
  final bool success;
  final String message;
  final PaginationData pagination;
  final List<ApplicationData> data;

  ApplicationListModel({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory ApplicationListModel.fromJson(Map<dynamic, dynamic> json) {
    return ApplicationListModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: PaginationData.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List?)
          ?.map((item) => ApplicationData.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class PaginationData {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  PaginationData({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
    );
  }
}

class ApplicationData {
  final String id;
  final ApplicationUser user;
  final ApplicationPost post;
  final ApplicationRecruiter recruiter;
  final String title;
  final String yearOfExperience;
  final String resume;
  final List<String> otherDocuments;
  final String status;
  final bool isInterviewCompleted;
  final String interviewStatus;
  final String hiringStatus;
  final bool userDeleted;
  final bool recruiterDeleted;
  final bool isAutoApplied;
  final List<ApplicationHistory> history;
  final InterviewDetails interviewDetails;
  final String createdAt;
  final String updatedAt;
  final int jobMatch;
  final String feedback;
  final String interviewCancelledReason;

  ApplicationData({
    required this.id,
    required this.user,
    required this.post,
    required this.recruiter,
    required this.title,
    required this.yearOfExperience,
    required this.resume,
    required this.otherDocuments,
    required this.status,
    required this.isInterviewCompleted,
    required this.interviewStatus,
    required this.hiringStatus,
    required this.userDeleted,
    required this.recruiterDeleted,
    required this.isAutoApplied,
    required this.history,
    required this.interviewDetails,
    required this.createdAt,
    required this.updatedAt,
    required this.jobMatch,
    required this.feedback,
    required this.interviewCancelledReason,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json['_id'] ?? '',
      user: ApplicationUser.fromJson(json['user'] ?? {}),
      post: ApplicationPost.fromJson(json['post'] ?? {}),
      recruiter: ApplicationRecruiter.fromJson(json['recruiter'] ?? {}),
      title: json['title'] ?? '',
      yearOfExperience: json['year_of_experience'] ?? '',
      resume: json['resume'] ?? '',
      otherDocuments: (json['other_documents'] as List?)
          ?.map((doc) => doc.toString())
          .toList() ??
          [],
      status: json['status'] ?? '',
      isInterviewCompleted: json['isInterviewCompleted'] ?? false,
      interviewStatus: json['inteviewStatus'] ?? '',
      hiringStatus: json['hiringStatus'] ?? '',
      userDeleted: json['user_deleted'] ?? false,
      recruiterDeleted: json['reqruiter_deleted'] ?? false,
      isAutoApplied: json['isAutoApplied'] ?? false,
      history: (json['history'] as List?)
          ?.map((item) => ApplicationHistory.fromJson(item))
          .toList() ??
          [],
      interviewDetails:
      InterviewDetails.fromJson(json['interviewDetails'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      jobMatch: json['jobMatch'] ?? 0,
      feedback: json['feedback'] ?? '',
      interviewCancelledReason: json['interviewCancelledReason'] ?? '',
    );
  }

  // Helper getters
  String get experienceYears => '$yearOfExperience Years Experience';

  String get displayStatus {
    switch (status.toUpperCase()) {
      case 'SHORTLISTED':
        return 'Shortlisted';
      case 'PENDING':
        return 'Pending';
      case 'REJECTED':
        return 'Rejected';
      case 'INTERVIEW':
        return 'Interview';
      default:
        return status;
    }
  }

  bool get isShortlisted => status.toUpperCase() == 'SHORTLISTED';
  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isRejected => status.toUpperCase() == 'REJECTED';
}

class ApplicationUser {
  final String id;
  final String name;
  final String email;
  final String image;
  final String bio;

  ApplicationUser({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.bio,
  });

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    return ApplicationUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
    );
  }
}

class ApplicationPost {
  final String id;
  final String thumbnail;
  final String title;
  final String description;
  final String location;

  ApplicationPost({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.location,
  });

  factory ApplicationPost.fromJson(Map<String, dynamic> json) {
    return ApplicationPost(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class ApplicationRecruiter {
  final String id;
  final String name;
  final String email;
  final String image;

  ApplicationRecruiter({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory ApplicationRecruiter.fromJson(Map<String, dynamic> json) {
    return ApplicationRecruiter(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ApplicationHistory {
  final String id;
  final String title;
  final String description;
  final String date;

  ApplicationHistory({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory ApplicationHistory.fromJson(Map<String, dynamic> json) {
    return ApplicationHistory(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class InterviewDetails {
  final String date;
  final String time;
  final String interviewType;

  InterviewDetails({
    required this.date,
    required this.time,
    required this.interviewType,
  });

  factory InterviewDetails.fromJson(Map<String, dynamic> json) {
    return InterviewDetails(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      interviewType: json['interview_type'] ?? '',
    );
  }

  bool get isRemote => interviewType.toLowerCase() == 'remote';
  bool get isOnsite => interviewType.toLowerCase() == 'onsite';
}