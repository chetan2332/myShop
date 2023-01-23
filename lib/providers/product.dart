import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Future<void> toggleFavStatus() async {
    final url = Uri.https(
        'my-cart-ba874-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.patch(url, body: jsonEncode({'isFavorite': isFavorite}));
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
      // ignore: avoid_print
      print(error);
      rethrow;
    }
  }

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl});
}
