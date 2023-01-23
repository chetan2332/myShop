import 'package:flutter/material.dart';
// import 'package:my_cart/providers/cart.dart' show Cart;
import 'package:my_cart/providers/cart.dart';
import 'package:my_cart/widgets/cart_item.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../providers/products.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<Products>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.item.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  Consumer<Products>(
                    builder: (_, value, child) =>
                        OrderButton(cart: cart, cartItems: cartItems),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (ctx, i) => CartItemWidget(
              cartItems[i].id,
              cartItems[i].price,
              cartItems[i].quantity,
              cartItems[i].title,
              cart.removeItem,
            ),
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
    required this.cartItems,
  }) : super(key: key);

  final Cart cart;
  final List<CartItem> cartItems;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false).addOrder(
                      widget.cartItems,
                      widget.cart.totalAmount,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cart.clear();
                  },
            child: const Text(
              "ORDER NOW",
              style: TextStyle(fontSize: 15),
            ),
          );
  }
}
