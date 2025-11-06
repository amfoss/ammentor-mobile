enum TaskStatus { pending, returned }

class Task {
  final int taskId;
  final int submissionId;
  final int taskNumber;
  final String taskName;
  final TaskStatus status;
  final String? referenceLink;
  final String? startDate;
  final String? submittedAt;
  final String? approvedAt;
  final String? mentorFeedback;

  Task({
    required this.submissionId,
    required this.taskNumber,
    required this.taskId,
    required this.taskName,
    required this.status,
    this.referenceLink,
    this.startDate,
    this.submittedAt,
    this.approvedAt,
    this.mentorFeedback,
  });

  factory Task.fromSubmission(Submission submission, String taskName) {
    return Task(
      submissionId: submission.id,
      taskNumber: submission.taskNo,
      taskName: taskName,
      taskId: submission.taskNo,
      status:
          submission.status == 'submitted'
              ? TaskStatus.pending
              : TaskStatus.returned,
      referenceLink: submission.referenceLink,
      startDate: submission.startDate,
      submittedAt: submission.submittedAt,
      approvedAt: submission.approvedAt,
      mentorFeedback: submission.mentorFeedback,
    );
  }
}

class Submission {
  final int id;
  final int menteeId;
  final int taskNo;
  final int taskId;
  final String referenceLink;
  final String status;
  final String? submittedAt;
  final String? approvedAt;
  final String? mentorFeedback;
  final String? startDate;
  final String? taskName;
  Submission({
    required this.id,
    required this.taskId,
    required this.menteeId,
    required this.taskNo,
    required this.referenceLink,
    required this.status,
    this.submittedAt,
    this.approvedAt,
    this.mentorFeedback,
    this.startDate,
    this.taskName
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      menteeId: json['mentee_id'],
      taskNo: json['task_no'],
      referenceLink: json['reference_link'],
      status: json['status'],
      submittedAt: json['submitted_at'],
      approvedAt: json['approved_at'],
      mentorFeedback: json['mentor_feedback'],
      startDate: json['start_date'],
      taskId: json['task_id'],
      taskName: json['task_name'],
    );
  }
}

class TrackTask {
  final int id;
  final int trackId;
  final int taskNo;
  final String title;
  final String description;
  final int points;
  final int? deadline;

  TrackTask({
    required this.id,
    required this.trackId,
    required this.taskNo,
    required this.title,
    required this.description,
    required this.points,
    this.deadline,
  });

  factory TrackTask.fromJson(Map<String, dynamic> json) {
    return TrackTask(
      id: json['id'],
      trackId: json['track_id'],
      taskNo: json['task_no'],
      title: json['title'],
      description: json['description'],
      points: json['points'],
      deadline: json['deadline'],
    );
  }
}
