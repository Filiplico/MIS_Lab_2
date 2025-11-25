import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/meal_detail.dart';

class MealDetailService {
  // Fetch meal by ID
  Future<MealDetail> fetchMealDetail(String id) async {
    final url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meal = data['meals'][0];
      return MealDetail.fromJson(meal);
    } else {
      throw Exception("Failed to load meal details");
    }
  }

  // Fetch random meal
  Future<MealDetail> fetchRandomMeal() async {
    final url = "https://www.themealdb.com/api/json/v1/1/random.php";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meal = data['meals'][0];
      return MealDetail.fromJson(meal);
    } else {
      throw Exception("Failed to load random meal");
    }
  }
}