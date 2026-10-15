import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final Set<String> _favoriteProductIds = {};

  final List<String> _categories = [
    'All',
    'Audio',
    'Wearables',
    'Accessories',
    'Storage',
    'Cameras',
  ];

  List<Product> get _filteredProducts {
    return ProductRepository.sampleProducts.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _toggleFavorite(String productId) {
    setState(() {
      if (_favoriteProductIds.contains(productId)) {
        _favoriteProductIds.remove(productId);
      } else {
        _favoriteProductIds.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = CartManager.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront_outlined, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Text(
              'NovaStore',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ListenableBuilder(
            listenable: cart,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    tooltip: 'Cart',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (cart.totalItemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6366F1),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${cart.totalItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SearchBar(
              hintText: 'Search electronics, audio, accessories...',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(1),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),

          // Category Chips
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Product Grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No products found matching your search',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final isFav = _favoriteProductIds.contains(product.id);

                      return Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Visual Header with Icon
                              Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: product.themeColor.withValues(alpha: 0.12),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        product.icon,
                                        size: 54,
                                        color: product.themeColor,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: IconButton(
                                        icon: Icon(
                                          isFav ? Icons.favorite : Icons.favorite_border,
                                          color: isFav ? Colors.red : Colors.grey.shade600,
                                          size: 20,
                                        ),
                                        onPressed: () => _toggleFavorite(product.id),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.category.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, size: 14, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${product.rating}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          ' (${product.reviewsCount})',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF6366F1),
                                          ),
                                        ),
                                        IconButton.filledTonal(
                                          iconSize: 18,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                          icon: const Icon(Icons.add_shopping_cart),
                                          onPressed: () {
                                            cart.addProduct(product);
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Added ${product.title} to cart'),
                                                duration: const Duration(seconds: 1),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
