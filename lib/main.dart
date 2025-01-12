import 'package:contact_manager/theme.dart';
import 'package:contact_manager/ui/screens/main/main_screen.dart';
import 'package:contact_manager/ui/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness? _brightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MaterialTheme theme = MaterialTheme();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: currentThemeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Contact Manager',
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
