import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:training_request/api/api_constants.dart';
import 'package:training_request/api/api_exception.dart';
import 'package:training_request/services/local/storage.dart';
import 'base_api_client.dart';

class ApiClientImpl implements BaseApiClient {
  final http.Client _client;

  ApiClientImpl(this._client);

  @override
  Future<dynamic> get(String endpoint) async {
    final token = await LocalStorage.getString(LocalStorage.AcessToken);
    final uri = Uri.parse(endpoint);

    log("➡️ [GET] $uri");
    final response = await _client.get(uri, headers: _headers(token ?? ''));
    log("⬅️ [GET] ${response.statusCode} ${response.body}");

    return _handleResponse(response);
  }

  @override
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final token =
        auth ? await LocalStorage.getString(LocalStorage.AcessToken) : null;
    final uri = Uri.parse(endpoint);

    log("➡️ [POST] $uri");
    log("📦 [POST] Body: ${jsonEncode(body)}");

    final response = await _client.post(
      uri,
      headers: _headers(token ?? ''),
      body: jsonEncode(body),
    );

    log("⬅️ [POST] ${response.statusCode} ${response.body}");
    return _handleResponse(response);
  }

  @override
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    final token =
        auth ? await LocalStorage.getString(LocalStorage.AcessToken) : null;
    final uri = Uri.parse(endpoint);

    log("➡️ [PUT] $uri");
    final response = await _client.put(
      uri,
      headers: _headers(token ?? ''),
      body: jsonEncode(body),
    );

    log("⬅️ [PUT] ${response.statusCode} ${response.body}");
    return _handleResponse(response);
  }

  @override
  Future<dynamic> delete(String endpoint, {bool auth = true}) async {
    final token =
        auth ? await LocalStorage.getString(LocalStorage.AcessToken) : null;
    final uri = Uri.parse(ApiConstants.BASEURL + endpoint);

    log("➡️ [DELETE] $uri");
    final response = await _client.delete(uri, headers: _headers(token ?? ''));

    log("⬅️ [DELETE] ${response.statusCode} ${response.body}");
    return _handleResponse(response);
  }

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _handleResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      throw ApiException('Invalid JSON: ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;
      case 400:
        throw BadExceptionRequest(body['message'] ?? 'Bad Request');
      case 401:
        throw UnauthorizedException();
      case 403:
        throw ApiException('Forbidden');
      case 404:
        throw NotFoundException();
      case 500:
        throw InternalServerException();
      default:
        throw ApiException('Unexpected error: ${response.statusCode}');
    }
  }
}
