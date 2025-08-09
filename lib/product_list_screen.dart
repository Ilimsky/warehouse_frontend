import 'package:flutter/material.dart';
import 'package:warehouse_frontend/product.dart';
import 'package:warehouse_frontend/product_card.dart';

import 'api_service.dart';

class ProductListScreen extends StatefulWidget {
  final Function(Product) onAddToCart;

  const ProductListScreen({required this.onAddToCart, Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureProducts = apiService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Product product = snapshot.data![index];
                return ProductCard(
                  product: product,
                  onAddToCart: () => widget.onAddToCart(product),
                );
              },
            );
          }
        },
      ),
    );
  }
}