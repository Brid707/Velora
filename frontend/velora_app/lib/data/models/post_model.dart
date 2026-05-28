import 'user_model.dart';

class PostModel {
  final String id;
  final UserModel user;
  final String mediaUrl;
  final String caption;

  final int likesCount;
  final int commentsCount;
  final int repostsCount;
  final int savedCount;

  final bool likedByMe;
  final bool savedByMe;
  final bool repostedByMe;

  final bool repost;
  final String? repostComment;
  final UserModel? repostedBy;

  final String createdAt;

  PostModel({
    required this.id,
    required this.user,
    required this.mediaUrl,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.repostsCount,
    required this.savedCount,
    required this.likedByMe,
    required this.savedByMe,
    required this.repostedByMe,
    required this.repost,
    required this.repostComment,
    required this.repostedBy,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      mediaUrl: json['mediaUrl'] ?? json['imageUrl'] ?? '',
      caption: json['caption'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      repostsCount: json['repostsCount'] ?? 0,
      savedCount: json['savedCount'] ?? 0,
      likedByMe: json['likedByMe'] ?? false,
      savedByMe: json['savedByMe'] ?? false,
      repostedByMe: json['repostedByMe'] ?? false,
      repost: json['repost'] ?? false,
      repostComment: json['repostComment'],
      repostedBy: json['repostedBy'] != null
          ? UserModel.fromJson(json['repostedBy'])
          : null,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
