import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  final _auth = AuthService();

// Use any background image URL you like (network works great on web)
  static const String bgUrl =
      'https://images.pexels.com/photos/27495834/pexels-photo-27495834.jpeg';

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      _show('Please enter email and password');
      return;
    }



    setState(() => loading = true);
    try {
      await _auth.signIn(email, pass);
      if (!mounted) return;
      // keep it simple: clear back stack
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? 'Login failed');
    } catch (e) {
      _show('Login failed');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
// SIMPLE SIZE CONTROLS (tweak these)
    final double cardWidth = 360; // make smaller/bigger to change width
    final double cardMinHeight = 360; // increase to make the box taller
    final double sidePadding = 16; // page padding on small screens



    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            bgUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) =>
            const Center(child: Text('Failed to load background')),
          ),

          // Make text readable over the image (a tiny bit "hard code" but simple)
          Container(color: Colors.black.withOpacity(0.35)),

          // Page content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 24),
              child: Container(
                width: cardWidth,
                constraints: BoxConstraints(minHeight: cardMinHeight),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Login to Enjoy Big Deals',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Email
                    CustomTextField(
                      controller: emailCtrl,
                      hintText: 'abc2@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),

                    // Password
                    CustomTextField(
                      controller: passCtrl,
                      hintText: 'at least 8 characters',
                      obscure: true,
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 16),

                    // Login button
                    CustomButton(
                      text: 'Login',
                      loading: loading,
                      onPressed: _login,
                    ),
                    const SizedBox(height: 16),

                    // Sign up link
                    Column(
                      children: [
                        const Text(
                          "Don't Have An Account?",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/signup'),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}