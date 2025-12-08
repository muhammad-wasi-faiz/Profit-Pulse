import 'package:flutter/material.dart';
import 'package:practice/widgets/safe_image.dart';
import '../widgets/top_nav.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: const AppTopBar(highlight: 'My Cart'),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fs.cartStream(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Cart error: ${snap.error}'));
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('Your cart is empty'));

          final items = <Map<String, dynamic>>[];
          num total = 0;
          for (final d in docs) {
            final m = d.data();
            items.add(m);
            final price = (m['price'] is num) ? m['price'] as num : num.tryParse('${m['price']}') ?? 0;
            final qty = (m['qty'] is num) ? m['qty'] as num : num.tryParse('${m['qty'] ?? 1}') ?? 1;
            total += price * qty;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final m = items[i];
                    final title = (m['title'] ?? '').toString();
                    final img = (m['img'] ?? '').toString();
                    final price = (m['price'] ?? '').toString();

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SizedBox(height: 60, width: 80, child: SafeImage(url: img, fit: BoxFit.contain)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text('$price PKR'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text('Total: $total PKR', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkout', arguments: {'items': items, 'from': 'cart'});
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}