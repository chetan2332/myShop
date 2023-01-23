import 'package:flutter/material.dart';
import 'package:my_cart/providers/auth.dart';
import 'package:my_cart/providers/cart.dart';
import 'package:my_cart/providers/orders.dart';
import 'package:my_cart/screens/auth_screen.dart';
import 'package:my_cart/screens/cart_screen.dart';
import 'package:my_cart/screens/edit_products_screen.dart';
import 'package:my_cart/screens/orders_screen.dart';
import 'package:my_cart/screens/user_produts_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_cart/screens/product_detail_screen.dart';
import 'package:my_cart/screens/product_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (BuildContext ctx) => Products(),
          update: (ctx, auth, previousProduct) => Products()
            ..update(auth.token.toString(),
                previousProduct == null ? [] : previousProduct.items),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Awesome Shopping App',
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
                fontFamily: 'Lato',
              ),
              home: auth.isAuth
                  ? const ProductsOverviewScreen()
                  : const AuthScreen(),
              // initialRoute: OrdersScreen.routeName,
              routes: {
                ProductsOverviewScreen.routeName: (ctx) =>
                    const ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (ctx) =>
                    const ProductDetailScreen(),
                CartScreen.routeName: (ctx) => const CartScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                UserProductsScreen.routeName: (ctx) =>
                    const UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => const EditProductScreen(),
                AuthScreen.routeName: (ctx) => const AuthScreen(),
              },
            )),
      ),
    );
  }
}
