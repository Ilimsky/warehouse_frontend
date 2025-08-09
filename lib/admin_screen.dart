import 'package:flutter/material.dart';
import 'package:warehouse_frontend/product_management_screen.dart';

import 'order_management_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProductManagementScreen(),
    const OrderManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Админ панель'),
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
            icon: Icon(Icons.inventory),
            label: 'Товары',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Заказы',
          ),
        ],
      ),
    );
  }
}