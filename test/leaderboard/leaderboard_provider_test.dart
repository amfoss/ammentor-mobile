import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/leaderboard/provider/leaderboard_provider.dart';
import 'package:ammentor/screen/leaderboard/model/leaderboard_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('selectedTrackProvider', () {
    test('selectedTrackProvider starts with null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final value = container.read(selectedTrackProvider);
      expect(value, null);
    });

    test("selectedTrackProvider updates its value with change", () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final track = Track(id: 1, title: "amFOSS");
      container.read(selectedTrackProvider.notifier).state = track;
      final value = container.read(selectedTrackProvider);
      expect(value, track);
    });
  });

  group('trackListProvider', () {
    test('trackListProvider returns list of tracks when API success', () async {
      final mockClient = MockHttpClient();
      final mockTracks = [
        {"id": 1, "title": "Praveshan"},
        {"id": 2, "title": "Anveshan"},
      ];
      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockTracks), 200));

      final container = ProviderContainer(
        overrides: [httpClientProvider.overrideWithValue(mockClient)],
      );

      addTearDown(container.dispose);

      final tracks = await container.read(trackListProvider.future);

      expect(tracks.length, 2);
      expect(tracks[0].id, 1);
      expect(tracks[0].title, "Praveshan");
      expect(tracks[1].id, 2);
      expect(tracks[1].title, "Anveshan");
    });

    test('trackListProvider throws exception on failure', () async {
      final mockClient = MockHttpClient();

      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response("Error", 500));

      final container = ProviderContainer(
        overrides: [httpClientProvider.overrideWithValue(mockClient)],
      );

      addTearDown(container.dispose);

      await expectLater(
        container.read(trackListProvider.future),
        throwsException,
      );
    });
  });

  group('leaderboardProvider', () {
    test('leaderboardProvider returns leaderboard users', () async {
      final mockClient = MockHttpClient();
      final mockLeaderboardUser = {
        "leaderboard": [
          {
            "mentee_name": "Mary",
            "avatarUrl": "https://github.com/amfoss.png",
            "total_points": 100,
            "tasks_completed": 10,
          },
          {
            "mentee_name": "John",
            "avatarUrl": "https://github.com/amfoss.png",
            "total_points": 150,
            "tasks_completed": 15,
          },
        ],
      };

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(jsonEncode(mockLeaderboardUser), 200),
      );

      final container = ProviderContainer(
        overrides: [httpClientProvider.overrideWithValue(mockClient)],
      );

      addTearDown(container.dispose);

      final mockTrackId = 0;

      final leaderboardUsers = await container.read(
        leaderboardProvider(mockTrackId).future,
      );

      expect(leaderboardUsers.length, 2);

      expect(leaderboardUsers[0].name, "Mary");
      expect(leaderboardUsers[0].avatarUrl, "https://github.com/amfoss.png");
      expect(leaderboardUsers[0].allTimePoints, 100);
      expect(leaderboardUsers[0].tasksCompleted, 10);

      expect(leaderboardUsers[1].name, "John");
      expect(leaderboardUsers[1].avatarUrl, "https://github.com/amfoss.png");
      expect(leaderboardUsers[1].allTimePoints, 150);
      expect(leaderboardUsers[1].tasksCompleted, 15);
    });

    test('leaderboardProvider throws exception when API fails', () async {
      final mockClient = MockHttpClient();

      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response("Error", 500));

      final container = ProviderContainer(
        overrides: [httpClientProvider.overrideWithValue(mockClient)],
      );

      addTearDown(container.dispose);

      final mockTrackId = 0;

      await expectLater(
        container.read(leaderboardProvider(mockTrackId).future),
        throwsException,
      );
    });

    test(
      'leaderboardProvider returns empty list when no users in track',
      () async {
        final mockClient = MockHttpClient();

        when(() => mockClient.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode({"leaderboard": []}), 200),
        );

        final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(mockClient)],
        );

        addTearDown(container.dispose);

        final mockTrackId = 0;

        final leaderboardUsers = await container.read(
          leaderboardProvider(mockTrackId).future,
        );

        expect(leaderboardUsers, isEmpty);
      },
    );
  });

  group('overallLeaderboardProvider', () {
    test('overallLeaderboardProvider merges users across tracks', () async {
      final container = ProviderContainer(
        overrides: [
          trackListProvider.overrideWith(
            (ref) async => [
              Track(id: 1, title: "Praveshan"),
              Track(id: 2, title: "Anveshan"),
            ],
          ),

          leaderboardProvider.overrideWith((ref, trackId) async {
            if (trackId == 1) {
              return [
                LeaderboardUser(
                  name: "Mary",
                  avatarUrl: "https://github.com/amfoss.png",
                  allTimePoints: 100,
                  tasksCompleted: 10,
                ),
                LeaderboardUser(
                  name: "John",
                  avatarUrl: "https://github.com/amfoss.png",
                  allTimePoints: 150,
                  tasksCompleted: 15,
                ),
              ];
            }

            if (trackId == 2) {
              return [
                LeaderboardUser(
                  name: "Mary",
                  avatarUrl: "https://github.com/amfoss.png",
                  allTimePoints: 200,
                  tasksCompleted: 20,
                ),
                LeaderboardUser(
                  name: "John",
                  avatarUrl: "https://github.com/amfoss.png",
                  allTimePoints: 250,
                  tasksCompleted: 25,
                ),
                LeaderboardUser(
                  name: "Bob",
                  avatarUrl: "https://github.com/amfoss.png",
                  allTimePoints: 50,
                  tasksCompleted: 5,
                ),
              ];
            } else {
              return [];
            }
          }),
        ],
      );

      addTearDown(container.dispose);

      final result = await container.read(overallLeaderboardProvider.future);

      final Mary = result.firstWhere((u) => u.name == "Mary");
      final John = result.firstWhere((u) => u.name == "John");
      final Bob = result.firstWhere((u) => u.name == "Bob");

      expect(result.length, 3);
      expect(Mary.allTimePoints, 300);
      expect(John.allTimePoints, 400);
      expect(Bob.allTimePoints, 50);
      expect(Mary.tasksCompleted, 30);
      expect(John.tasksCompleted, 40);
      expect(Bob.tasksCompleted, 5);
    });

    test('overallLeaderboardProvider sorts users by points', () async {
      final container = ProviderContainer(
        overrides: [
          trackListProvider.overrideWith(
            (ref) async => [Track(id: 1, title: "Praveshan")],
          ),

          leaderboardProvider.overrideWith(
            (ref, trackId) async => [
              LeaderboardUser(
                name: "Mary",
                avatarUrl: "https://github.com/amfoss.png",
                allTimePoints: 200,
                tasksCompleted: 20,
              ),
              LeaderboardUser(
                name: "John",
                avatarUrl: "https://github.com/amfoss.png",
                allTimePoints: 400,
                tasksCompleted: 40,
              ),
              LeaderboardUser(
                name: "Bob",
                avatarUrl: "https://github.com/amfoss.png",
                allTimePoints: 60,
                tasksCompleted: 6,
              ),
              LeaderboardUser(
                name: "Jane",
                avatarUrl: "https://github.com/amfoss.png",
                allTimePoints: 70,
                tasksCompleted: 7,
              ),
            ],
          ),
        ],
      );

      final result = await container.read(overallLeaderboardProvider.future);

      final points = result.map((u) => u.allTimePoints).toList();

      expect(points, [400, 200, 70, 60]);
    });

    test(
      'overallLeaderboardProvider returns empty when all tracks empty',
      () async {
        final container = ProviderContainer(
          overrides: [
            trackListProvider.overrideWith(
              (ref) async => [
                Track(id: 1, title: "Praveshan"),
                Track(id: 2, title: "Anveshan"),
              ],
            ),

            leaderboardProvider.overrideWith((ref, trackId) async => []),
          ],
        );

        addTearDown(container.dispose);

        final result = await container.read(overallLeaderboardProvider.future);

        expect(result, isEmpty);
      },
    );
  });
}
