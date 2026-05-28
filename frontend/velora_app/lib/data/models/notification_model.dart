class NotificationModel {
  final String id;
  final String type;
  final String message;
  final bool read;
  final String senderUsername;
  final String senderProfileImage;
  final String? postId;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.read,
    required this.senderUsername,
    required this.senderProfileImage,
    required this.postId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      read: json['read'] ?? false,
      senderUsername: json['senderUsername']?.toString() ?? '',
      senderProfileImage: json['senderProfileImage']?.toString() ?? '',
      postId: json['postId']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
