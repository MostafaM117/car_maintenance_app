import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'models/firebase_options.dart';
import 'notifications/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotiService().initNotification();
  await Supabase.initialize(
      url: 'https://rqcercxrslptgjffolve.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJxY2VyY3hyc2xwdGdqZmZvbHZlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NDcxNjMsImV4cCI6MjA2MzEyMzE2M30.pbkTibeAAiRrFUyhK4A9An0qfISYLHsTo509ReKqTxw');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Warning: .env file not found. Proceeding without it.');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: AppColors.primaryText),
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            locale: languageProvider.currentLocale,
            home: const RedirectingPage(),
          );
        },
      ),
    );
  }
}
