import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'theme/app_theme.dart';

import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/products.dart';
import 'screens/product_detail.dart';
import 'screens/cart.dart';
import 'screens/checkout.dart';
import 'screens/profile.dart';

import 'services/feedback_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Bootstrap());
}

class Bootstrap extends StatelessWidget {
  const Bootstrap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snap.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: Scaffold(
              body: Center(child: Text('Firebase init error: ${snap.error}')),
            ),
          );
        }



        return MultiProvider(
          providers: [
            Provider<FeedbackService>(create: (_) => FeedbackService()),
          ],
          child: const ShoeMartApp(),
        );
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
      theme: AppTheme.light,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/products': (context) => const ProductsScreen(),
        '/product': (context) => const ProductDetailScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfilePage(),
      },
      home: const SplashScreen(),
    );
  }
}