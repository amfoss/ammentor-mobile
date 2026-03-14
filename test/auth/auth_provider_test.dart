import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ammentor/screen/auth/model/auth_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ammentor/screen/auth/provider/auth_provider.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('sendOtp', () {
    test('sendOtp returns success when API returns 200', () async {
      final mockClient = MockHttpClient();

      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response("ok", 200));

      final container = ProviderContainer(
        overrides: [httpClientProvider.overrideWithValue(mockClient)],
      );

      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);
      final result = await controller.sendOtp("ammentor@example.com");

      expect(result.success, true);
      expect(result.message, "OTP sent successfully");
    });

    test('sendOtp returns failure when API fails', () async {
      final mockClient = MockHttpClient();

      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response("error", 500));

      final container = ProviderContainer(
        overrides: [httpClientProvider.overrideWithValue(mockClient)],
      );

      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);
      final result = await controller.sendOtp("ammentor@example.com");

      expect(result.success, false);
      expect(result.message, "Failed to send OTP");
    });
  });

  group('verifyOtp', () {
    test('verifyOtp returns success and stores data when valid', () async {
      final mockClient = MockHttpClient();
      final mockStorage = MockStorage();

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode({"role": "mentee"}), 200),
      );

      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          storageProvider.overrideWithValue(mockStorage),
        ],
      );

      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);
      final result = await controller.verifyOtp(
        "ammentor@example.com",
        "1234",
        UserRole.mentee,
      );

      expect(result.success, true);
      expect(result.message, "OTP verified");
    });

    test('verifyOtp returns failure when API returns non-200', () async {
      final mockClient = MockHttpClient();
      final mockStorage = MockStorage();

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode({"detail": "Invalid OTP"}), 400),
      );

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          storageProvider.overrideWithValue(mockStorage),
        ],
      );

      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);
      final result = await controller.verifyOtp(
        "ammentor@example.com",
        "1234",
        UserRole.mentee,
      );

      expect(result.success, false);
      expect(result.message, "Invalid OTP");
    });

    test('verifyOtp returns failure when role mismatch', () async {
      final mockClient = MockHttpClient();
      final mockStorage = MockStorage();

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode({"role": "mentor"}), 200),
      );

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          storageProvider.overrideWithValue(mockStorage),
        ],
      );

      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);
      final result = await controller.verifyOtp(
        "ammentor@example.com",
        "1234",
        UserRole.mentee,
      );

      expect(result.success, false);
      expect(result.message, "User mail and role mismatch");
    });

    test('verifyOtp returns failure on exception', () async {
      final mockClient = MockHttpClient();
      final mockStorage = MockStorage();

      when(() => mockClient.get(any())).thenThrow(Exception("Network error"));

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(mockClient),
          storageProvider.overrideWithValue(mockStorage),
        ],
      );

      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider);
      final result = await controller.verifyOtp(
        "ammentor@example.com",
        "1234",
        UserRole.mentee,
      );

      expect(result.success, false);
      expect(result.message, "Error verifying OTP");
    });
  });
}
