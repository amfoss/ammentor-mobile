import 'package:ammentor/screen/profile/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/components/theme.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTextStyles.subheading(context).copyWith(),
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
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
//------------------------------------------------------------------------------
                // Profile Card
//------------------------------------------------------------------------------
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
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
                          SizedBox(width: screenWidth * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: AppTextStyles.body(context).copyWith(),
                                ),
                               SizedBox(height: screenHeight*0.001),
                                Text(
                                  user.email,
                                  style: AppTextStyles.caption(context).copyWith(color: AppColors.white),
                                ),
                                SizedBox(height: screenHeight*0.001),
                                Text(
                                  user.role,
                                  style: AppTextStyles.caption(context).copyWith(color: AppColors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
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

                 SizedBox(height: screenHeight * 0.03),

//------------------------------------------------------------------------------
                // Badges Card
//------------------------------------------------------------------------------
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: AppColors.darkgrey,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children:  [
                          Icon(
                            HugeIcons.strokeRoundedCheckmarkBadge02,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Text(
                            'Badges Gained',
                            style: AppTextStyles.body(context).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
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

                SizedBox(height: screenHeight * 0.03),
//------------------------------------------------------------------------------
                // Points Card
//------------------------------------------------------------------------------
              Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: AppColors.darkgrey,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: 
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(HugeIcons.strokeRoundedAnalytics01),
                    SizedBox(width:screenWidth * 0.05),
                    Text(
                      'Points Earned : ',
                      style:  AppTextStyles.body(context).copyWith(),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      user.points.toString(),
                      style:  AppTextStyles.body(context).copyWith(),
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