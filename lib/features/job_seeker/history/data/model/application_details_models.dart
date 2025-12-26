// controllers/applied_details_controller.dart

import 'package:embeyi/core/services/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationDetail {
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
  final String hiringStatus;
  final List<History> history;
  final String? rejectionReason;
  final DateTime createdAt;

  ApplicationDetail({
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
    required this.history,
    this.rejectionReason,
    required this.createdAt,
  });

  factory ApplicationDetail.fromJson(Map<String, dynamic> json) {
    return ApplicationDetail(
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
      interviewStatus: json['inteviewStatus'] ?? '',
      hiringStatus: json['hiringStatus'] ?? '',
      history: (json['history'] as List?)
          ?.map((h) => History.fromJson(h))
          .toList() ?? [],
      rejectionReason: json['rejectedReason'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String image;
  final String bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      bio: json['bio'] ?? '',
    );
  }
}

class Post {
  final String id;
  final String thumbnail;
  final String title;
  final String description;
  final String location;

  Post({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.location,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
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
  final DateTime date;

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
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}