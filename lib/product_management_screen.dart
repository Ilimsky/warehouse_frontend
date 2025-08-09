import 'package:flutter/material.dart';
import 'edit_product_screen.dart';
import 'product.dart';
import 'api_service.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  late Future<List<Product>> futureProducts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureProducts = apiService.getProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      futureProducts = apiService.getProducts();
    });
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await apiService.deleteProduct(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
      _refreshProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _navigateToEditProduct(BuildContext context, Product? product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    );

    if (result == true) {
      _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToEditProduct(context, null),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Product>>(
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
                  return Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)} - Stock: ${product.stockQuantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _navigateToEditProduct(context, product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(product.id),
                          ),
                        ],
                      ),
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