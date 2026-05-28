import 'user_model.dart';

class MessageModel {
  final String id;
  final UserModel sender;
  final UserModel receiver;
  final String content;
  final String createdAt;

  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'].toString(),
      sender: UserModel.fromJson(json['sender'] ?? {}),
      receiver: UserModel.fromJson(json['receiver'] ?? {}),
      content: json['content'] ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
