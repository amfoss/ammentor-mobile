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

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      name: json['name'],
      avatarUrl: json['avatar_url'],
      weeklyPoints: json['weekly_points'],
      allTimePoints: json['all_time_points'],
    );
  }
}

class Track {
  final int id;
  final String title;

  Track({required this.id, required this.title});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      title: json['title'],
    );
  }
}
