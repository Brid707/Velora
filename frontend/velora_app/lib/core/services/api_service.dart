import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'session_service.dart';

class ApiService {
  ApiService._();

  static const String baseUrl = 'http://localhost:8080/api';

  static Future<Map<String, String>> _headers({bool isJson = true}) async {
    final token = await SessionService.getToken();

    return {
      if (isJson) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  static Future<dynamic> postMultipart(
    String endpoint,
    String filePath,
    String fieldName, {
    Map<String, String>? fields,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$endpoint'),
    );

    request.headers.addAll(await _headers(isJson: false));
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    if (fields != null) request.fields.addAll(fields);

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    return _handleResponse(response);
  }

  static Future<dynamic> postMultipartBytes(
    String endpoint,
    Uint8List bytes,
    String filename,
    String fieldName, {
    Map<String, String>? fields,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/$endpoint'),
    );

    request.headers.addAll(await _headers(isJson: false));

    request.files.add(
      http.MultipartFile.fromBytes(fieldName, bytes, filename: filename),
    );

    if (fields != null) request.fields.addAll(fields);

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw Exception(
      decoded is Map && decoded['message'] != null
          ? decoded['message']
          : 'Error ${response.statusCode}',
    );
  }
}
