import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/meal.dart';

class MealService {
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$category";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'];

      return meals.map((m) => Meal.fromJson(m)).toList();
    } else {
      throw Exception("Failed to load meals");
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url =
        "https://www.themealdb.com/api/json/v1/1/search.php?s=$query";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] == null) return []; // no results

      final List meals = data['meals'];
      return meals.map((m) => Meal.fromJson(m)).toList();
    } else {
      throw Exception("Failed to search meals");
    }
  }
}