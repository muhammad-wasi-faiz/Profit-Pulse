import 'package:flutter/material.dart';
import '../widgets/hover_scale.dart';
import '../widgets/top_nav.dart';
import '../widgets/footer_contact.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  // Simple sample data (network images so it works on web)
  List<Map<String, dynamic>> get products => [
    {
      'title': 'Cream Textured Strip Court Shoes for Women',
      'img': 'https://images.pexels.com/photos/19279700/pexels-photo-19279700.jpeg',
      'old': 6000,
      'price': 4000,
      'discount': 'SAVE 33%',
    },
    {
      'title': 'White Strip Court Shoes for Women',
      'img': 'https://images.pexels.com/photos/10178355/pexels-photo-10178355.jpeg',
      'old': 2500,
      'price': 2000,
      'discount': 'SAVE 20%',
    },
    {
      'title': 'White Open Step Heel for Women',
      'img': 'https://images.pexels.com/photos/10257094/pexels-photo-10257094.jpeg',
      'old': 5000,
      'price': 3500,
      'discount': 'SAVE 30%',
    },
    {
      'title': 'Flat Open-Sided Pumps for Women',
      'img': 'https://images.pexels.com/photos/10743776/pexels-photo-10743776.jpeg',
      'old': 4000,
      'price': 2500,
      'discount': 'SAVE 37.5%',
    },
    {
      'title': 'Pearl Court Shoes for Women-Wedding Edition',
      'img': 'https://images.pexels.com/photos/33140484/pexels-photo-33140484.jpeg',
      'old': 4000,
      'price': 2500,
      'discount': 'SAVE 37.5%',
    },
    {
      'title': 'Stylish Open Toe Block Heel for Women',
      'img': 'https://images.pexels.com/photos/4886941/pexels-photo-4886941.jpeg',
      'old': 5000,
      'price': 2500,
      'discount': 'SAVE 50%',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;



    Widget productCard(Map p) {
      return InkWell(
        onTap: () => Navigator.pushNamed(context, '/product', arguments: p),
        child: HoverScale(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8),
                      child: Image.network(
                        p['img'],
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p['title'].toString().toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${p['old']} PKR',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${p['price']} PKR',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            p['discount'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const AppTopBar(highlight: 'Products'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New Arrivals',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LayoutBuilder(
                builder: (context, c) {
                  int cross = 1;
                  if (c.maxWidth > 1100) cross = 3;
                  else if (c.maxWidth > 700) cross = 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 340, // fixed card height; tweak if needed
                    ),
                    itemBuilder: (context, i) => productCard(products[i]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
