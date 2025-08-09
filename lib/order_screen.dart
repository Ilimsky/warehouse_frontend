import 'package:flutter/material.dart';

import 'api_service.dart';
import 'order.dart';
import 'order_summary.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Order>> futureOrders;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureOrders = apiService.getOrders();
  }

  Future<void> _refreshOrders() async {
    setState(() {
      futureOrders = apiService.getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: FutureBuilder<List<Order>>(
          future: futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No orders yet'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Order order = snapshot.data![index];
                  return OrderSummary(order: order);
                },
              );
            }
          },
        ),
      ),
    );
  }
}