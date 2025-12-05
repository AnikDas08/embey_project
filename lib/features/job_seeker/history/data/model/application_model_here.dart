// models/application_model.dart

class ApplicationResponse {
  final bool success;
  final String message;
  final Pagination pagination;
  final List<Application> data;

  ApplicationResponse({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory ApplicationResponse.fromJson(Map<dynamic, dynamic> json) {
    return ApplicationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      data: (json['data'] as List?)
          ?.map((item) => Application.fromJson(item))
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

class Application {
  final String id;
  final User? user;
  final Post? post;
  final Recruiter? recruiter;
  final String title;
  final String yearOfExperience;
  final String resume;
  final List<String> otherDocuments;
  final String status;
  final bool isInterviewCompleted;
  final double jobMatch;
  final String interviewStatus;
  final String hiringStatus;
  final bool isAutoApplied;
  final List<History> history;
  final String createdAt;
  final String updatedAt;
  final InterviewDetails? interviewDetails;

  Application({
    required this.id,
    this.user,
    this.post,
    this.recruiter,
    required this.title,
    required this.yearOfExperience,
    required this.resume,
    required this.otherDocuments,
    required this.status,
    required this.isInterviewCompleted,
    required this.jobMatch,
    required this.interviewStatus,
    required this.hiringStatus,
    required this.isAutoApplied,
    required this.history,
    required this.createdAt,
    required this.updatedAt,
    this.interviewDetails,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['_id'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      post: json['post'] != null ? Post.fromJson(json['post']) : null,
      recruiter: json['recruiter'] != null
          ? Recruiter.fromJson(json['recruiter'])
          : null,
      title: json['title'] ?? '',
      yearOfExperience: json['year_of_experience'] ?? '',
      resume: json['resume'] ?? '',
      otherDocuments: List<String>.from(json['other_documents'] ?? []),
      status: json['status'] ?? 'PENDING',
      isInterviewCompleted: json['isInterviewCompleted'] ?? false,
      jobMatch: (json['jobMatch'] ?? 0).toDouble(),
      interviewStatus: json['inteviewStatus'] ?? 'pending',
      hiringStatus: json['hiringStatus'] ?? 'on hold',
      isAutoApplied: json['isAutoApplied'] ?? false,
      history: (json['history'] as List?)
          ?.map((item) => History.fromJson(item))
          .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      interviewDetails: json['interviewDetails'] != null
          ? InterviewDetails.fromJson(json['interviewDetails'])
          : null,
    );
  }

  // Helper method to get formatted status
  String get displayStatus {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Applied';
      case 'INTERVIEW':
        return 'Interview';
      case 'REJECTED':
        return 'Rejected';
      case 'ACCEPTED':
        return 'Accepted';
      default:
        return 'Applied';
    }
  }

  // Helper method to get interview date label
  String get interviewDateLabel {
    if (status != 'INTERVIEW') return '';

    try {
      // Use interviewDetails date if available
      if (interviewDetails != null && interviewDetails!.date.isNotEmpty) {
        DateTime interviewDate = DateTime.parse(interviewDetails!.date);
        DateTime now = DateTime.now();

        // Check if same day
        if (interviewDate.year == now.year &&
            interviewDate.month == now.month &&
            interviewDate.day == now.day) {
          return 'Today';
        }

        // Check if tomorrow
        DateTime tomorrow = now.add(const Duration(days: 1));
        if (interviewDate.year == tomorrow.year &&
            interviewDate.month == tomorrow.month &&
            interviewDate.day == tomorrow.day) {
          return 'Tomorrow';
        }

        return '${interviewDate.day} ${_getMonthName(interviewDate.month)} ${interviewDate.year % 100}';
      }

      // Fallback to createdAt
      if (createdAt.isEmpty) return 'Date not set';

      DateTime createdDate = DateTime.parse(createdAt);
      DateTime now = DateTime.now();

      if (createdDate.year == now.year &&
          createdDate.month == now.month &&
          createdDate.day == now.day) {
        return 'Today';
      }

      DateTime tomorrow = now.add(const Duration(days: 1));
      if (createdDate.year == tomorrow.year &&
          createdDate.month == tomorrow.month &&
          createdDate.day == tomorrow.day) {
        return 'Tomorrow';
      }

      return '${createdDate.day} ${_getMonthName(createdDate.month)} ${createdDate.year % 100}';
    } catch (e) {
      print('Error parsing date: $e');
      return 'Date not set';
    }
  }

  // Helper method to get formatted date and time for rejected/interview status
  String get formattedDateTime {
    try {
      // For interview, use interviewDetails if available
      if (status == 'INTERVIEW' && interviewDetails != null) {
        if (interviewDetails!.date.isNotEmpty) {
          DateTime interviewDate = DateTime.parse(interviewDetails!.date);

          String day = interviewDate.day.toString().padLeft(2, '0');
          String month = _getMonthName(interviewDate.month);
          String year = (interviewDate.year % 100).toString().padLeft(2, '0');

          // Use the time from interviewDetails if available
          String time = interviewDetails!.time.isNotEmpty
              ? interviewDetails!.time
              : '${interviewDate.hour.toString().padLeft(2, '0')}:${interviewDate.minute.toString().padLeft(2, '0')}';

          return '$day $month $year, $time';
        }
      }

      // Fallback to createdAt for rejected or if interviewDetails not available
      if (createdAt.isEmpty) return 'Date not set';

      DateTime createdDate = DateTime.parse(createdAt);

      String day = createdDate.day.toString().padLeft(2, '0');
      String month = _getMonthName(createdDate.month);
      String year = (createdDate.year % 100).toString().padLeft(2, '0');

      String hour = createdDate.hour.toString().padLeft(2, '0');
      String minute = createdDate.minute.toString().padLeft(2, '0');

      return '$day $month $year, $hour:$minute';
    } catch (e) {
      print('Error parsing date: $e');
      return 'Date not set';
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  // Check if interview is upcoming
  bool get isUpcomingInterview {
    if (status != 'INTERVIEW') return false;
    return !isInterviewCompleted;
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      bio: json['bio'],
    );
  }
}

class Post {
  final String id;
  final String? thumbnail;
  final String title;
  final String description;
  final String location;

  Post({
    required this.id,
    this.thumbnail,
    required this.title,
    required this.description,
    required this.location,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class Recruiter {
  final String id;
  final String name;
  final String email;
  final String? image;

  Recruiter({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory Recruiter.fromJson(Map<String, dynamic> json) {
    return Recruiter(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
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