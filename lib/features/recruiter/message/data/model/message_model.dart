class MessageModel {
  String id;
  String chatId;
  String sender;
  String text;
  List<String> image;
  List<String> seenBy;
  List<String> docs;
  String type; // 'text', 'image', 'doc', 'zoom-link'
  DateTime createdAt;
  DateTime updatedAt;
  bool seen;
  String? senderImage;
  String? senderName;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    required this.image,
    required this.seenBy,
    required this.docs,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.seen,
    this.senderImage,
    this.senderName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      sender: json['sender'] is String
          ? json['sender']
          : (json['sender']?['_id'] ?? ''),
      text: json['text'] ?? '',
      image: json['image'] != null
          ? List<String>.from(json['image'])
          : [],
      seenBy: json['seenBy'] != null
          ? List<String>.from(json['seenBy'])
          : [],
      docs: json['docs'] != null
          ? List<String>.from(json['docs'])
          : [],
      type: json['type'] ?? 'text',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      seen: json['seen'] ?? false,
      senderImage: json['sender'] is Map
          ? json['sender']['image']
          : null,
      senderName: json['sender'] is Map
          ? json['sender']['name']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chatId': chatId,
      'sender': sender,
      'text': text,
      'image': image,
      'seenBy': seenBy,
      'docs': docs,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'seen': seen,
    };
  }
}