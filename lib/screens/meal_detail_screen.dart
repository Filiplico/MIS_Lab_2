import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal_detail.dart';
import '../services/meal_detail_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealDetailService _service = MealDetailService();
  MealDetail? _mealDetail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  void loadMeal() async {
    final detail = await _service.fetchMealDetail(widget.mealId);
    setState(() {
      _mealDetail = detail;
      _loading = false;
    });
  }

  void _openYoutube(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Details"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(_mealDetail!.thumbnail),
            const SizedBox(height: 16),

            Text(
              _mealDetail!.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Instructions:",
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_mealDetail!.instructions),

            const SizedBox(height: 16),
            const Text(
              "Ingredients:",
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ..._mealDetail!.ingredients.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• ${item['ingredient']} - ${item['measure']}",
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            if (_mealDetail!.youtube != null &&
                _mealDetail!.youtube!.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => _openYoutube(_mealDetail!.youtube!),
                icon: const Icon(Icons.play_circle_fill),
                label: const Text("Watch on YouTube"),
              ),
          ],
        ),
      ),
    );
  }
}