import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/routing/app_router.dart';
import 'package:kurukshetra/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kurukshetra/features/climate_technology/providers/climate_provider.dart';
import 'package:kurukshetra/features/climate_technology/providers/notification_provider.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Only set background handler on mobile and desktop platforms
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
    
    // Request notification permissions on web
    if (kIsWeb) {
      await FirebaseMessaging.instance.requestPermission();
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    // Wrap entire app in ProviderScope for Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Locale _resolveLocale(String language) {
    switch (language.trim().toLowerCase()) {
      case 'marathi':
      case 'मराठी':
      case 'mr':
      case 'mr_in':
      case 'mr-in':
        return const Locale('mr');
      case 'hindi':
      case 'हिन्दी':
      case 'हिंदी':
      case 'hi':
      case 'hi_in':
      case 'hi-in':
        return const Locale('hi');
      default:
        return const Locale('en');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fcmBootstrapProvider);
    ref.watch(climateWeatherProvider);

    final language = ref.watch(languageProvider);
    
    final locale = _resolveLocale(language);

    return MaterialApp.router(
      title: 'Kurukshetra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('mr'),
        Locale('hi'),
      ],
    );
  }
}
