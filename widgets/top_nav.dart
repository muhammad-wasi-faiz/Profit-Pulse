import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String highlight; // 'Home' | 'New Arrivals' | 'Products' | 'My Cart'
  final VoidCallback? onGetInTouch;
  final bool showLogoutIfLoggedIn;

  const AppTopBar({
    Key? key,
    this.highlight = '',
    this.onGetInTouch,
    this.showLogoutIfLoggedIn = false,
  }) : super(key: key);

  void _go(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name == route) return;
    Navigator.pushNamed(context, route);
  }

  Widget _navLink(BuildContext context, String text, String route, {bool selected = false}) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _go(context, route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? primary : Colors.black87,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final loggedIn = FirebaseAuth.instance.currentUser != null;

    Widget smallBtn(String text, VoidCallback onTap, {bool filled = false}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: filled ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: filled ? null : Border.all(color: Colors.black26),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: filled ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
      toolbarHeight: 72,
      leading: (showLogoutIfLoggedIn && loggedIn)
          ? GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.logout),
        ),
      )
          : GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _go(context, '/profile'),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.person_outline),
        ),
      ),
      titleSpacing: 0,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            _navLink(context, 'New Arrivals', '/products', selected: highlight == 'New Arrivals'),
            _navLink(context, 'Home', '/home', selected: highlight == 'Home'),
            _navLink(context, 'Products', '/products', selected: highlight == 'Products'),
            _navLink(context, 'My Cart', '/cart', selected: highlight == 'My Cart'),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (onGetInTouch != null) {
                  onGetInTouch!();
                } else {
                  _go(context, '/home');
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                child: Text(
                  'Get in Touch',
                  style: TextStyle(
                    color: highlight == 'Get in Touch' ? primary : Colors.black87,
                    fontWeight: highlight == 'Get in Touch' ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: loggedIn
          ? [const SizedBox(width: 12)]
          : [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: smallBtn('Sign-in', () => _go(context, '/login')),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 6),
          child: smallBtn('Sign-up', () => _go(context, '/signup'), filled: true),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}