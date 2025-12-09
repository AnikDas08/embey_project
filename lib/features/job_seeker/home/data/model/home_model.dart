class ProfileModel {
  final bool? success;
  final String? message;
  final UserData? data;

  ProfileModel({
    this.success,
    this.message,
    this.data,
  });

  factory ProfileModel.fromJson(Map<dynamic, dynamic> json) {
    return ProfileModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final List<dynamic>? adminaccess;
  final String? id;
  final String? name;
  final String? role;
  final String? email;
  final String? image;
  final String? status;
  final bool? verified;
  final bool? isSocialLogin;
  final List<String>? skills;
  final List<dynamic>? educations;
  final List<dynamic>? workExperiences;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? address;
  final String? dateOfBirth;
  final String? designation;
  final String? gender;
  final String? language;
  final String? linkedin;
  final String? nationality;
  final String? phone;
  final String? subscription;
  final String? bio;
  final String? resume;

  UserData({
    this.adminaccess,
    this.id,
    this.name,
    this.role,
    this.email,
    this.image,
    this.status,
    this.verified,
    this.isSocialLogin,
    this.skills,
    this.educations,
    this.workExperiences,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.address,
    this.dateOfBirth,
    this.designation,
    this.gender,
    this.language,
    this.linkedin,
    this.nationality,
    this.phone,
    this.subscription,
    this.bio,
    this.resume,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      adminaccess: json['adminaccess'],
      id: json['_id'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
      image: json['image'],
      status: json['status'],
      verified: json['verified'],
      isSocialLogin: json['isSocialLogin'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      educations: json['educations'],
      workExperiences: json['workExperiences'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'],
      designation: json['designation'],
      gender: json['gender'],
      language: json['language'],
      linkedin: json['linkedin'],
      nationality: json['nationality'],
      phone: json['phone'],
      subscription: json['subscription'],
      bio: json['bio'],
      resume: json['resume'],
    );
  }
}
class Education {
  final String? degree;
  final String? institute;
  final String? session;
  final dynamic passingYear; // Can be int or String
  final String? grade;
  final String? id;

  Education({
    this.degree,
    this.institute,
    this.session,
    this.passingYear,
    this.grade,
    this.id,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'],
      institute: json['institute'],
      session: json['session'],
      passingYear: json['passingYear'],
      grade: json['grade'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institute': institute,
      'session': session,
      'passingYear': passingYear,
      'grade': grade,
      '_id': id,
    };
  }
}
