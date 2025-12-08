import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  bool loading = false;

  final _auth = AuthService();

// Simple background (network works great on web)
  static const String bgUrl =
      'https://unsplash.com/photos/a-bridal-bouquet-and-wedding-shoes-on-the-beach-ZjsItdlizSA';

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final confirm = confirmCtrl.text.trim();


// basic checks
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      _show('Please fill all fields');
      return;
    }
    if (pass.length < 8) {
      _show('Password must be at least 8 characters');
      return;
    }
    if (pass != confirm) {
      _show('Passwords do not match');
      return;
    }

    setState(() => loading = true);
    try {
      await _auth.signUp(email, pass);
      if (!mounted) return;
      // clear back stack and go home
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? 'Signup failed');
    } catch (e) {
      _show('Signup failed');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
// SIMPLE SIZE CONTROLS — change these if you want
    final double cardWidth = 360; // box width
    final double cardMinHeight = 280; // box height (min)
    final double sidePadding = 16; // page padding on small screens

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            bgUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) =>
            const Center(child: Text('Failed to load background')),
          ),
          // subtle dark overlay so text is readable
          Container(color: Colors.black.withOpacity(0.35)),

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
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Join to Enjoy Big Deals',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: emailCtrl,
                      hintText: 'abc2@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      controller: passCtrl,
                      hintText: 'at least 8 characters',
                      obscure: true,
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      controller: confirmCtrl,
                      hintText: 'confirm password',
                      obscure: true,
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 16),

                    CustomButton(
                      text: 'Sign Up',
                      loading: loading,
                      onPressed: _signup,
                    ),
                    const SizedBox(height: 16),

                    Column(
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: Text(
                            'Log in',
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