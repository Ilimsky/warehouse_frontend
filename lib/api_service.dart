import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse_frontend/product.dart';

import 'order.dart';

class ApiService {
  // static const String baseUrl = 'http://localhost:8090/api';
  static const String baseUrl = 'https://warehouse-z9ov.onrender.com/api';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Order> createOrder({
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String deliveryAddress,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerEmail': customerEmail,
        'deliveryAddress': deliveryAddress,
        'items': items,
      }),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<List<Order>> getOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'stockQuantity': product.stockQuantity,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'stockQuantity': product.stockQuantity,
      }),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product: ${response.body}');
    }
  }

  Future<Order> updateOrderStatus(int id, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/orders/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      return Order.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update order status: ${response.body}');
    }
  }

  Future<void> deleteOrder(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/orders/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete order: ${response.body}');
    }
  }

}