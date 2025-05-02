import 'package:ammentor/screen/track/model/track_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

final tracksProvider = Provider<List<Track>>((ref) {
  return [
    Track(
      id: '1',
      name: 'Vidyaratna',
      description:
          'Vidyaratna (Jewel of Learning) is an initiative to provide a structured curriculum aimed at anyone interested in exploring computer science and open source development.',
      imageUrl: 'https://imgur.com/gBpUTIs.jpeg',
      tasks: [
        Task(
          taskNumber: 0,
          icon: Icons.code,
          taskName: 'Codeforces',
          points: 10,
          isCompleted: true,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Git',
          points: 20,
          isCompleted: true,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedGlobe02,
          taskName: 'Web Dev Basics',
          points: 30,
          isCompleted: true,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Build a Simple Shell',
          points: 30,
          isCompleted: true,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedDoc01,
          taskName: 'Not a SRS Doc',
          points: 30,
          isCompleted: true,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedWebDesign01,
          taskName: 'Wireframe the Skeleton',
          points: 30,
          isCompleted: true,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedFigma,
          taskName: 'Figma Design Task',
          points: 30,
          isCompleted: true,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedChrome,
          taskName: 'Frontend Development',
          points: 30,
          isCompleted: true,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Backend Development',
          points: 30,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: '	Flutter Development',
          points: 30,
        ),
      ],
    ),
    Track(
      id: '2',
      name: 'Mobile Development',
      description: 'Learn to build mobile applications.',

      imageUrl: 'https://imgur.com/04TmpeH.jpeg',
      tasks: [
        Task(
          taskNumber: 0,
          icon: HugeIcons.strokeRoundedMobileProgramming01,
          taskName: 'Fundamentals of Mobile development',
          points: 15,
          isCompleted: true,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedGithub,
          taskName: 'Version control',
          points: 25,
          isCompleted: true,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedAppStore,
          taskName: 'App components',
          points: 25,
          isCompleted: true,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedNavigation01,
          taskName: 'Interface and navigation',
          points: 25,
          isCompleted: true,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedWebDesign02,
          taskName: 'Design and architecture',
          points: 25,
          isCompleted: true,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedFloppyDisk,
          taskName: 'Storage',
          points: 25,
        ),
        Task(
          taskNumber: 6,
          icon: HugeIcons.strokeRoundedCellularNetwork,
          taskName: 'Network',
          points: 25,
        ),
        Task(
          taskNumber: 7,
          icon: HugeIcons.strokeRoundedLink01,
          taskName: 'Asynchoronism',
          points: 25,
        ),
        Task(
          taskNumber: 8,
          icon: HugeIcons.strokeRoundedService,
          taskName: 'Common services',
          points: 25,
        ),
        Task(
          taskNumber: 9,
          icon: HugeIcons.strokeRoundedRssError,
          taskName: 'Linting',
          points: 25,
        ),
        Task(
          taskNumber: 10,
          icon: HugeIcons.strokeRoundedTestTube,
          taskName: 'Testing',
          points: 25,
        ),
        Task(
          taskNumber: 11,
          icon: HugeIcons.strokeRoundedSearch01,
          taskName: 'Debugging',
          points: 25,
        ),
        Task(
          taskNumber: 12,
          icon: HugeIcons.strokeRoundedPlayStore,
          taskName: 'Distribution',
          points: 25,
        ),
      ],
    ),
    Track(
      id: '3',
      name: 'Systems and Hardware',
      description: 'Explore computer systems and hardware components.',
      imageUrl: 'https://i.imgur.com/IgDv3Gu.jpeg',
      tasks: [
        Task(
          taskNumber: 0,
          icon: HugeIcons.strokeRoundedSystemUpdate01,
          taskName: 'Introduction to Systems',
          points: 10,
          isCompleted: true,
        ),
        Task(
          taskNumber: 1,
          icon: HugeIcons.strokeRoundedCProgramming,
          taskName: 'C programming',
          points: 20,
          isCompleted: true,
        ),
        Task(
          taskNumber: 2,
          icon: HugeIcons.strokeRoundedDatabase,
          taskName: 'Database management',
          points: 20,
          isCompleted: true,
        ),
        Task(
          taskNumber: 3,
          icon: HugeIcons.strokeRoundedCpu,
          taskName: 'Assembly language',
          points: 20,
          isCompleted: true,
        ),
        Task(
          taskNumber: 4,
          icon: HugeIcons.strokeRoundedComputer,
          taskName: 'Operating Systems',
          points: 20,
          isCompleted: true,
        ),
        Task(
          taskNumber: 5,
          icon: HugeIcons.strokeRoundedCpuSettings,
          taskName: 'Linux Kernel',
          points: 20,
        ),
      ],
    ),
  ];
});
