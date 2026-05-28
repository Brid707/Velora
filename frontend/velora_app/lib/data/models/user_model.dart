class UserModel {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String bio;
  final String profileImageUrl;
  final int followersCount;
  final int followingCount;
  final int postsCount;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.bio,
    required this.profileImageUrl,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      postsCount: json['postsCount'] ?? 0,
    );
  }

  UserModel copyWith({
    int? followersCount,
    int? followingCount,
    int? postsCount,
  }) {
    return UserModel(
      id: id,
      username: username,
      email: email,
      fullName: fullName,
      bio: bio,
      profileImageUrl: profileImageUrl,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
    );
  }
}
