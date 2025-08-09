import 'package:flutter/material.dart';

import 'api_service.dart';
import 'order.dart';
import 'order_summary.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({Key? key}) : super(key: key);

  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
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

  Future<void> _updateOrderStatus(int orderId, String newStatus) async {
    try {
      await apiService.updateOrderStatus(orderId, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order status updated successfully')),
      );
      _refreshOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteOrder(int orderId) async {
    try {
      await apiService.deleteOrder(orderId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order deleted successfully')),
      );
      _refreshOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showStatusDialog(Order order) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedStatus = order.status as String?;

        return AlertDialog(
          title: const Text('Change Order Status'),
          content: DropdownButton<String>(
            value: selectedStatus,
            items: OrderStatus.values
                .map((status) => DropdownMenuItem(
              value: status.name,
              child: Text(status.name),
            ))
                .toList(),
            onChanged: (value) {
              selectedStatus = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedStatus != null && selectedStatus != order.status) {
                  _updateOrderStatus(order.id, selectedStatus!);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return const Center(child: Text('No orders found'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Order order = snapshot.data![index];
                  return Card(
                    child: Column(
                      children: [
                        OrderSummary(order: order),
                        ButtonBar(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showStatusDialog(order),
                              tooltip: 'Change status',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteOrder(order.id),
                              tooltip: 'Delete order',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}