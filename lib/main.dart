import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/login.dart';
import 'screens/main_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MyAppState>()!;
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool darkModeEnabled = false;

  ThemeMode get themeMode =>
      darkModeEnabled ? ThemeMode.dark : ThemeMode.light;

  void updateTheme(bool isDark) {
    setState(() {
      darkModeEnabled = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Wallet',

      themeMode: themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FB),
          elevation: 0,
          foregroundColor: Colors.black,
        ),

        cardColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FC3F7),
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF0D1117),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1117),
          elevation: 0,
          foregroundColor: Colors.white,
        ),

        cardColor: const Color(0xFF161B22),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FC3F7),
          brightness: Brightness.dark,
        ),
      ),

      home: FirebaseAuth.instance.currentUser != null
          ? const MainNavScreen()
          : const LoginScreen(),
    );
  }
}