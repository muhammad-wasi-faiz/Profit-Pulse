import 'package:flutter/material.dart';

class SafeImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width, height;

  const SafeImage({
    Key? key,
    this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  }) : super(key: key);

  bool get _valid {
    final u = url ?? '';
    if (u.isEmpty) return false;
    if (u.startsWith('images/')) return true; // local web assets (web/images/...)
    if (!u.startsWith('http')) return false;
// Block page links (not image files) that cause CORS issues on web
    if (u.contains('unsplash.com/photos/')) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_valid) {
      return const FittedBox(child: Icon(Icons.image_not_supported));
    }
    return Image.network(
        url!,
        fit: fit,
        width: width,
        height: height,
        filterQuality: FilterQuality.low,
        errorBuilder: (_, __, ___) => const FittedBox(child: Icon(Icons.image_not_supported)),
    );
  }
}