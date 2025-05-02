<p align="center">
  <img src="assets/images/image.png" width="400" alt="amMentor Logo" />
</p>
<p align="center">
  A gamified mentorship platform built with Flutter.
</p>

<p align="center">
  <a href="https://github.com/flutter/flutter">
    <img src="https://img.shields.io/badge/platform-Flutter-blue" alt="Flutter" />
  </a>
  <a href="https://github.com/django/django">
    <img src="https://img.shields.io/badge/API-Django-green" alt="Django" />
  </a>
  <a href="https://github.com/AtharvaNair04/amMentor-Web">
    <img src="https://img.shields.io/badge/Web-Next.js-orange" alt="Web App" />
  </a>
  <a href="https://github.com/naveen28204280/amMentor_Backend">
    <img src="https://img.shields.io/badge/Common-Backend-green" alt="Backend" />
  </a>
  <a href="https://deepwiki.com/ganidande905/amMentor/1-overview">
    <img src="https://img.shields.io/badge/Docs-DeepWiki-blueviolet" alt="Docs" />
  </a>
  <a href="#contributing-guidelines">
    <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg" alt="Contributions Welcome" />
  </a>
</p>

## Overview
amMentor is a Flutter-based mobile application that transforms traditional mentorship into an engaging, gamified experience. The platform enables mentees to progress through curated learning tracks while being guided by experienced mentors. The system emphasizes accountability, growth, and engagement through features like leaderboards, task management, and achievement recognition.

The application provides distinct interfaces for two primary user roles:

- **Mentors**: Experienced guides who review tasks and support mentees
- **Mentees**: Learners who complete tasks across various tracks to gain points and recognition

<img width="1358" alt="Screenshot 2025-05-02 at 3 24 15 AM" src="https://github.com/user-attachments/assets/63bef2ed-d0be-47f5-816c-d4ddfcc55a98" />



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

<img width="1353" alt="Screenshot 2025-05-02 at 3 22 55 AM" src="https://github.com/user-attachments/assets/6c8a655e-a1b9-4260-91da-585766c21b64" />

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
