import 'package:flutter/material.dart';
import 'package:warehouse_frontend/product.dart';

import 'api_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CheckoutScreen({required this.cartItems, Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  String customerName = '';
  String customerPhone = '';
  String customerEmail = '';
  String deliveryAddress = '';

  double get totalAmount {
    return widget.cartItems.fold(0, (sum, item) => sum + item.price);
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final order = await apiService.createOrder(
          customerName: customerName,
          customerPhone: customerPhone,
          customerEmail: customerEmail,
          deliveryAddress: deliveryAddress,
          items: widget.cartItems
              .map((item) => {
            'productId': item.id,
            'quantity': 1, // Assuming 1 quantity per item for simplicity
          })
              .toList(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заказ создан успешно!')),
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Customer Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => customerName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => customerPhone = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => customerEmail = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter delivery address';
                  }
                  return null;
                },
                onSaved: (value) => deliveryAddress = value!,
              ),
              const SizedBox(height: 24),
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...widget.cartItems.map(
                    (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.name),
                      Text('\$${item.price.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}