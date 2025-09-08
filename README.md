# Dhenu Flutter App

## Overview

Dhenu is an AI-powered mobile platform designed to support farmers, Gaushala owners, and the general public in the conservation and management of Indian cow breeds. Built with Flutter, this application provides a structured foundation for cow management and community engagement.

## Currently Implemented Features

### Navigation and UI Framework
- Responsive drawer-based navigation
- Basic screen scaffolding for all major features
- Theme implementation with brand color scheme


### Screen Structure
- Dashboard - Home screen with overview information
- Profile - User profile management
- Forum - Community discussion board (structure only)
- Network - Geolocation-based services (structure only)
- Settings - Application preferences (structure only)
- Help - User assistance and information (structure only)

## Tech Stack

- **Framework**: Flutter (SDK >=3.0.0)
- **State Management**: Flutter Riverpod
- **Navigation**: Go Router
- **Localization**: Flutter Localizations & Intl
- **Storage**: Shared Preferences
- **Architecture**: Feature-first design

## Project Structure

```
lib/
├── main.dart                # App entry point
└── src/
    ├── common_widgets/      # Reusable UI components
    ├── core/                # Core functionality
    │   ├── constants/       # App-wide constants
    │   ├── l10n/            # Internationalization resources
    │   ├── providers/       # State management providers
    │   ├── services/        # Business logic services
    │   └── theme/           # App theme configuration
    ├── features/            # Feature modules
    │   ├── dashboard/       # Dashboard screen
    │   ├── forum/           # Community forum
    │   ├── help/            # Help and support
    │   ├── network/         # Geolocation services
    │   ├── profile/         # User profile
    │   └── settings/        # App settings
    ├── navigation/          # App navigation and routing
    └── testing/             # Testing utilities
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode
- Git

### Setup
1. Clone the repository
   ```
   git clone https://github.com/Weasley18/dhenu_flutter.git
   cd dhenu_flutter
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Run the app
   ```
   flutter run
   ```

## Development

### Code Style
This project follows the official [Flutter style guide](https://dart.dev/guides/language/effective-dart/style) and uses Flutter Lints for code quality.

### State Management
The app uses Flutter Riverpod for state management.

### Adding Features
1. Create a new directory under `lib/src/features/`
2. Implement screens, controllers, and repositories
3. Register routes in `lib/src/navigation/router.dart`
4. Add tests for new functionality

## Testing

The project has a testing framework set up for:
- Unit tests for models
- Widget tests for UI components
- Integration tests for user flows

To run tests:
```
flutter test                                      # Run all unit and widget tests
flutter test integration_test/auth_flow_test.dart # Run integration test
```

