class VeloraUserModel {
  final int id;
  final String fullName;
  final String username;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int following;
  final int posts;

  const VeloraUserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.avatarUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
  });
}
