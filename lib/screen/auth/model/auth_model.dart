class OtpResponse {
  final String message;
  final bool success;

  OtpResponse({required this.message, required this.success});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
enum UserRole {
  mentor,
  mentee,
}