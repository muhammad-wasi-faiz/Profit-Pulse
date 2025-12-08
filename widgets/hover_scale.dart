import 'package:flutter/material.dart';

class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;

  const HoverScale({
    Key? key,
    required this.child,
    this.scale = 1.03,
    this.duration = const Duration(milliseconds: 150),
  }) : super(key: key);

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovered = false;
  bool _pressed = false;

  void _setPressed(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _pressed;



    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),   // needs an arg
      onExit: (_) => setState(() => _hovered = false),   // needs an arg
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        child: AnimatedScale(
          scale: active ? widget.scale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}