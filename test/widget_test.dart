import 'package:bondcircle/app.dart';
import 'package:bondcircle/features/profile/presentation/profile_setup_screen.dart';
import 'package:bondcircle/features/circles/presentation/interest_circles_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('switches between login and signup', (tester) async {
    await tester.pumpWidget(const BondCircleApp());
    expect(find.text('Welcome back.\nYour circle awaits.'), findsOneWidget);
    expect(find.byKey(const Key('nameField')), findsNothing);

    await tester.tap(find.byKey(const Key('signupTab')));
    await tester.pumpAndSettle();
    expect(find.text('Create a genuine\nconnection.'), findsOneWidget);
    expect(find.byKey(const Key('nameField')), findsOneWidget);
  });

  testWidgets('validates empty login form', (tester) async {
    await tester.pumpWidget(const BondCircleApp());
    await tester.tap(find.byKey(const Key('continueButton')));
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(
      find.text('Password must have at least 6 characters'),
      findsOneWidget,
    );
  });

  testWidgets('profile setup validates required details', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfileSetupScreen(initialName: 'Sagar')),
    );

    await tester.tap(find.byKey(const Key('profileContinueButton')));
    await tester.pump();

    expect(find.text('Enter age 18–99'), findsOneWidget);
    expect(find.text('Enter your city'), findsOneWidget);
    expect(find.text('Write at least 20 characters'), findsOneWidget);
  });

  testWidgets('interest circles can be filtered and joined', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: InterestCirclesScreen(displayName: 'Sagar')),
    );

    await tester.tap(find.byKey(const Key('joinCoffee Explorers')));
    await tester.pump();
    expect(find.text('1 joined'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('circleSearchField')), 'books');
    await tester.pump();
    expect(find.text('Readers & Stories'), findsOneWidget);
    expect(find.text('Coffee Explorers'), findsNothing);
  });
}
