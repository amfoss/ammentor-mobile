class LeaderboardUser {
  final String name;
  final String avatarUrl;
  final int weeklyPoints;
  final int allTimePoints;

  LeaderboardUser({
    required this.name,
    required this.avatarUrl,
    required this.weeklyPoints,
    required this.allTimePoints,
  });
}