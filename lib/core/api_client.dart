import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/core/storage_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? _token;

  Future<String?> getToken() async {
    _token ??= await StorageService.getString(StorageKeys.token);
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    await StorageService.setString(StorageKeys.token, token);
  }

  Future<void> clearToken() async {
    _token = null;
    await StorageService.remove(StorageKeys.token);
  }

  Map<String, String> _getHeaders({bool requireAuth = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requireAuth = false,
  }) async {
    if (requireAuth) {
      await getToken();
    }

    var uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(
      uri,
      headers: _getHeaders(requireAuth: requireAuth),
    );

    return response;
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    if (requireAuth) {
      await getToken();
    }

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: _getHeaders(requireAuth: requireAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    if (requireAuth) {
      await getToken();
    }

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: _getHeaders(requireAuth: requireAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  Future<http.Response> delete(
    String endpoint, {
    bool requireAuth = false,
  }) async {
    if (requireAuth) {
      await getToken();
    }

    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      headers: _getHeaders(requireAuth: requireAuth),
    );

    return response;
  }

  Map<String, dynamic>? parseResponse(http.Response response) {
    try {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  List<dynamic>? parseListResponse(http.Response response) {
    try {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body) as List<dynamic>?;
    } catch (e) {
      return null;
    }
  }
}

