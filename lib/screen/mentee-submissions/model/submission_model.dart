class Submission {
  final int id;
  final int taskId;
  final int taskNo;
  final String taskName;
  final String referenceLink;
  final String status;
  final DateTime submittedAt;
  final DateTime? approvedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final String mentorFeedback;

  Submission({
    required this.id,
    required this.taskId,
    required this.taskNo,
    required this.taskName,
    required this.referenceLink,
    required this.status,
    required this.submittedAt,
    this.approvedAt,
    this.startDate,
    this.endDate,
    required this.mentorFeedback,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'],
      taskNo: json['task_no'] ?? 0,
      taskId: json['task_id'],
      taskName: json['task_name'] ?? '',
      referenceLink: json['reference_link']?.toString() ?? '',
      status: json['status']?.toString() ?? 'submitted',
      submittedAt: DateTime.parse(json['submitted_at']),
      approvedAt:
          json['approved_at'] != null
              ? DateTime.parse(json['approved_at'])
              : null,
      startDate:
          json['start_date'] != null
              ? DateTime.parse(json['start_date'])
              : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      mentorFeedback: json['mentor_feedback']?.toString() ?? '',
    );
  }
}
