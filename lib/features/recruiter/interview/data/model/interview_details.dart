// application_details_model.dart

class ApplicationInterview {
  final bool success;
  final String message;
  final ApplicationData data;

  ApplicationInterview({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApplicationInterview.fromJson(Map<dynamic, dynamic> json) {
    return ApplicationInterview(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ApplicationData.fromJson(json['data'] ?? {}),
    );
  }
}

class ApplicationData {
  final String id;
  final User user;
  final Post post;
  final Recruiter recruiter;
  final String title;
  final String yearOfExperience;
  final String resume;
  final List<String> otherDocuments;
  final String status;
  final bool isInterviewCompleted;
  final int jobMatch;
  final String interviewStatus;
  final String hiringStatus;
  final List<History> history;
  final String? rejectedReason;
  final InterviewDetails? interviewDetails;
  final String createdAt;
  final String updatedAt;

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
    required this.jobMatch,
    required this.interviewStatus,
    required this.hiringStatus,
    required this.history,
    this.rejectedReason,
    this.interviewDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      post: Post.fromJson(json['post'] ?? {}),
      recruiter: Recruiter.fromJson(json['recruiter'] ?? {}),
      title: json['title'] ?? '',
      yearOfExperience: json['year_of_experience'] ?? '',
      resume: json['resume'] ?? '',
      otherDocuments: List<String>.from(json['other_documents'] ?? []),
      status: json['status'] ?? '',
      isInterviewCompleted: json['isInterviewCompleted'] ?? false,
      jobMatch: json['jobMatch'] ?? 0,
      interviewStatus: json['inteviewStatus'] ?? '',
      hiringStatus: json['hiringStatus'] ?? '',
      history: (json['history'] as List?)
          ?.map((e) => History.fromJson(e))
          .toList() ??
          [],
      rejectedReason: json['rejectedReason'],
      interviewDetails: json['interviewDetails'] != null
          ? InterviewDetails.fromJson(json['interviewDetails'])
          : null,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'],
    );
  }
}

class Post {
  final String id;
  final String thumbnail;
  final String title;
  final String description;
  final String jobType;
  final String jobLevel;
  final int minSalary;
  final int maxSalary;
  final String location;
  final List<String> requiredSkills;
  final String deadline;

  Post({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.jobType,
    required this.jobLevel,
    required this.minSalary,
    required this.maxSalary,
    required this.location,
    required this.requiredSkills,
    required this.deadline,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      jobType: json['job_type'] ?? '',
      jobLevel: json['job_level'] ?? '',
      minSalary: json['min_salary'] ?? 0,
      maxSalary: json['max_salary'] ?? 0,
      location: json['location'] ?? '',
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
      deadline: json['deadline'] ?? '',
    );
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
}

class History {
  final String id;
  final String title;
  final String description;
  final String date;

  History({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
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
}