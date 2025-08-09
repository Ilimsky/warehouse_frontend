import 'package:flutter/material.dart';
import 'package:warehouse_frontend/product.dart';
import 'package:warehouse_frontend/product_list_screen.dart';

import 'checkout_screen.dart';
import 'order_screen.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int _currentIndex = 0;
  final List<Product> _cartItems = [];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      ProductListScreen(
        onAddToCart: (product) {
          setState(() {
            _cartItems.add(product);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} added to cart')),
          );
        },
      ),
      const OrderScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Store'),
        actions: [
          if (_currentIndex == 0 && _cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(cartItems: _cartItems),
                  ),
                ).then((_) {
                  setState(() {
                    _cartItems.clear();
                  });
                });
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'My Orders',
          ),
        ],
      ),
    );
  }
}