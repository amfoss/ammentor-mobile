import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

// Toggle this to false once backend is ready
const bool isMockMode = true;

final userProvider = FutureProvider<UserProfile>((ref) async {
  if (isMockMode) {
    await Future.delayed(const Duration(milliseconds: 300)); 
    return UserProfile(
      name: 'Ganeswar',
      email: 'gani@amfoss.dev',
      role: 'Mentee @ amFOSS',
      avatarUrl: 'https://example.com/avatar.jpg',
      badges: ['1', '2', '3', '4'],
      socialLinks: ['github', 'gitlab', 'email'],
      points: 100,
    );
  } else {
    // Replace with real API call
    throw UnimplementedError('API not implemented');
  }
});