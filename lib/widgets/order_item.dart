import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_cart/providers/orders.dart' as prov;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.order}) : super(key: key);

  final prov.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text("\$${widget.order.amount}"),
              subtitle: Text(
                  DateFormat('dd/MM/yy  hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                child: SizedBox(
                    height:
                        min(180, widget.order.products.length * 20.0 + 15.0),
                    child: ListView(
                        children: widget.order.products
                            .map((prod) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(prod.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                    Text('${prod.quantity}x   \$${prod.price}',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ],
                                ))
                            .toList())),
              )
          ],
        ));
  }
}
