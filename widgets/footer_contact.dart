import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FooterContact extends StatefulWidget {
  const FooterContact({Key? key}) : super(key: key);

  @override
  State<FooterContact> createState() => _FooterContactState();
}

class _FooterContactState extends State<FooterContact> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final msg = messageCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
// slightly “hard” part: save to Firestore
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('feedback').add({
        'name': name,
        'email': email,
        'message': msg,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks! Feedback submitted.')),
      );
      nameCtrl.clear();
      emailCtrl.clear();
      messageCtrl.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not submit: $e')),
      );
    }
  }

  InputDecoration _deco(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black54),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  Widget _leftColumns() {
    TextStyle sh = const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
    TextStyle link = const TextStyle(fontSize: 16);

    Widget col(String title, List<String> items) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: sh),
            const SizedBox(height: 12),
            for (final t in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(t, style: link),
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Get In Touch', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
        const SizedBox(height: 24),
        Row(
          children: [
            col('INFORMATION', [
              'Online Order Tracking',
              'Size Chart',
              'Shipping Policy',
              'Returns & Exchange Policy',
              'Discount Policy',
              'Privacy Policy',
            ]),
            const SizedBox(width: 24),
            col('About Us', [
              'Our Story',
              'Terms & Conditions',
              'Contact Us',
              'FAQs',
            ]),
          ],
        ),
      ],
    );
  }

  Widget _rightForm() {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Give Feedback', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Name'),
                  const SizedBox(height: 8),
                  TextField(controller: nameCtrl, decoration: _deco('Enter Your Name')),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Email'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailCtrl,
                    decoration: _deco('Enter Your Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Your Message'),
        const SizedBox(height: 8),
        TextField(controller: messageCtrl, decoration: _deco('Enter Your Message'), maxLines: 6),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _submit,
            style: TextButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Submit Feedback'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 900;
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _leftColumns()),
                const SizedBox(width: 32),
                Expanded(child: _rightForm()),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _leftColumns(),
              const SizedBox(height: 24),
              _rightForm(),
            ],
          );
        },
      ),
    );
  }
}