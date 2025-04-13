import 'package:ammentor/screen/leaderboard/model/leaderboard_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availableTracks = ['Vidyaratna', 'Ai', 'Mobile App Development', 'Web Development'];

final selectedTrackProvider = StateProvider<String>((ref) => availableTracks[0]);

final leaderboardProvider = FutureProvider.family<List<LeaderboardUser>, String>((ref, track) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return List.generate(30, (index) {
    return LeaderboardUser(
      name: '$track User $index',
      avatarUrl: 'https://robohash.org/$track-user$index.png',
      weeklyPoints: (30 - index) * 10,
      allTimePoints: (30 - index) * 15,
    );
  });
});