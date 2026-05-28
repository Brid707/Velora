import 'dart:typed_data';

class RegisterDraftModel {
  final String email;
  final String password;
  final String fullName;
  final String username;
  final String birthdate;
  final Uint8List? profileImageBytes;
  final String? profileImageName;

  const RegisterDraftModel({
    required this.email,
    required this.password,
    required this.fullName,
    required this.username,
    required this.birthdate,
    this.profileImageBytes,
    this.profileImageName,
  });

  RegisterDraftModel copyWith({
    String? email,
    String? password,
    String? fullName,
    String? username,
    String? birthdate,
    Uint8List? profileImageBytes,
    String? profileImageName,
  }) {
    return RegisterDraftModel(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      birthdate: birthdate ?? this.birthdate,
      profileImageBytes: profileImageBytes ?? this.profileImageBytes,
      profileImageName: profileImageName ?? this.profileImageName,
    );
  }
}
