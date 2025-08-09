class Submission {
  final int id;
  final int taskId;
  final int taskNo;
  final String taskName;
  final String commitHash;
  final String status;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final DateTime? startDate;
  final DateTime? endDate; // keep if you plan to add later
  final String? mentorFeedback;

  Submission({
    required this.id,
    required this.taskId,
    required this.taskNo,
    required this.taskName,
    required this.commitHash,
    required this.status,
    required this.submittedAt,
    this.approvedAt,
    this.startDate,
    this.endDate,
    this.mentorFeedback,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    DateTime? _d(v) {
      if (v == null) return null;
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      return DateTime.parse(s); // handles 'YYYY-MM-DD'
    }

    return Submission(
      id: (json['id'] as num).toInt(),
      taskId: (json['task_id'] as num).toInt(),
      taskNo: (json['task_no'] as num?)?.toInt() ?? 0,
      taskName: (json['task_name'] ?? '').toString(),
      commitHash: (json['commit_hash'] ?? '').toString(),
      status: (json['status'] ?? 'submitted').toString(),
      submittedAt: _d(json['submitted_at']),
      approvedAt: _d(json['approved_at']),
      startDate: _d(json['start_date']),
      endDate: _d(json['end_date']), // backend may not send; stays null
      mentorFeedback: json['mentor_feedback']?.toString(),
    );
  }
}