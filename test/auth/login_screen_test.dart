import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/auth/view/login_screen.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';

void main() {

  Widget createWidget(UserRole role) {
    return ProviderScope(
      child: MaterialApp(
        home: LoginScreen(userRole: role),
      ),
    );
  }

  testWidgets('LoginScreen renders correctly for mentee', (tester) async {
    await tester.pumpWidget(createWidget(UserRole.mentee));

    expect(find.text('Mentee Login'), findsOneWidget);
    expect(find.text('Get OTP'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('LoginScreen renders correctly for mentor', (tester) async {
    await tester.pumpWidget(createWidget(UserRole.mentor));

    expect(find.text('Mentor Login'), findsOneWidget);
  });

  testWidgets('shows error for invalid email', (tester) async {
    await tester.pumpWidget(createWidget(UserRole.mentee));

    await tester.tap(find.text('Get OTP'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

}
