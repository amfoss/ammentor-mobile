import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/auth/view/otp_verification.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';

void main() {

  Widget createWidget() {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: OtpVerification(
            email: "test@example.com",
            userRole: UserRole.mentee,
          ),
        ),
      ),
    );
  }

  testWidgets('OTP screen renders correctly', (tester) async {
    await tester.pumpWidget(createWidget());

    expect(find.text('Verification code'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    expect(find.byType(TextFormField), findsNWidgets(4));
  });

  testWidgets('login button disabled when OTP incomplete', (tester) async {
    await tester.pumpWidget(createWidget());

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull); 
  });

}
