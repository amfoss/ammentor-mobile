import 'package:ammentor/screen/profile/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (user) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
//------------------------------------------------------------------------------
                // Profile Card
//------------------------------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkgrey,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.avatarUrl),
                            radius: 40,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.role,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: user.socialLinks.map((platform) {
                          switch (platform) {
                            case 'github':
                              return const Icon(HugeIcons.strokeRoundedGithub,
                                  color: Colors.white, size: 40);
                            case 'gitlab':
                              return const Icon(HugeIcons.strokeRoundedGitlab,
                                  color: Colors.white, size: 40);
                            case 'email':
                              return const Icon(Icons.alternate_email,
                                  color: Colors.white, size: 40);
                            default:
                              return const SizedBox();
                          }
                        }).toList(),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

//------------------------------------------------------------------------------
                // Badges Card
//------------------------------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkgrey,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Icon(
                            HugeIcons.strokeRoundedCheckmarkBadge02,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Badges Gained',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: user.badges.map((badge) {
                          return CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 20,
                            child: Text(
                              badge[0], // Display first letter
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30,),
//------------------------------------------------------------------------------
                // Points Card
//------------------------------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkgrey,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: 
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(HugeIcons.strokeRoundedAnalytics01),
                    const SizedBox(width: 20),
                    Text(
                      'Points Earned : ',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      user.points.toString(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                      ),
                    )
                  ]
                ),
              )
              ],
            ),
          );
        },
      ),
    );
  }
}