import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';
import '../../auth/domain/auth_session.dart';

/// Service to interact with the Spring Boot Circles API (/api/circles/me).
class CircleApiService {
  final http.Client _client;

  CircleApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Retrieve joined circle names for the authenticated user from Spring Boot / PostgreSQL.
  Future<List<String>?> getJoinedCircles({String? token}) async {
    final authToken = token ?? AuthSession.instance.token;
    if (authToken == null || authToken.isEmpty) {
      return null;
    }

    try {
      final response = await _client.get(
        ApiConfig.circlesMeUri,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final rawCircles = data['circles'] as List<dynamic>?;
        return rawCircles?.map((item) => item.toString()).toList() ?? <String>[];
      }

      return null;
    } on SocketException {
      return null;
    } on TimeoutException {
      return null;
    } on http.ClientException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Update the joined circle names for the authenticated user in Spring Boot / PostgreSQL.
  Future<List<String>?> updateJoinedCircles(
    List<String> circles, {
    String? token,
  }) async {
    final authToken = token ?? AuthSession.instance.token;
    if (authToken == null || authToken.isEmpty) {
      return null;
    }

    try {
      final response = await _client.put(
        ApiConfig.circlesMeUri,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'circles': circles}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final rawCircles = data['circles'] as List<dynamic>?;
        return rawCircles?.map((item) => item.toString()).toList() ?? <String>[];
      }

      return null;
    } on SocketException {
      return null;
    } on TimeoutException {
      return null;
    } on http.ClientException {
      return null;
    } catch (_) {
      return null;
    }
  }
}
