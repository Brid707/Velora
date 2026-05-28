import 'user_model.dart';

class ReelModel {
  final String id;
  final UserModel user;
  final String videoUrl;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final bool likedByMe;
  final String createdAt;

  ReelModel({
    required this.id,
    required this.user,
    required this.videoUrl,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.likedByMe,
    required this.createdAt,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      id: json['id'].toString(),
      user: UserModel.fromJson(json['user'] ?? {}),
      videoUrl: json['videoUrl'] ?? json['mediaUrl'] ?? '',
      caption: json['caption'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      likedByMe: json['likedByMe'] ?? false,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  ReelModel copyWith({int? likesCount, int? commentsCount, bool? likedByMe}) {
    return ReelModel(
      id: id,
      user: user,
      videoUrl: videoUrl,
      caption: caption,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedByMe: likedByMe ?? this.likedByMe,
      createdAt: createdAt,
    );
  }
}
