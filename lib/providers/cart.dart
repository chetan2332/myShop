import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  late final int quantity;
  final double price;
  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get item {
    return {..._items};
  }

  int get itemCount {
    if (_items.isEmpty) {
      return 0;
    }
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += (cartItem.price * cartItem.quantity);
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // change the quantity...
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                price: existingCartItem.price,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                price: price,
                quantity: 1,
                title: title,
              ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((key, value) => key == id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    } else {
      if (_items[id]!.quantity > 1) {
        _items.update(
            id,
            (existingItem) => CartItem(
                id: id,
                title: existingItem.title,
                quantity: existingItem.quantity - 1,
                price: existingItem.price));
      } else {
        _items.remove(id);
      }
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
