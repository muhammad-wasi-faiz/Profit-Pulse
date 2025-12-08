import 'package:flutter/material.dart';
import 'package:practice/widgets/safe_image.dart';
import '../widgets/top_nav.dart';
import '../services/firestore_service.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final fs = FirestoreService();

    // safe args parsing (web-safe)
    final Object? raw = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic>? p;
    if (raw is Map) {
      p = Map<String, dynamic>.from(raw);
    }

    if (p == null) {
      return Scaffold(
        appBar: const AppTopBar(highlight: 'Products'),
        body: const Center(child: Text('No product data')),
      );
    }

    final title = (p['title'] ?? '').toString();
    final img = (p['img'] ?? '').toString();
    final oldPrice = p['old'];
    final price = p['price'];
    final discount = (p['discount'] ?? '').toString();

    return Scaffold(
      appBar: const AppTopBar(highlight: 'Products'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: SafeImage(url: img, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 16),
                Text(title.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$oldPrice PKR',
                      style: const TextStyle(fontSize: 14, color: Colors.black54, decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$price PKR',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary),
                    ),
                    const SizedBox(width: 8),
                    Text(discount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primary)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/checkout',
                            arguments: {'items': [p!], 'from': 'buy'},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Buy Now'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          try {
                            await fs.addToCart(p!);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add failed: $e')));
                          }
                        },
                        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}