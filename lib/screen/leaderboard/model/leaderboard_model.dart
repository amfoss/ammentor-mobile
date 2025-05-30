class LeaderboardUser {
  final String name;
  final String avatarUrl;
  final int allTimePoints;
  final int tasksCompleted;

  LeaderboardUser({
    required this.name,
    required this.avatarUrl,
    required this.allTimePoints,
    required this.tasksCompleted,
  });

factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
  final menteeName = json['mentee_name'] ?? 'Unknown';
  return LeaderboardUser(
    name: menteeName,
    avatarUrl: 'https://github.com/amfoss.png', // to be changed into user's github profile picture
    allTimePoints: json['total_points'] ?? 0,
    tasksCompleted: json['tasks_completed'] ?? 0,
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
