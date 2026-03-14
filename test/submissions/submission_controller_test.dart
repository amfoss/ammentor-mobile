import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ammentor/screen/mentee-submissions/provider/submission_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('TaskSubmissionState', () {
    test(
      'initial state has isSubmitting false and isSubmissionSuccessful false',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final state = container.read(taskSubmissionControllerProvider(1));

        expect(state.isSubmitting, false);
        expect(state.isSubmissionSuccessful, false);
      },
    );
  });

  group('TaskSubmissionController - successful submission', () {
    test('submitTask sets isSubmitting true during submission', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      SharedPreferences.setMockInitialValues({
        'user_email': 'ammentor@example.com',
      });

      final controller = container.read(
        taskSubmissionControllerProvider(1).notifier,
      );

      try {
        controller.submitTask(
          1,
          1,
          "https://example.com",
          DateTime(2026, 3, 12),
        );
      } catch (e) {}

      final state = container.read(taskSubmissionControllerProvider(1));

      expect(state.isSubmitting, true);
      expect(state.isSubmissionSuccessful, false);
    });

    test(
      'submitTask sets isSubmissionSuccessful true when API returns 200',
      () async {
        final mockClient = MockHttpClient();

        when(
          () => mockClient.post(
            any(),
            headers: any(named: "headers"),
            body: any(named: "body"),
          ),
        ).thenAnswer((_) async => http.Response("ok", 200));

        final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(mockClient)],
        );

        addTearDown(container.dispose);

        SharedPreferences.setMockInitialValues({
          'user_email': "ammentor@example.com",
        });

        final controller = container.read(
          taskSubmissionControllerProvider(1).notifier,
        );

        await controller.submitTask(
          1,
          1,
          "https://github.com",
          DateTime(2026, 3, 12),
        );

        final state = container.read(taskSubmissionControllerProvider(1));

        expect(state.isSubmitting, false);
        expect(state.isSubmissionSuccessful, true);
      },
    );

    test(
      'submitTask sets isSubmissionSuccessful true when API returns 201',
      () async {
        final mockClient = MockHttpClient();

        when(
          () => mockClient.post(
            any(),
            headers: any(named: "headers"),
            body: any(named: "body"),
          ),
        ).thenAnswer((_) async => http.Response("ok", 201));

        final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(mockClient)],
        );

        addTearDown(container.dispose);

        SharedPreferences.setMockInitialValues({
          'user_email': "ammentor@example.com",
        });

        final controller = container.read(
          taskSubmissionControllerProvider(1).notifier,
        );

        await controller.submitTask(
          1,
          1,
          "https://github.com",
          DateTime(2026, 3, 12),
        );

        final state = container.read(taskSubmissionControllerProvider(1));

        expect(state.isSubmitting, false);
        expect(state.isSubmissionSuccessful, true);
      },
    );
  });

  group('TaskSubmissionController - API failures', () {
    test(
      'submitTask throws exception when API returns 409 duplicate submission',
      () async {
        final mockClient = MockHttpClient();

        when(
          () => mockClient.post(
            any(),
            headers: any(named: "headers"),
            body: any(named: "body"),
          ),
        ).thenAnswer((_) async => http.Response("duplicate submission", 409));

        final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(mockClient)],
        );

        addTearDown(container.dispose);

        SharedPreferences.setMockInitialValues({
          'user_email': "ammentor@example.com",
        });

        final controller = container.read(
          taskSubmissionControllerProvider(1).notifier,
        );

        await expectLater(
          controller.submitTask(
            1,
            1,
            "https://github.com",
            DateTime(2026, 3, 12),
          ),
          throwsException,
        );

        final state = container.read(taskSubmissionControllerProvider(1));

        expect(state.isSubmitting, false);
        expect(state.isSubmissionSuccessful, false);
      },
    );

    test(
      'submitTask throws exception when API returns non success status',
      () async {
        final mockClient = MockHttpClient();

        when(
          () => mockClient.post(
            any(),
            headers: any(named: "headers"),
            body: any(named: "body"),
          ),
        ).thenAnswer((_) async => http.Response("error", 500));

        final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(mockClient)],
        );

        addTearDown(container.dispose);

        SharedPreferences.setMockInitialValues({
          'user_email': "ammentor@example.com",
        });

        final controller = container.read(
          taskSubmissionControllerProvider(1).notifier,
        );

        await expectLater(
          controller.submitTask(
            1,
            1,
            "https://github.com",
            DateTime(2026, 3, 12),
          ),
          throwsException,
        );

        final state = container.read(taskSubmissionControllerProvider(1));

        expect(state.isSubmitting, false);
        expect(state.isSubmissionSuccessful, false);
      },
    );
  });

  group('TaskSubmissionController - SharedPreferences edge cases', () {
    test(
      'submitTask throws exception when user_email not found in SharedPreferences',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        SharedPreferences.setMockInitialValues({});

        final controller = container.read(
          taskSubmissionControllerProvider(1).notifier,
        );

        await expectLater(
          controller.submitTask(
            1,
            1,
            "https://github.com",
            DateTime(2026, 3, 12),
          ),
          throwsException,
        );

        final state = container.read(taskSubmissionControllerProvider(1));

        expect(state.isSubmissionSuccessful, false);
        expect(state.isSubmitting, false);
      },
    );
  });

  group('TaskSubmissionController - request validation', () {
    test(
      'submitTask sends correct request body to API and convertDate formats DateTime into yyyy-mm-dd',
      () async {
        final mockClient = MockHttpClient();

        when(
          () => mockClient.post(
            any(),
            headers: any(named: "headers"),
            body: any(named: "body"),
          ),
        ).thenAnswer((invocation) async {
          final body = invocation.namedArguments[#body];
          final decoded = jsonDecode(body);

          expect(decoded["track_id"], 1);
          expect(decoded['task_no'], 1);
          expect(decoded["reference_link"], "https://github.com");
          expect(decoded["start_date"], "2026-03-12");
          expect(decoded["mentee_email"], "ammentor@example.com");

          return http.Response("ok", 200);
        });

        final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(mockClient)],
        );

        addTearDown(container.dispose);

        SharedPreferences.setMockInitialValues({
          'user_email': "ammentor@example.com",
        });

        final controller = container.read(
          taskSubmissionControllerProvider(1).notifier,
        );

        await controller.submitTask(
          1,
          1,
          "https://github.com",
          DateTime(2026, 3, 12),
        );
      },
    );
  });
}
