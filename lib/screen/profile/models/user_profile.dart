class UserProfile {
  final int id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final List<String> badges;
  final int total_points;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.badges,
    required this.total_points,
    
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      avatarUrl: 'https://github.com/amfoss.png',
      badges: ['Leadership', 'Problem Solving', 'Top Performer'],
      total_points: json['total_points'] ?? 0,
    );
  }
}