class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String? youtube;
  final List<Map<String, String>> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ingredientsList = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty &&
          ingredient != "") {
        ingredientsList.add({
          "ingredient": ingredient,
          "measure": measure ?? "",
        });
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'],
      youtube: json['strYoutube'],
      ingredients: ingredientsList,
    );
  }
}