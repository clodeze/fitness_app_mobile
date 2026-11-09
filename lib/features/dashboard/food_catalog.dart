import 'package:flutter/foundation.dart';

@immutable
class FoodProduct {
  const FoodProduct(
    this.name,
    this.category,
    this.calories,
    this.protein,
    this.fat,
    this.carbs, [
    this.portionGrams = 100,
  ]);

  final String name;
  final String category;
  final int calories;
  final double protein;
  final double fat;
  final double carbs;
  final int portionGrams;
}

const sampleProducts = <FoodProduct>[
  FoodProduct('Гречка варёная', 'Крупы', 132, 4.5, 1.6, 25),
  FoodProduct('Гречневая каша на молоке', 'Крупы', 104, 4.2, 2.5, 17),
  FoodProduct('Гречка со сливочным маслом', 'Крупы', 132, 4.5, 1.6, 25),
  FoodProduct('Рис отварной', 'Крупы', 130, 2.7, 0.3, 28),
  FoodProduct('Куриная грудка', 'Мясо и птица', 165, 31, 3.6, 0),
  FoodProduct('Яйцо', 'Мясо и птица', 155, 13, 11, 1),
  FoodProduct('Лосось', 'Рыба', 208, 20, 13, 0),
  FoodProduct('Брокколи', 'Овощи', 34, 2.8, 0.4, 7),
];
