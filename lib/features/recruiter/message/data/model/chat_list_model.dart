class ChatResponseModel {
  final bool success;
  final String message;
  final List<ChatModel> data;

  ChatResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ChatModel.fromJson(e))
          .toList(),
    );
  }
}

class ChatModel {
  final String id;
  final Participant participant;
  final bool status;
  final LastMessage? lastMessage;

  ChatModel({
    required this.id,
    required this.participant,
    required this.status,
    this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      participant: Participant.fromJson(json['participants'] ?? {}),
      status: json['status'] ?? false,
      lastMessage: (json['lastMessage'] != null && json['lastMessage'] != "")
          ? LastMessage.fromJson(json['lastMessage'])
          : LastMessage(id: '', sender: '', text: '', createdAt: DateTime.now()),
    );
  }
}

class Participant {
  final String id;
  final String name;
  final String image;

  Participant({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
class LastMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime createdAt;

  LastMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}


