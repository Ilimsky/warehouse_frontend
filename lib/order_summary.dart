import 'package:flutter/material.dart';

import 'order.dart';

class OrderSummary extends StatelessWidget {
  final Order order;
  final bool showFullInfo;

  const OrderSummary({
    required this.order,
    this.showFullInfo = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order #${order.id}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(order.formattedDate),
          Text('Status: ${order.status}'),
          if (showFullInfo) ...[
            const SizedBox(height: 8),
            Text('Customer: ${order.customerName}'),
            Text('Phone: ${order.customerPhone}'),
            Text('Email: ${order.customerEmail}'),
            Text('Address: ${order.deliveryAddress}'),
          ],
          const SizedBox(height: 8),
          const Divider(),
          ...order.items.map(
                (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${item.productName} x${item.quantity}'),
                  Text('\$${(item.pricePerUnit * item.quantity).toStringAsFixed(2)}'),
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
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}