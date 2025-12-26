// interview_details.dart

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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
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
  final String interviewStatus;
  final String? hiringStatus;
  final bool userDeleted;
  final bool recruiterDeleted;
  final bool isAutoApplied;
  final List<History> history;
  final String createdAt;
  final String updatedAt;
  final int jobMatch;
  final InterviewDetails? interviewDetails;
  final String? feedback;
  final int remainingDays;

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
    this.hiringStatus,
    required this.userDeleted,
    required this.recruiterDeleted,
    required this.isAutoApplied,
    required this.history,
    required this.createdAt,
    required this.updatedAt,
    required this.jobMatch,
    this.interviewDetails,
    this.feedback,
    required this.remainingDays,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) {
    return ApplicationData(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      post: Post.fromJson(json['post'] ?? {}),
      recruiter: Recruiter.fromJson(json['recruiter'] ?? {}),
      title: json['title'] ?? '',
      yearOfExperience: json['year_of_experience']?.toString() ?? '',
      resume: json['resume'] ?? '',
      otherDocuments: (json['other_documents'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      status: json['status'] ?? '',
      isInterviewCompleted: json['isInterviewCompleted'] ?? false,
      interviewStatus: json['inteviewStatus'] ?? '',
      hiringStatus: json['hiringStatus'],
      userDeleted: json['user_deleted'] ?? false,
      recruiterDeleted: json['reqruiter_deleted'] ?? false,
      isAutoApplied: json['isAutoApplied'] ?? false,
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => History.fromJson(e))
          .toList() ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      jobMatch: json['jobMatch'] ?? 0,
      interviewDetails: json['interviewDetails'] != null
          ? InterviewDetails.fromJson(json['interviewDetails'])
          : null,
      feedback: json['feedback'],
      remainingDays: json['remainingDays'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'post': post.toJson(),
      'recruiter': recruiter.toJson(),
      'title': title,
      'year_of_experience': yearOfExperience,
      'resume': resume,
      'other_documents': otherDocuments,
      'status': status,
      'isInterviewCompleted': isInterviewCompleted,
      'inteviewStatus': interviewStatus,
      'hiringStatus': hiringStatus,
      'user_deleted': userDeleted,
      'reqruiter_deleted': recruiterDeleted,
      'isAutoApplied': isAutoApplied,
      'history': history.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'jobMatch': jobMatch,
      'interviewDetails': interviewDetails?.toJson(),
      'feedback': feedback,
      'remainingDays': remainingDays,
    };
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'image': image,
      'bio': bio,
    };
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
      requiredSkills: (json['required_skills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      deadline: json['deadline'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'job_type': jobType,
      'job_level': jobLevel,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'location': location,
      'required_skills': requiredSkills,
      'deadline': deadline,
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'date': date,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'interview_type': interviewType,
    };
  }
}