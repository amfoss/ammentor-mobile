# amMentor

## Overview
amMentor is a Flutter-based mobile application that transforms traditional mentorship into an engaging, gamified experience. The platform enables mentees to progress through curated learning tracks while being guided by experienced mentors. The system emphasizes accountability, growth, and engagement through features like leaderboards, task management, and achievement recognition.

The application provides distinct interfaces for two primary user roles:

- **Mentors**: Experienced guides who review tasks and support mentees
- **Mentees**: Learners who complete tasks across various tracks to gain points and recognition

## Key Features

| Feature               | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| Role-Based Access     | Different interfaces for mentors and mentees with separate navigation flows |
| OTP Authentication    | Email-based one-time password verification for secure login                 |
| Track-Based Learning  | Domain-specific learning paths (e.g., AI, Web Dev) with track selection     |
| Leaderboard System    | Competitive ranking based on points and achievements with animated display  |
| Task Management       | Assignment, submission, and review of learning tasks                        |
| Profile Management    | User profiles with progress tracking and statistics                         |

## User Flow
The application implements a role-based user flow, starting from common authentication and diverging into role-specific experiences:

## Development and Extension

The amMentor platform uses Flutter's cross-platform capabilities to target both Android and iOS environments, with consistent styling through a centralized theme configuration. The application architecture supports extension through:

- **Additional Tracks:** New learning paths can be added to the track selection system
- **Enhanced Gamification:** The leaderboard and point system can be expanded
- **New Task Types:** The task management system can incorporate different types of assignments

## Web & Backend Versions

This project also includes:

- **[Web Version](https://github.com/AtharvaNair04/amMentor-Web)** — Built with NextJs.
- **[Common Backend](https://github.com/naveen28204280/amMentor_Backend)** — Powered by Django and REST API.

All platforms share the same backend for authentication, track management, leaderboard syncing, and progress tracking.

## Contributing Guidelines

1. **Fork** this repository
2. **Clone** your fork locally:

   ```bash
   git clone https://github.com/your-username/amMentor.git
   cd amMentor
   ```
3. **Install** dependencies:

    ```bash
    flutter pub get
    ```
4. **Create** a new branch:

    ```bash 
    git checkout -b your-feature-name
    ```
### What You Can Work On
- UI enhancements (e.g., animations, responsiveness)
- New features (e.g., badges, notifications)
- Bug fixes
- Test cases
- Code refactoring and lint cleanup
- Improving documentation (README, onboarding guide, etc.)
### Coding Guidelines
- Use **Riverpod** for state management
- Follow **Flutter/Dart best practices and format the code with:**

    ```bash
    dart format .
    ```
- Keep UI and business logic seperated
- Use meaningful commit messages : 

    ```
    feat: add track selection UI
    fix: leaderboard animation glitch
    ```
### Pull Request Process

1. Push you changes to your fork :

    ```bash
    git push origin your-feature-name
    ```
2.	Open a Pull Request (PR) against the main branch.
3.	Provide a clear description of:
    - What your PR does
    - Related issue (if any)
    - Screenshots or screen recordings (if it’s UI related)