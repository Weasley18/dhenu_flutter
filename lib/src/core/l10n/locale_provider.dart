import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the locale controller
final localeControllerProvider = StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController(ref);
});

/// Controller for managing the app locale
class LocaleController extends StateNotifier<Locale> {
  final Ref _ref;
  static const String _prefsKey = 'app_locale';

  /// Default locale is English
  LocaleController(this._ref) : super(const Locale('en'));

  /// Initialize the locale from shared preferences
  Future<void> initLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedLocale = prefs.getString(_prefsKey);
      if (storedLocale != null) {
        state = Locale(storedLocale);
      }
    } catch (e) {
      debugPrint('Error initializing locale: $e');
    }
  }

  /// Change the app locale and store it in shared preferences
  Future<void> setLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, languageCode);
      state = Locale(languageCode);
    } catch (e) {
      debugPrint('Error setting locale: $e');
    }
  }
}

/// List of supported locales in the app
final supportedLocales = [
  const Locale('en'), // English
  const Locale('hi'), // Hindi
  const Locale('kn'), // Kannada
  const Locale('mr'), // Marathi
];

/// Get the display name for a locale
String getLanguageDisplayName(String languageCode) {
  switch (languageCode) {
    case 'en':
      return 'English';
    case 'hi':
      return 'हिन्दी';
    case 'kn':
      return 'ಕನ್ನಡ';
    case 'mr':
      return 'मराठी';
    default:
      return 'English';
  }
}
