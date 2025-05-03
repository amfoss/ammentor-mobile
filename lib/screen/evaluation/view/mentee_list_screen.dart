import 'package:flutter/material.dart';
import 'package:ammentor/components/theme.dart';
import 'package:ammentor/components/mentee_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/view/mentee_tasks_screen.dart';
import 'package:ammentor/screen/evaluation/provider/mentee_list_provider.dart';

class MenteeListScreen extends ConsumerStatefulWidget {
  const MenteeListScreen({super.key});

  @override
  ConsumerState<MenteeListScreen> createState() => _MenteeListScreenState();
}

class _MenteeListScreenState extends ConsumerState<MenteeListScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mentees = ref.watch(menteeListControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Task review',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Choose the mentee',
              style: TextStyle(fontSize: 18.0, color: AppColors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController!,
                builder: (context, child) {
                  return ListView.builder(
                    itemCount: mentees.length,
                    itemBuilder: (context, index) {
                      final mentee = mentees[index];
                      return FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _animationController!,
                            curve: Interval(
                              index * 0.05,
                              1.0,
                              curve: Curves.easeIn,
                            ),
                          ),
                        ),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController!,
                              curve: Interval(
                                index * 0.05,
                                1.0,
                                curve: Curves.easeIn,
                              ),
                            ),
                          ),
                          child: MenteeTile(
                            number: index + 1,
                            mentee: mentee,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          MenteeTasksScreen(mentee: mentee),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
