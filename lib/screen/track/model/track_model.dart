class Track {
  final int id;
  final String title;
  final String description;

  Track({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Task {
  final int taskNumber;
  final String title;
  final String description;
  final int points;
  final int id;

  Task({
    required this.taskNumber,
    required this.title,
    required this.description,
    required this.points,
    required this.id,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskNumber: json['task_no'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      id: json['id'],
    );
  }
}
