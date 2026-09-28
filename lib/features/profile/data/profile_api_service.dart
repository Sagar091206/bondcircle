import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';
import '../../auth/domain/auth_session.dart';

/// Data model representing the Profile Setup categories:
/// Gender, Orientation, Connection Intention, Relationship Style, Interests,
/// Age, City, Bio, Dating Preferences, Children Plan, and Lifestyle.
class ProfileData {
  final String gender;
  final String orientation;
  final String connectionIntention;
  final String relationshipStyle;
  final List<String> interests;
  final int? age;
  final String city;
  final String bio;
  final List<String> datingPreferences;
  final String childrenPlan;
  final String religion;
  final String politics;
  final String drinking;
  final String smoking;

  const ProfileData({
    required this.gender,
    required this.orientation,
    required this.connectionIntention,
    required this.relationshipStyle,
    required this.interests,
    this.age,
    this.city = '',
    this.bio = '',
    this.datingPreferences = const <String>[],
    this.childrenPlan = '',
    this.religion = '',
    this.politics = '',
    this.drinking = '',
    this.smoking = '',
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      gender: json['gender'] as String? ?? '',
      orientation: json['orientation'] as String? ?? '',
      connectionIntention: json['connectionIntention'] as String? ?? '',
      relationshipStyle: json['relationshipStyle'] as String? ?? '',
      interests: (json['interests'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          <String>[],
      age: json['age'] as int?,
      city: json['city'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      datingPreferences: (json['datingPreferences'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          <String>[],
      childrenPlan: json['childrenPlan'] as String? ?? '',
      religion: json['religion'] as String? ?? '',
      politics: json['politics'] as String? ?? '',
      drinking: json['drinking'] as String? ?? '',
      smoking: json['smoking'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'gender': gender,
      'orientation': orientation,
      'connectionIntention': connectionIntention,
      'relationshipStyle': relationshipStyle,
      'interests': interests,
      'city': city,
      'bio': bio,
      'datingPreferences': datingPreferences,
      'childrenPlan': childrenPlan,
      'religion': religion,
      'politics': politics,
      'drinking': drinking,
      'smoking': smoking,
    };
    if (age != null) {
      map['age'] = age;
    }
    return map;
  }

  @override
  String toString() =>
      'ProfileData(gender: $gender, orientation: $orientation, connectionIntention: $connectionIntention, relationshipStyle: $relationshipStyle, interests: $interests, age: $age, city: $city, bio: $bio, datingPreferences: $datingPreferences, childrenPlan: $childrenPlan, religion: $religion, politics: $politics, drinking: $drinking, smoking: $smoking)';
}

/// Service to interact with the Spring Boot Profile API (/api/profile/me).
class ProfileApiService {
  final http.Client _client;

  ProfileApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Retrieve saved profile data for the authenticated user from Spring Boot / PostgreSQL.
  Future<ProfileData?> getProfile({String? token}) async {
    final authToken = token ?? AuthSession.instance.token;
    if (authToken == null || authToken.isEmpty) {
      return null;
    }

    try {
      final response = await _client.get(
        ApiConfig.profileMeUri,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ProfileData.fromJson(data);
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

  /// Save or update the 5 profile categories to Spring Boot / PostgreSQL for the authenticated user.
  Future<ProfileData?> saveProfile(
    ProfileData profile, {
    String? token,
  }) async {
    final authToken = token ?? AuthSession.instance.token;
    if (authToken == null || authToken.isEmpty) {
      return null;
    }

    try {
      final response = await _client.put(
        ApiConfig.profileMeUri,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profile.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ProfileData.fromJson(data);
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
