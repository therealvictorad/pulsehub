import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item_model.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<ItemModel>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => ItemModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }
}
