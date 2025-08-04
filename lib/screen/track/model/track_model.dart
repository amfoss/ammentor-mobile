class Track {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Task> tasks;

  Track({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.tasks = const [],
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'].toString(),
      name: json['title'],
      description: json['description'],
      imageUrl: 'https://placehold.co/150',
      tasks: [],
    );
  }

  double get progress {
    if (tasks.isEmpty) {
      return 0.0;
    }
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return completedTasks / tasks.length * 100;
  }
}

class Task {
  final int trackId;
  final int taskNumber;
  final String taskName;
  final String description;
  final int points;
  final bool isCompleted;
  final int deadline;

  Task({
    required this.trackId,
    required this.taskNumber,
    required this.taskName,
    required this.description,
    required this.points,
    this.isCompleted = false,
    required this.deadline,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      trackId: json['track_id'],
      taskNumber: json['task_no'],
      taskName: json['title'],
      description: json['description'],
      points: json['points'],
      isCompleted: false,
      deadline: json['deadline'] ?? 0,
    );
  }
}