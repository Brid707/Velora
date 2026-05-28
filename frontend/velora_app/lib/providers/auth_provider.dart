import 'package:flutter/material.dart';

import '../core/services/api_service.dart';
import '../core/services/session_service.dart';

class AuthProvider extends ChangeNotifier {
  bool loading = false;
  bool checkingSession = true;

  String? token;
  String? userId;
  String? username;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  Future<void> loadSession() async {
    token = await SessionService.getToken();
    userId = await SessionService.getUserId();
    username = await SessionService.getUsername();

    checkingSession = false;
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.post('auth/login', {
        'email': email,
        'password': password,
      });

      final data = response['data'];
      final authData = data['data'] ?? data;
      final user = authData['user'];

      token = authData['token'].toString();
      userId = user['id'].toString();
      username = user['username'].toString();

      await SessionService.saveSession(
        token: token!,
        userId: userId!,
        username: username!,
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      loading = true;
      notifyListeners();

      final response = await ApiService.post('auth/register', {
        'fullName': fullName,
        'username': username,
        'email': email,
        'password': password,
      });

      final data = response['data'];
      final authData = data['data'] ?? data;
      final user = authData['user'];

      token = authData['token'].toString();
      userId = user['id'].toString();
      this.username = user['username'].toString();

      await SessionService.saveSession(
        token: token!,
        userId: userId!,
        username: this.username!,
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    token = null;
    userId = null;
    username = null;

    await SessionService.clearSession();
    notifyListeners();
  }
}
