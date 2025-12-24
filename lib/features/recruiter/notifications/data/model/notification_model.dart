class NotificationModel {
  String? id;
  String? title;
  List<String>? receiver;
  String? message;
  String? filePath;
  bool? isRead;
  String? referenceId;
  List<String>? readers;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  NotificationModel({
    this.id,
    this.title,
    this.receiver,
    this.message,
    this.filePath,
    this.isRead,
    this.referenceId,
    this.readers,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      receiver: json['receiver'] != null
          ? List<String>.from(json['receiver'])
          : null,
      message: json['message'],
      filePath: json['filePath'],
      isRead: json['isRead'],
      referenceId: json['referenceId'],
      readers: json['readers'] != null
          ? List<String>.from(json['readers'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'receiver': receiver,
      'message': message,
      'filePath': filePath,
      'isRead': isRead,
      'referenceId': referenceId,
      'readers': readers,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class NotificationResponse {
  bool? success;
  String? message;
  PaginationData? pagination;
  NotificationData? data;

  NotificationResponse({
    this.success,
    this.message,
    this.pagination,
    this.data,
  });

  factory NotificationResponse.fromJson(Map<dynamic, dynamic> json) {
    return NotificationResponse(
      success: json['success'],
      message: json['message'],
      pagination: json['pagination'] != null
          ? PaginationData.fromJson(json['pagination'])
          : null,
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'])
          : null,
    );
  }
}

class PaginationData {
  int? total;
  int? limit;
  int? page;
  int? totalPage;
  int? cursor;

  PaginationData({
    this.total,
    this.limit,
    this.page,
    this.totalPage,
    this.cursor,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      total: json['total'],
      limit: json['limit'],
      page: json['page'],
      totalPage: json['totalPage'],
      cursor: json['cursor'],
    );
  }
}

class NotificationData {
  int? unreadCount;
  List<NotificationModel>? data;

  NotificationData({
    this.unreadCount,
    this.data,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      unreadCount: json['unreadCount'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList()
          : null,
    );
  }
}