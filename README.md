# Dhenu Flutter App

## Overview

Dhenu is an AI-powered mobile platform designed to support farmers, Gaushala owners, and the general public in the conservation and management of Indian cow breeds. This application is built with Flutter.

## Features

### Authentication
- User onboarding, sign-in, and sign-up
- Authentication error handling

### Cow Management
- Add, view, update, and delete cow records
- Cow profile management
- Cow listing and filtering

### Community Features
- Community Forum for creating posts and replying
- Post management with interactive features

### Chatbot Integration
- AI chatbot for assistance
- Chat message management

### Network & Geolocation
- Map-based feature to locate nearby facilities
- Location data visualization with search options

### Marketplace
- Product listing and management
- Product details with enquiry submission functionality

### Multilingual Support
- Full internationalization (i18n) with support for English, Hindi, Kannada, and Marathi

## Project Structure

```
lib/
├── main.dart                # App entry point
└── src/
    ├── core/               # Shared logic, services, models, and constants
    │   ├── api/            # API services
    │   ├── services/       # Mock data services
    │   ├── constants/      # App-wide constants
    │   ├── models/         # Core data models
    │   ├── providers/      # Global providers
    │   ├── theme/          # App theme configuration
    │   └── l10n/           # Internationalization resources
    ├── features/           # Feature-specific code
    │   ├── auth/           # Authentication screens and logic
    │   ├── user/           # User management
    │   ├── cow_management/ # Cow management screens and logic
    │   ├── forum/          # Community forum feature
    │   ├── chatbot/        # AI chatbot integration
    │   ├── network/        # Geolocation and maps feature
    │   └── marketplace/    # Marketplace and e-commerce
    ├── navigation/         # App navigation and routing
    └── common_widgets/     # Reusable widgets
```

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / Xcode

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

## Testing

The project includes:
- Unit tests for models
- Widget tests for UI components
- Integration tests for user flows

To run tests:
```
flutter test         # Run unit and widget tests
flutter test integration_test/auth_flow_test.dart  # Run integration test
```