import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/navigation/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/providers/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(
    child: DhenuApp(),
  ));
}

class DhenuApp extends ConsumerWidget {
  const DhenuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeData = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Dhenu',
      theme: themeData,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('kn'), // Kannada
        Locale('mr'), // Marathi
      ],
    );
  }
}

// Placeholder class until we generate the real AppLocalizations
class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hi', 'kn', 'mr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations();

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
