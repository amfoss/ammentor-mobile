import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ammentor/screen/evaluation/model/mentee_tasks_model.dart';

class MenteeTasksController extends StateNotifier<List<Task>> {
  final String menteeId;

  MenteeTasksController(this.menteeId)
    : super(
        _getDummyTasks(
          menteeId,
        ).where((task) => task.status == TaskStatus.pending).toList(),
      );

  // Long list of static data for experimental purposes.
  static List<Task> _getDummyTasks(String menteeId) {
    if (menteeId == '1') {
      return [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          status: TaskStatus.pending,
        ),
      ];
    } else if (menteeId == '2') {
      return [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          status: TaskStatus.pending,
        ),
      ];
    } else if (menteeId == '3') {
      return [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          status: TaskStatus.pending,
        ),
      ];
    } else if (menteeId == '4') {
      return [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          status: TaskStatus.pending,
        ),
      ];
    } else if (menteeId == '5') {
      return [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          status: TaskStatus.pending,
        ),
      ];
    } else if (menteeId == '6') {
      return [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          status: TaskStatus.pending,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          status: TaskStatus.pending,
        ),
      ];
    } else if (menteeId == '7') {
      return [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          status: TaskStatus.returned,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          status: TaskStatus.pending,
        ),
      ];
    }
    return [];
  }

  void filterTasks(TaskStatus status) {
    state =
        _getDummyTasks(
          menteeId,
        ).where((task) => task.status == status).toList();
  }

  void showAllTasks() {
    state = _getDummyTasks(menteeId);
  }
}

final menteeTasksControllerProvider =
    StateNotifierProvider.family<MenteeTasksController, List<Task>, String>((
      ref,
      menteeId,
    ) {
      return MenteeTasksController(menteeId);
    });

final menteeTaskFilterProvider = StateProvider<String>((ref) => 'pending');
