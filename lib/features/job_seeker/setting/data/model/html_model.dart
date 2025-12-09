class HtmlModel {
  final bool success;
  final String message;
  final HtmlData data;

  HtmlModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HtmlModel.fromJson(Map<dynamic, dynamic> json) {
    return HtmlModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: HtmlData.fromJson(json['data'] ?? {}),
    );
  }
}

class HtmlData {
  final String id;
  final String content;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  HtmlData({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HtmlData.fromJson(Map<String, dynamic> json) {
    return HtmlData(
      id: json['_id'] ?? '',
      content: json['content'] ?? 'No Data Found',
      type: json['type'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
