import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/top_nav.dart';
import '../services/feedback_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  final GlobalKey _contactKey = GlobalKey();

  static const String heroUrl =
      'https://images.pexels.com/photos/15802365/pexels-photo-15802365.jpeg';

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  void _scrollToContact() {
    final ctx = _contactKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _submitFeedback() async {
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
      await context.read<FeedbackService>().submit(
        name: name,
        email: email,
        message: msg,
      );
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heroTitleSize = width > 900 ? 56.0 : (width > 600 ? 40.0 : 30.0);
    final heroSubSize = width > 900 ? 20.0 : 16.0;



    return Scaffold(
      appBar: AppTopBar(
        highlight: 'Home',
        onGetInTouch: _scrollToContact,
        showLogoutIfLoggedIn: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 520,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    heroUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.black26),
                  ),
                  Container(color: Colors.black.withOpacity(0.55)),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Your Steps, Your Story.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: heroTitleSize,
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Because every step tells a story. Discover the stories within at Shoe Mart.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: heroSubSize,
                              ),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/products'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(160, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Shop Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            Container(
              key: _contactKey,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth > 900;
                  final left = const _InfoColumns();
                  final right = _FeedbackForm(
                    nameCtrl: nameCtrl,
                    emailCtrl: emailCtrl,
                    messageCtrl: messageCtrl,
                    onSubmit: _submitFeedback,
                  );
                  if (wide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: left),
                        const SizedBox(width: 32),
                        Expanded(child: right),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      left,
                      const SizedBox(height: 24),
                      right,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoColumns extends StatelessWidget {
  const _InfoColumns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class _FeedbackForm extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController messageCtrl;
  final VoidCallback onSubmit;

  const _FeedbackForm({
    Key? key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.messageCtrl,
    required this.onSubmit,
  }) : super(key: key);

  InputDecoration _deco(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black54)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
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
        TextButton(
          onPressed: onSubmit,
          style: TextButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Submit Feedback'),
        ),
      ],
    );
  }
}