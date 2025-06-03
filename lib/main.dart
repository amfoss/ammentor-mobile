import 'package:ammentor/screen/auth/provider/auth_provider.dart';
import 'package:ammentor/screen/mentees/mentee_dashboard.dart';
import 'package:ammentor/screen/mentor/mentor_dashboard.dart';
import 'package:ammentor/screen/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'components/theme.dart';

final storage = FlutterSecureStorage();

enum UserRole {
  mentor,
  mentee,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> loadAuthInfo() async {
    final isLoggedIn = await storage.read(key: 'isLoggedIn');
    final roleStr = await storage.read(key: 'userRole');

    UserRole? role;
    if (roleStr != null) {
      role = UserRole.values.firstWhere((e) => e.name == roleStr);
    }

    return {
      'isLoggedIn': isLoggedIn == 'true',
      'role': role,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initializeUserEmail(ref);
    return FutureBuilder<Map<String, dynamic>>(
      future: loadAuthInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final data = snapshot.data!;
        final isLoggedIn = data['isLoggedIn'] as bool;
        final role = data['role'] as UserRole?;

        Widget home;

        if (!isLoggedIn || role == null) {
          home = const WelcomeScreen();
        } else if (role == UserRole.mentor) {
          home = const MentorHomePage();
        } else {
          home = const MenteeHomePage(); 
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'amMentor',
          theme: appTheme,
          home: home,
        );
      },
    );
  }
}