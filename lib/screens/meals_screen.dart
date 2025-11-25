import 'package:flutter/material.dart';
import 'package:lab2/screens/meal_detail_screen.dart';

import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/meal_grid_item.dart';

class MealsScreen extends StatefulWidget {
  final String category;

  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealService _service = MealService();

  List<Meal> _allMeals = [];
  List<Meal> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  void loadMeals() async {
    final meals = await _service.fetchMealsByCategory(widget.category);
    setState(() {
      _allMeals = meals;
      _filtered = meals;
      _loading = false;
    });
  }

  void _search(String text) async {
    if (text.isEmpty) {
      setState(() {
        _filtered = _allMeals;
      });
      return;
    }

    final results = await _service.searchMeals(text);

    // Filter results to only show meals from the same category
    setState(() {
      _filtered = results
          .where((m) => _allMeals.any((original) => original.id == m.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meals: ${widget.category}"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: "Search meals...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(
                          mealId: _filtered[index].id,
                        ),
                      ),
                    );
                  },
                  child: MealGridItem(meal: _filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}