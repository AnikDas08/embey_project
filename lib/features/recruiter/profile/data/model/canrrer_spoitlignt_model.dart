// career_spotlight_model.dart

class CareerSpotlightResponse {
  final bool success;
  final String message;
  final CareerSpotlightData data;
  final Pagination pagination;

  CareerSpotlightResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory CareerSpotlightResponse.fromJson(Map<dynamic, dynamic> json) {
    return CareerSpotlightResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CareerSpotlightData.fromJson(json['data'] ?? {}),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class CareerSpotlightData {
  final Stats stats;
  final List<Spotlight> spotlights;

  CareerSpotlightData({
    required this.stats,
    required this.spotlights,
  });

  factory CareerSpotlightData.fromJson(Map<String, dynamic> json) {
    return CareerSpotlightData(
      stats: Stats.fromJson(json['stats'] ?? {}),
      spotlights: (json['spotlights'] as List?)
          ?.map((e) => Spotlight.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Stats {
  final int pendingSpotlights;
  final int totalSpotlights;

  Stats({
    required this.pendingSpotlights,
    required this.totalSpotlights,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      pendingSpotlights: json['pendingSpotlights'] ?? 0,
      totalSpotlights: json['totalSpotlights'] ?? 0,
    );
  }

  int get activeSpotlights => totalSpotlights - pendingSpotlights;
}

class Spotlight {
  final String id;
  final String coverImage;
  final String organizationName;
  final String serviceType;
  final String focusArea;
  final String mode;
  final String location;
  final String pricing;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final ContactInfo contactInfo;
  final String status;
  final String user;
  final DateTime createdAt;
  final DateTime updatedAt;

  Spotlight({
    required this.id,
    required this.coverImage,
    required this.organizationName,
    required this.serviceType,
    required this.focusArea,
    required this.mode,
    required this.location,
    required this.pricing,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.contactInfo,
    required this.status,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Spotlight.fromJson(Map<String, dynamic> json) {
    return Spotlight(
      id: json['_id'] ?? '',
      coverImage: json['cover_image'] ?? '',
      organizationName: json['organization_name'] ?? '',
      serviceType: json['service_type'] ?? '',
      focusArea: json['focus_area'] ?? '',
      mode: json['mode'] ?? '',
      location: json['location'] ?? '',
      pricing: json['pricing'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      contactInfo: ContactInfo.fromJson(json['contact_info'] ?? {}),
      status: json['status'] ?? '',
      user: json['user'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  bool get isActive => status.toLowerCase() == 'approved';
  bool get isPending => status.toLowerCase() == 'pending';
}

class ContactInfo {
  final String type;
  final String details;

  ContactInfo({
    required this.type,
    required this.details,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      type: json['type'] ?? '',
      details: json['details'] ?? '',
    );
  }
}

class Pagination {
  final int total;
  final int limit;
  final int page;
  final int totalPage;
  final int cursor;

  Pagination({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
    required this.cursor,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
      cursor: json['cursor'] ?? 0,
    );
  }
}