import 'package:flutter/material.dart';
import 'package:lab2/screens/meal_detail_screen.dart';
import 'package:lab2/services/meal_detail_service.dart';

import '../models/category.dart';
import '../services/category_service.dart';
import '../widgets/category_card.dart';
import 'meals_screen.dart';
import 'favorites_screen.dart';
import 'notification_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoryService _service = CategoryService();
  List<Category> _allCategories = [];
  List<Category> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final categories = await _service.fetchCategories();
    setState(() {
      _allCategories = categories;
      _filtered = categories;
      _loading = false;
    });
  }

  void _searchCategory(String text) {
    setState(() {
      _filtered = _allCategories
          .where((c) => c.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Categories"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () async {
              final service = MealDetailService();
              final randomMeal = await service.fetchRandomMeal();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(
                    mealId: randomMeal.id,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search categories...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchCategory,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final category = _filtered[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealsScreen(
                          category: category.name,
                        ),
                      ),
                    );
                  },
                  child: CategoryCard(category: category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}