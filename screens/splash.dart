import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 2 seconds, then decide where to go.
    Future.delayed(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 72, color: p),
            const SizedBox(height: 12),
            const Text(
              'Shoe Mart',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}