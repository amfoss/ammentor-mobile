class UserProfile {
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final List<String> badges;
  final List<String> socialLinks;
  final int points;
  UserProfile({
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.badges,
    required this.socialLinks,
    required this.points,
  });
}
