# Dhenu Flutter App

## Overview

Dhenu is an AI-powered mobile platform designed to support farmers, Gaushala owners, and the general public in the conservation and management of Indian cow breeds. Built with Flutter, this application offers a comprehensive suite of tools for cow management, community engagement, and marketplace access.

## Features

### Authentication
- User onboarding, sign-in, and sign-up
- Authentication error handling
- Secure credential management

### Cow Management
- Add, view, update, and delete cow records
- Cow profile management with health tracking
- Advanced filtering and searching capabilities

### Community Features
- Community Forum for discussions and knowledge sharing
- Post creation, editing, and management
- Interactive commenting system

### Chatbot Integration
- AI chatbot for specialized assistance
- Natural language processing for cow health queries
- Personalized recommendations

### Network & Geolocation
- Map-based features to locate nearby Gaushalas and facilities
- Real-time location services and directions
- Search and filter options for finding resources

### Marketplace
- Product listing and management for cow-based products
- Detailed product information and imagery
- Inquiry submission functionality

### Multilingual Support
- Full internationalization (i18n) with support for:
  - English
  - Hindi
  - Kannada
  - Marathi

## Tech Stack

- **Framework**: Flutter (SDK >=3.0.0)
- **State Management**: Flutter Riverpod
- **Navigation**: Go Router
- **Localization**: Flutter Localizations & Intl
- **Storage**: Shared Preferences
- **Architecture**: Feature-first with clean architecture principles

## Project Structure

```
lib/
├── main.dart                # App entry point
└── src/
    ├── common_widgets/      # Reusable UI components
    ├── core/                # Core functionality
    │   ├── api/             # API services
    │   ├── services/        # Business logic services
    │   ├── constants/       # App-wide constants
    │   ├── models/          # Data models
    │   ├── providers/       # State management providers
    │   ├── theme/           # App theme configuration
    │   └── l10n/            # Internationalization resources
    ├── features/            # Feature modules
    │   ├── auth/            # Authentication
    │   ├── user/            # User management
    │   ├── cow_management/  # Cow management
    │   ├── forum/           # Community forum
    │   ├── chatbot/         # AI chatbot integration
    │   ├── network/         # Geolocation and maps
    │   └── marketplace/     # Product marketplace
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

### Configuration
- Configure environment variables in `.env` file (see `.env.example`)
- For iOS, update `ios/Runner/Info.plist` with required permissions
- For Android, update `android/app/src/main/AndroidManifest.xml` as needed

## Development

### Code Style
This project follows the official [Flutter style guide](https://dart.dev/guides/language/effective-dart/style) and uses Flutter Lints for code quality.

### State Management
The app uses Flutter Riverpod for state management. All providers are organized within their respective feature modules.

### Adding Features
1. Create a new directory under `lib/src/features/`
2. Implement screens, controllers, and repositories
3. Register routes in `lib/src/navigation/`
4. Add tests for new functionality

## Testing

The project includes comprehensive testing:
- **Unit tests** for models and business logic
- **Widget tests** for UI components
- **Integration tests** for user flows

To run tests:
```
flutter test                                      # Run all unit and widget tests
flutter test test/models/                         # Run specific test directory
flutter test integration_test/auth_flow_test.dart # Run integration test
```

## Internationalization

The app supports multiple languages through Flutter's localization system. Translations are stored in `.arb` files in `lib/src/core/l10n/`.

To add a new language:
1. Create a new `.arb` file in the l10n directory
2. Run `flutter gen-l10n` to generate localization files

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Thanks to all contributors who have helped shape this project
- Special thanks to the Flutter team for their amazing framework