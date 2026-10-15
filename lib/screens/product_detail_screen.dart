import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final cart = CartManager.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          ListenableBuilder(
            listenable: cart,
            builder: (context, _) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: cart.totalItemCount > 0,
                  label: Text('${cart.totalItemCount}'),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Big Hero Banner
            Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    product.themeColor.withValues(alpha: 0.25),
                    product.themeColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Icon(
                  product.icon,
                  size: 110,
                  color: product.themeColor,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.themeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        color: product.themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    product.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Price & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFF6366F1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            ' (${product.reviewsCount} reviews)',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Description
                  Text(
                    'Product Overview',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Feature badges
                  _buildFeatureTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'Free Express Shipping',
                    subtitle: 'Estimated delivery within 2-3 business days',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    icon: Icons.verified_user_outlined,
                    title: '2-Year Official Warranty',
                    subtitle: 'Full coverage for manufacturer defects and support',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureTile(
                    icon: Icons.replay_outlined,
                    title: '30-Day Hassle-Free Returns',
                    subtitle: 'Money-back guarantee if you are not fully satisfied',
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  Row(
                    children: [
                      Text(
                        'Quantity:',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                            ),
                            Text(
                              '$_quantity',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _quantity++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text('Add to Cart • \$${(product.price * _quantity).toStringAsFixed(2)}'),
                  onPressed: () {
                    for (int i = 0; i < _quantity; i++) {
                      cart.addProduct(product);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $_quantity × ${product.title} to cart'),
                        backgroundColor: Colors.green.shade700,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
