import 'package:flutter/material.dart';
import '../widgets/safe_image.dart'; // <-- fix import path
import '../services/firestore_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final zipCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();
    final primary = Theme.of(context).colorScheme.primary;



// SAFE ARG PARSING
    final Object? raw = ModalRoute.of(context)?.settings.arguments;
    List<Map<String, dynamic>> items = [];
    String from = 'cart';
    if (raw is Map) {
      final rawItems = raw['items'];
      if (rawItems is List) {
        items = rawItems.whereType<Map>().map((m) => Map<String, dynamic>.from(m)).toList();
      }
      final f = raw['from'];
      if (f is String) from = f;
    }

    num total = 0;
    for (final m in items) {
      final price = (m['price'] is num) ? m['price'] as num : num.tryParse('${m['price']}') ?? 0;
      final qty = (m['qty'] is num) ? m['qty'] as num : num.tryParse('${m['qty'] ?? 1}') ?? 1;
      total += price * qty;
    }

    InputDecoration deco(String hint) => InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Ping Firestore',
            icon: const Icon(Icons.cloud_done_outlined),
            onPressed: () async {
              final r = await fs.ping(); // returns 'ok' or 'err: ...'
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Firestore: $r')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (items.isEmpty)
                  const Text('No items to checkout')
                else ...[
                  const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  for (final m in items) ...[
                    _itemTile(m),
                    const SizedBox(height: 8),
                  ],
                  Text('Total: $total PKR', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
                const SizedBox(height: 16),

                const Text('Shipping Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: TextField(controller: nameCtrl, decoration: deco('Full Name'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: phoneCtrl, decoration: deco('Phone Number'), keyboardType: TextInputType.phone)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(controller: addressCtrl, decoration: deco('Address')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TextField(controller: cityCtrl, decoration: deco('City'))),
                    const SizedBox(width: 12),
                    Expanded(child: TextField(controller: zipCtrl, decoration: deco('ZIP/Postal Code'), keyboardType: TextInputType.number)),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/cart'),
                      child: const Text('Back to Cart'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: items.isEmpty
                          ? null
                          : () async {
                        if (nameCtrl.text.trim().isEmpty ||
                            phoneCtrl.text.trim().isEmpty ||
                            addressCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill name, phone and address')),
                          );
                          return;
                        }
                        try {
                          await fs.createOrder(
                            items: items,
                            total: total,
                            shipping: {
                              'name': nameCtrl.text.trim(),
                              'phone': phoneCtrl.text.trim(),
                              'address': addressCtrl.text.trim(),
                              'city': cityCtrl.text.trim(),
                              'zip': zipCtrl.text.trim(),
                            },
                          );
                          if (from == 'cart') {
                            await fs.clearCart();
                          }
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order confirmed, thanks for shopping')),
                          );
                          Navigator.pushNamedAndRemoveUntil(context, '/products', (r) => false);
                        } catch (e) {
                          // shows exact error message from Firestore
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order failed: $e')));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
                      child: const Text('Confirm Order'),
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

  Widget _itemTile(Map<String, dynamic> m) {
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
  }
}


