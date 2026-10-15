import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartManager extends ChangeNotifier {
  static final CartManager instance = CartManager._internal();
  CartManager._internal();

  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shipping => subtotal > 100.0 || _items.isEmpty ? 0.0 : 12.0;

  double get tax => subtotal * 0.08;

  double get total => subtotal + shipping + tax;

  void addProduct(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
