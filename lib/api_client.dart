import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  Map<String, String> _headers({bool withAuth = true}) {
    final h = {'Content-Type': 'application/json'};
    final token = ApiConfig.instance.token;
    if (withAuth && token != null) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  Uri _uri(String path) =>
      Uri.parse('${ApiConfig.instance.baseUrl}$path');

  Future<dynamic> get(String path, {bool withAuth = true}) async {
    final res = await http.get(_uri(path), headers: _headers(withAuth: withAuth));
    return _handle(res);
  }

  Future<dynamic> post(String path, {Object? body, bool withAuth = true}) async {
    final res = await http.post(_uri(path),
        headers: _headers(withAuth: withAuth),
        body: body == null ? null : jsonEncode(body));
    return _handle(res);
  }

  Future<dynamic> put(String path, {Object? body}) async {
    final res = await http.put(_uri(path),
        headers: _headers(), body: body == null ? null : jsonEncode(body));
    return _handle(res);
  }

  Future<dynamic> delete(String path) async {
    final res = await http.delete(_uri(path), headers: _headers());
    return _handle(res);
  }

  dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    String msg = 'خطای سرور (${res.statusCode})';
    try {
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (body is Map && body['message'] != null) {
        msg = body['message'].toString();
      }
    } catch (_) {}
    throw ApiException(res.statusCode, msg);
  }
}