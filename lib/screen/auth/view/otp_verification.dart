import 'package:ammentor/components/theme.dart';
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:ammentor/screen/mentees/mentee_dashboard.dart';
import 'package:ammentor/screen/mentor/mentor_dashboard.dart';
import 'package:ammentor/screen/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_animation_transition/animations/bottom_to_top_faded_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
class OtpVerification extends StatefulWidget {
  final UserRole userRole;

  const OtpVerification({super.key, required this.userRole});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _formKey = GlobalKey<FormState>();

  final pin1Controller = TextEditingController();
  final pin2Controller = TextEditingController();
  final pin3Controller = TextEditingController();
  final pin4Controller = TextEditingController();

  void submitOtp() {
    final otp = pin1Controller.text +
        pin2Controller.text +
        pin3Controller.text +
        pin4Controller.text;
    print("Submitted OTP: $otp");

    // TODO: Call backend API with this `otp`
  }

  Widget buildOtpBox(TextEditingController controller) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight*0.068,
      width: screenHeight*0.064,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: "0",
          hintStyle: TextStyle(color: AppColors.darkgrey),
        ),
        style: AppTextStyles.input(context).copyWith(fontWeight: FontWeight.w600),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) => value == null || value.isEmpty ? '' : null,
      ),
    );
  }

Widget buildTopSection() {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.024),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verification code",
          style: AppTextStyles.heading(context).copyWith(
            fontWeight: FontWeight.bold,

          ),
        ),
        SizedBox(height: screenHeight * 0.008),
        Text(
          "We have sent the code verification to",
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.grey,

          ),
        ),
        SizedBox(height: screenHeight * 0.004),
        RichText(
          text: TextSpan(
            style: AppTextStyles.body(context).copyWith(fontSize: 14),
            children:  [
              TextSpan(
                text: 'ga****57@gmail.com',
                style: AppTextStyles.caption(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        RichText(
          text: TextSpan(
            style: AppTextStyles.body(context).copyWith(fontSize: 14),
            children:[
              TextSpan(
                text: 'Change mail id?',
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

@override
Widget build(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  return Form(
    key: _formKey,
    child: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTopSection(),
          SizedBox(height: screenHeight * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildOtpBox(pin1Controller),
              const SizedBox(width: 12),
              buildOtpBox(pin2Controller),
              const SizedBox(width: 12),
              buildOtpBox(pin3Controller),
              const SizedBox(width: 12),
              buildOtpBox(pin4Controller),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),
          ElevatedButton(
            onPressed: () {
              final Widget targetPage = widget.userRole == UserRole.mentor
                  ? const MentorHomePage()
                  : const MenteeHomePage();

              Navigator.of(context).pushReplacement(
                PageAnimationTransition(
                  page: targetPage,
                  pageAnimationType: BottomToTopFadedTransition(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.09,
                vertical: screenHeight * 0.015,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Login",
              style: AppTextStyles.caption(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}