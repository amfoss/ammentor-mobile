import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userEmailProvider = StateProvider<String?>((ref) => null);
final storage = FlutterSecureStorage();

Future<void> initializeUserEmail(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('user_email');
  ref.read(userEmailProvider.notifier).state = email;
}

class AuthController {
  Future<OtpResponse> sendOtp(String email) async {
    final url = Uri.parse('${dotenv.env['BACKEND_URL']}/auth/send-otp/$email');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return OtpResponse(message: "OTP sent successfully", success: true);
      }
      return OtpResponse(message: "Failed to send OTP", success: false);
    } catch (_) {
      return OtpResponse(message: "Error sending OTP", success: false);
    }
  }

  Future<OtpResponse> verifyOtp(String email, String otp, UserRole role) async {
    final url = Uri.parse(
      '${dotenv.env['BACKEND_URL']}/auth/verify-otp/$email?otp=$otp',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);

        return OtpResponse(
          message: body['detail'] ?? "Invalid OTP",
          success: false,
        );
      }
      final body = jsonDecode(response.body);
      final backendRole = body['role'];
      if (backendRole == null) {
        return OtpResponse(message: "User not found", success: false);
      }
      if (backendRole != role.name) {
        return OtpResponse(
          message: "User mail and role mismatch",
          success: false,
        );
      }
      await storage.write(key: 'isLoggedIn', value: 'true');
      await storage.write(key: 'userEmail', value: email);
      await storage.write(key: 'userRole', value: role.name);
      return OtpResponse(message: "OTP verified", success: true);
    } catch (_) {
      return OtpResponse(message: "Error verifying OTP", success: false);
    }
  }
}
