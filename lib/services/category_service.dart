import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoryService {
  final String url = "https://www.themealdb.com/api/json/v1/1/categories.php";

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categoriesJson = data['categories'];

      return categoriesJson
          .map((json) => Category.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}