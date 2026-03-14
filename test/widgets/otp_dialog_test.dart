import 'package:ammentor/components/otp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ammentor/screen/auth/view/otp_verification.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: OtpVerificationDialog(
          userRole: UserRole.mentor,
          email: "test@gmail.com",
        ),
      ),
    );
  }

  testWidgets("Otp dialog renders", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(OtpVerification), findsOneWidget);
  });

  testWidgets("OtpVerification widget recieves correct parameters", (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    final otpVerificationWidget = tester.widget<OtpVerification>(
      find.byType(OtpVerification),
    );

    expect(otpVerificationWidget.email, "test@gmail.com");
    expect(otpVerificationWidget.userRole, UserRole.mentor);


  });

 



  

}
