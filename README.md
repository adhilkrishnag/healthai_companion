# HealthAI Companion

A comprehensive AI-powered health tracking Flutter application with voice journaling, vitals monitoring, and personalized insights.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Features

### 🏠 Smart Dashboard
- Health score with trend tracking
- Quick action cards for common tasks
- Daily vitals grid (Steps, Sleep, Water, Mood)
- Weekly activity chart visualization
- AI-powered insights preview

### 🤖 AI Health Assistant
- Natural language health queries
- Powered by Google Gemini API
- Contextual health recommendations
- Suggested prompts for easy interaction

### 📊 Vitals Tracking
- Weight, Steps, Sleep, and Mood tracking
- Historical data visualization with charts
- Trend indicators and comparisons
- Easy data entry with validation

### 🎤 Voice Journaling
- Speech-to-text transcription
- AI-powered journal summarization
- Mood tracking integration
- Searchable journal history

### ⏰ Health Reminders
- Customizable reminder schedules
- Flexible day selection
- Toggle reminders on/off
- Push notification support (coming soon)

### ⚙️ Personalization
- Light/Dark/System theme modes
- Profile management
- Data privacy controls
- Secure local storage

## Tech Stack

- **Framework**: Flutter 3.x with Dart 3.x
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: Hive with encryption
- **Charts**: fl_chart
- **Animations**: flutter_animate
- **Speech Recognition**: speech_to_text
- **AI Integration**: Google Generative AI (Gemini)
- **Typography**: Google Fonts (Outfit)

## Architecture

The app follows **Clean Architecture** principles with a feature-based folder structure:

```
lib/
├── app.dart                 # Root app widget
├── main.dart                # Entry point
├── core/                    # Shared utilities
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── storage/
│   ├── theme/
│   └── utils/
├── features/                # Feature modules
│   ├── ai_insights/
│   ├── auth/
│   ├── dashboard/
│   ├── journal/
│   ├── onboarding/
│   ├── profile/
│   ├── reminders/
│   ├── settings/
│   └── vitals/
└── shared/                  # Shared widgets & services
```

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.x
- Android Studio / VS Code
- (Optional) Google Gemini API key for AI features

### Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/healthai_companion.git
cd healthai_companion
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Configuration

To enable AI features, add your Gemini API key:
1. Navigate to Settings > AI Settings
2. Enter your API key
3. The key is stored securely using flutter_secure_storage

## Screenshots

*Coming soon*

## Roadmap

- [ ] Firebase Authentication
- [ ] Cloud sync with Firestore
- [ ] Push notifications
- [ ] Wearable device integration
- [ ] PDF health report export
- [ ] Widget for home screen
- [ ] Web support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for elegant state management
- Google for Gemini AI capabilities
