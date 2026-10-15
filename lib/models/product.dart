import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int reviewsCount;
  final String category;
  final IconData icon;
  final Color themeColor;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    required this.icon,
    required this.themeColor,
  });
}

class ProductRepository {
  static const List<Product> sampleProducts = [
    Product(
      id: 'p1',
      title: 'Pro Wireless Headphones',
      description:
          'High-fidelity noise-cancelling over-ear headphones with 40-hour battery life, spatial audio, and quick USB-C charging.',
      price: 249.99,
      rating: 4.8,
      reviewsCount: 342,
      category: 'Audio',
      icon: Icons.headphones,
      themeColor: Color(0xFF6366F1),
    ),
    Product(
      id: 'p2',
      title: 'Ultra Smartwatch Gen 4',
      description:
          'Advanced health metrics tracking, GPS navigation, always-on AMOLED display, and 50m water resistance.',
      price: 329.00,
      rating: 4.7,
      reviewsCount: 512,
      category: 'Wearables',
      icon: Icons.watch,
      themeColor: Color(0xFF0EA5E9),
    ),
    Product(
      id: 'p3',
      title: 'Ergonomic Mechanical Keyboard',
      description:
          'Hot-swappable tactile switches, aluminum frame, customizable RGB backlighting, and Bluetooth multi-device pairing.',
      price: 139.50,
      rating: 4.9,
      reviewsCount: 189,
      category: 'Accessories',
      icon: Icons.keyboard,
      themeColor: Color(0xFF10B981),
    ),
    Product(
      id: 'p4',
      title: '4K Creator Webcam Pro',
      description:
          'Ultra HD 60fps streaming camera with dual stereo noise-reduction microphones and automated AI autofocus.',
      price: 99.99,
      rating: 4.6,
      reviewsCount: 120,
      category: 'Cameras',
      icon: Icons.videocam,
      themeColor: Color(0xFFF59E0B),
    ),
    Product(
      id: 'p5',
      title: 'Portable SSD 2TB Extreme',
      description:
          'Blazing fast NVMe read/write speeds up to 1050MB/s, rugged shock-resistant exterior, and hardware encryption.',
      price: 179.00,
      rating: 4.9,
      reviewsCount: 428,
      category: 'Storage',
      icon: Icons.storage,
      themeColor: Color(0xFFEC4899),
    ),
    Product(
      id: 'p6',
      title: 'Fast Wireless Charging Pad',
      description:
          '15W Qi-certified rapid inductive charging pad with temperature control and multi-device foreign object detection.',
      price: 34.99,
      rating: 4.5,
      reviewsCount: 275,
      category: 'Accessories',
      icon: Icons.battery_charging_full,
      themeColor: Color(0xFF8B5CF6),
    ),
  ];
}
