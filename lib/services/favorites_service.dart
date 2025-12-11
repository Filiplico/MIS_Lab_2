import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_meals';

  Future<List<Meal>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    
    return favoritesJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Meal.fromJson(map);
    }).toList();
  }

  Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.any((meal) => meal.id == mealId);
  }

  Future<void> addFavorite(Meal meal) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (favorites.any((m) => m.id == meal.id)) {
      return;
    }
    
    favorites.add(meal);
    final favoritesJson = favorites.map((m) => jsonEncode({
      'idMeal': m.id,
      'strMeal': m.name,
      'strMealThumb': m.thumbnail,
    })).toList();
    
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.removeWhere((meal) => meal.id == mealId);
    final favoritesJson = favorites.map((m) => jsonEncode({
      'idMeal': m.id,
      'strMeal': m.name,
      'strMealThumb': m.thumbnail,
    })).toList();
    
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  Future<void> toggleFavorite(Meal meal) async {
    final isFav = await isFavorite(meal.id);
    if (isFav) {
      await removeFavorite(meal.id);
    } else {
      await addFavorite(meal);
    }
  }
}

