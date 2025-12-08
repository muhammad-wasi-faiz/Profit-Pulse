import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart'; // from flutterfire configure
import 'theme/app_theme.dart';  // remove if you don’t use it

import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';

import 'screens/profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Bootstrap());
}

class Bootstrap extends StatelessWidget {
  const Bootstrap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        if (snap.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: Scaffold(body: Center(child: Text('Firebase init error: ${snap.error}'))),
          );
        }
        return const ShoeMartApp();
      },
    );
  }
}

class ShoeMartApp extends StatelessWidget {
  const ShoeMartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoe Mart',
      theme: AppTheme.light, // or ThemeData.light() if you prefer
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),

        '/profile': (context) => const ProfilePage(),
      },
      home: const SplashScreen(),
    );
  }
}