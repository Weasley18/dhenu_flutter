# Dhenu Flutter App

## Overview

Dhenu is an AI-powered mobile platform designed to support farmers, Gaushala owners, and the general public in the conservation and management of Indian cow breeds. This application is built with Flutter and leverages Google's Generative AI (Gemini) for AI chatbot functionality.

## Features

### User Management
- Simple user management with shared preferences and secure storage
- Distinct user roles: "Farmer," "Gaushala Owner," and "Public," each with different feature sets

### Cow Management
- Dashboard for viewing and managing herd information
- Add, view, update, and delete cow records
- Track metrics like health status, milk yield, and feeding times

### Community Features
- Community Forum for creating posts, replying, and reacting (like/dislike)
- Sort posts by recent, likes, or replies

### AI & ML Integration
- Farmer Chatbot: AI assistant providing care advice and disease management tips
- Moo AI: A persona-based AI that simulates conversations with a cow

### Geo-location & Maps
- Network View: Map-based feature to locate nearby Gaushalas and veterinarians
- Stray Cow Reporting: Upload pictures of stray/injured cows with GPS location

### E-commerce & Marketplace
- Marketplace for listing and viewing cow-related products
- Product details with seller information and enquiry submission

### Multilingual Support
- Full internationalization (i18n) with support for English, Hindi, Kannada, and Marathi

## Project Structure

```
lib/
├── main.dart                # App entry point
└── src/
    ├── core/               # Shared logic, services, models, and constants
    │   ├── services/       # Mock data services
    │   ├── constants/      # App-wide constants
    │   ├── models/         # Core data models
    │   ├── providers/      # Global Riverpod providers
    │   ├── theme/          # App theme configuration
    │   └── l10n/           # Internationalization resources
    ├── features/           # Feature-specific code
    │   ├── user/           # User management screens and logic
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
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode

### Setup
1. Clone the repository
   ```
   git clone https://github.com/yourusername/dhenu-flutter.git
   cd dhenu-flutter
   ```

2. Install dependencies
   ```
   flutter pub get
   ```

3. Add your API keys
   - Create a `.env` file at the root of your project
   - Add your Gemini API key: `GEMINI_API_KEY=your_key_here`
   - Add your Google Maps API key: `GOOGLE_MAPS_API_KEY=your_key_here`

4. Run the app
   ```
   flutter run
   ```

## State Management

The app uses Riverpod for state management, which provides:
- Reactive state management
- Dependency injection
- Testable code
- Caching capabilities

## Navigation

GoRouter is used for routing, providing:
- URL-based navigation
- Deep linking support
- Navigation guards

## Internationalization

The app supports multiple languages through:
- ARB (Application Resource Bundle) files
- Flutter's built-in localization system
- Support for English, Hindi, Kannada, and Marathi

## Data Storage

The app uses a combination of:
- Shared Preferences for simple key-value storage
- Flutter Secure Storage for sensitive data
- Mock data service for simulating backend interactions

## Testing

We have a comprehensive testing strategy with:
- Unit tests using Flutter's testing framework
- Widget tests for UI components
- Integration tests for user flows

To run tests:
```
flutter test         # Run unit and widget tests
flutter test integration_test/app_test.dart  # Run integration test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

This is a Flutter conversion of the original React Native Dhenu application.