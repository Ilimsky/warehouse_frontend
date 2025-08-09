import 'package:flutter/material.dart';
import 'package:warehouse_frontend/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function()? onAddToCart;

  const ProductCard({
    required this.product,
    this.onAddToCart,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Stock: ${product.stockQuantity}'),
              ],
            ),
            if (onAddToCart != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onAddToCart,
                child: const Text('Add to Cart'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}