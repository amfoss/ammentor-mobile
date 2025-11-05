enum EvaluationStatus { returned, paused }

class Evaluation {
  final String? feedback;
  final EvaluationStatus status;

  Evaluation({this.feedback, required this.status});
}
