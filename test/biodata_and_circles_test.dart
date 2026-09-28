import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:bondcircle/core/config/api_config.dart';
import 'package:bondcircle/features/auth/domain/auth_session.dart';
import 'package:bondcircle/features/auth/domain/auth_user.dart';
import 'package:bondcircle/features/circles/data/circle_api_service.dart';
import 'package:bondcircle/features/circles/presentation/interest_circles_screen.dart';
import 'package:bondcircle/features/profile/data/profile_api_service.dart';
import 'package:bondcircle/features/profile/presentation/profile_setup_screen.dart';

void main() {
  setUp(() {
    AuthSession.instance.clearSession();
    ApiConfig.reset();
  });

  tearDown(() {
    AuthSession.instance.clearSession();
    ApiConfig.reset();
  });

  group('Full Biodata and CircleApiService unit tests', () {
    test('ProfileApiService sends and receives all biodata and lifestyle fields', () async {
      late http.Request capturedRequest;
      final mockClient = MockClient((request) async {
        if (request.url.path == '/api/profile/me' && request.method == 'PUT') {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'id': 1,
              'gender': 'Woman',
              'orientation': 'Queer',
              'connectionIntention': 'Long-term relationship',
              'relationshipStyle': 'Monogamy',
              'interests': ['Coffee', 'Books', 'Fitness'],
              'age': 25,
              'city': 'Kolkata',
              'bio': 'Lover of art, coffee, and weekend trail walks.',
              'datingPreferences': ['Men', 'Nonbinary people'],
              'childrenPlan': 'Want children',
              'religion': 'Spiritual',
              'politics': 'Moderate',
              'drinking': 'Socially',
              'smoking': 'Never',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = ProfileApiService(client: mockClient);
      const profile = ProfileData(
        gender: 'Woman',
        orientation: 'Queer',
        connectionIntention: 'Long-term relationship',
        relationshipStyle: 'Monogamy',
        interests: ['Coffee', 'Books', 'Fitness'],
        age: 25,
        city: 'Kolkata',
        bio: 'Lover of art, coffee, and weekend trail walks.',
        datingPreferences: ['Men', 'Nonbinary people'],
        childrenPlan: 'Want children',
        religion: 'Spiritual',
        politics: 'Moderate',
        drinking: 'Socially',
        smoking: 'Never',
      );

      final result = await service.saveProfile(profile, token: 'jwt-token-abc');

      expect(result, isNotNull);
      expect(result!.age, 25);
      expect(result.city, 'Kolkata');
      expect(result.bio, 'Lover of art, coffee, and weekend trail walks.');
      expect(result.datingPreferences, ['Men', 'Nonbinary people']);
      expect(result.childrenPlan, 'Want children');
      expect(result.religion, 'Spiritual');
      expect(result.politics, 'Moderate');
      expect(result.drinking, 'Socially');
      expect(result.smoking, 'Never');

      expect(capturedRequest.headers['authorization'], 'Bearer jwt-token-abc');
      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['age'], 25);
      expect(body['city'], 'Kolkata');
      expect(body['bio'], 'Lover of art, coffee, and weekend trail walks.');
      expect(body['datingPreferences'], ['Men', 'Nonbinary people']);
      expect(body['childrenPlan'], 'Want children');
      expect(body['religion'], 'Spiritual');
      expect(body['politics'], 'Moderate');
      expect(body['drinking'], 'Socially');
      expect(body['smoking'], 'Never');
    });

    test('CircleApiService GET /api/circles/me and PUT /api/circles/me', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path == '/api/circles/me' && request.method == 'GET') {
          expect(request.headers['authorization'], 'Bearer circle-token-xyz');
          return http.Response(
            jsonEncode({'circles': ['Coffee Explorers', 'Readers & Stories']}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/circles/me' && request.method == 'PUT') {
          expect(request.headers['authorization'], 'Bearer circle-token-xyz');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['circles'], ['Coffee Explorers', 'Gaming', 'Fitness']);
          return http.Response(
            jsonEncode({'circles': ['Coffee Explorers', 'Gaming', 'Fitness']}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = CircleApiService(client: mockClient);

      // GET
      final initial = await service.getJoinedCircles(token: 'circle-token-xyz');
      expect(initial, isNotNull);
      expect(initial, ['Coffee Explorers', 'Readers & Stories']);

      // PUT
      final updated = await service.updateJoinedCircles(
        ['Coffee Explorers', 'Gaming', 'Fitness'],
        token: 'circle-token-xyz',
      );
      expect(updated, isNotNull);
      expect(updated, ['Coffee Explorers', 'Gaming', 'Fitness']);
    });
  });

  group('Widget tests for Error Handling & Circle Persistence', () {
    testWidgets('ProfilePreviewScreen failed save stays on screen and shows error message', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      AuthSession.instance.saveSession(
        token: 'active-session-token',
        user: const AuthUser(id: 1, name: 'Sagar', email: 'sagar@example.com'),
      );

      // Mock service that fails (returns null / 500)
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });
      final service = ProfileApiService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: ProfilePreviewScreen(
            name: 'Sagar',
            age: '24',
            city: 'Kolkata',
            bio: 'Exploring authentic connections and hobbies every weekend.',
            interests: const ['Coffee', 'Books', 'Music'],
            gender: 'Woman',
            datingIntention: 'Long-term relationship',
            relationshipStyle: 'Monogamy',
            datingPreferences: const ['Women'],
            orientation: 'Lesbian',
            childrenPlan: 'Want children',
            religion: 'Spiritual',
            politics: 'Moderate',
            drinking: 'Socially',
            smoking: 'Never',
            profileApiService: service,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Save button
      await tester.ensureVisible(find.byKey(const Key('saveProfileButton')));
      await tester.tap(find.byKey(const Key('saveProfileButton')));
      await tester.pumpAndSettle();

      // Must NOT navigate to InterestCirclesScreen!
      expect(find.byType(InterestCirclesScreen), findsNothing);
      expect(find.byType(ProfilePreviewScreen), findsOneWidget);

      // Must display error message
      expect(find.text('Failed to save profile. Please check your connection and try again.'), findsOneWidget);
    });

    testWidgets('InterestCirclesScreen auto-loads joined circles and updates them on continue', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      AuthSession.instance.saveSession(
        token: 'active-session-token',
        user: const AuthUser(id: 1, name: 'Sagar', email: 'sagar@example.com'),
      );

      List<String>? savedCircles;
      final mockClient = MockClient((request) async {
        if (request.url.path == '/api/circles/me' && request.method == 'GET') {
          return http.Response(
            jsonEncode({'circles': ['Coffee Explorers', 'Gaming']}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path == '/api/circles/me' && request.method == 'PUT') {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          savedCircles = (body['circles'] as List<dynamic>).map((e) => e.toString()).toList();
          return http.Response(
            jsonEncode({'circles': savedCircles}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final service = CircleApiService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: InterestCirclesScreen(
            displayName: 'Sagar',
            circleApiService: service,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Expect joined count to reflect 2 loaded circles ('Coffee Explorers', 'Gaming')
      expect(find.text('2 joined'), findsOneWidget);

      // Tap on another circle ('Fitness')
      await tester.ensureVisible(find.byKey(const Key('joinFitness')));
      await tester.tap(find.byKey(const Key('joinFitness')));
      await tester.pumpAndSettle();

      expect(find.text('3 joined'), findsOneWidget);

      // Tap Continue
      await tester.ensureVisible(find.byKey(const Key('continueFromCirclesButton')));
      await tester.tap(find.byKey(const Key('continueFromCirclesButton')));
      await tester.pumpAndSettle();

      // Confirms updated circles were sent to backend
      expect(savedCircles, isNotNull);
      expect(savedCircles, containsAll(['Coffee Explorers', 'Gaming', 'Fitness']));

      // Navigated to complete screen
      expect(find.text('Your circles are ready, Sagar.'), findsOneWidget);
    });

    testWidgets('InterestCirclesScreen failed update stays on screen and shows error SnackBar', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      AuthSession.instance.saveSession(
        token: 'active-session-token',
        user: const AuthUser(id: 1, name: 'Sagar', email: 'sagar@example.com'),
      );

      final mockClient = MockClient((request) async {
        if (request.url.path == '/api/circles/me' && request.method == 'GET') {
          return http.Response(
            jsonEncode({'circles': ['Coffee Explorers', 'Gaming']}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        // PUT fails
        return http.Response('Internal Error', 500);
      });

      final service = CircleApiService(client: mockClient);

      await tester.pumpWidget(
        MaterialApp(
          home: InterestCirclesScreen(
            displayName: 'Sagar',
            circleApiService: service,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Continue
      await tester.ensureVisible(find.byKey(const Key('continueFromCirclesButton')));
      await tester.tap(find.byKey(const Key('continueFromCirclesButton')));
      await tester.pumpAndSettle();

      // Stays on InterestCirclesScreen
      expect(find.byType(InterestCirclesScreen), findsOneWidget);
      expect(find.text('Your circles are ready, Sagar.'), findsNothing);
      expect(find.text('Failed to save circle selections. Please check your connection and try again.'), findsOneWidget);
    });
  });
}
