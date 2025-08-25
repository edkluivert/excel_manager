# Excel Manager

## Overview

**Excel Manager** is a Flutter mobile application designed to help users manage projects and tasks efficiently. It provides local data storage with Hive and includes features like local notifications and an AI-powered assistant to enhance productivity.

---

## Features

- **Project Management:** Create, update, and organize projects.
- **Task Management:** Add, edit, and track tasks within projects.
- **Local Data Storage:** Utilizes Hive for fast and persistent local storage.
- **Local Notifications:** Reminds users of task deadlines and milestones.
- **AI Assistant:** Suggests tasks and optimizes planning with AI support.

---

## Technologies Used

- **Flutter & Dart:** Cross-platform mobile app development.
- **Hive:** Local database storage.
- **flutter_local_notifications:** Scheduling and displaying notifications.
- **Bloc:** State management for scalable architecture.

---

## Project Structure

The project is organized into clear layers:

- `lib/data/models/` – Data models (e.g., `project_model.dart`, `task_model.dart`).
- `lib/data/data_sources/local/` – Local data sources using Hive.
- `lib/domain/entities/` – Core entities used across the app.
- `lib/domain/repositories/` – Repository interfaces for data abstraction.
- `lib/application/` – Application logic including Cubits/Blocs.
- `lib/presentation/screens/` – UI screens.
- `lib/services/` – Services such as AI, notifications, and shared preferences.
- `test/` – Unit and widget tests.

---

## Getting Started

### Prerequisites

- Flutter SDK ([Installation Guide](https://flutter.dev/docs/get-started/install))
- Dart SDK
- An IDE like Android Studio or VS Code with Flutter plugins

### Installation

1. Clone the repository:

```bash
git clone <your-repository-url>

cd excel_manager


flutter pub get


# .env.example
GEMINI_API_KEY=your_gemini_api_key_here
OPENAI_API_KEY=your_openai_api_key_here


Using Mock AI Assistant

For testing without real API keys:

final mockAIService = MockAIService();


Unit & Widget Tests
flutter test


Tests are located in the test/ directory.

Integration Tests
flutter test integration_test
