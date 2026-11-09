import 'package:flutter/material.dart';

import 'exercise_catalog.dart';
import 'food_catalog.dart';
import '../questionnaire/questionnaire_data.dart';

@immutable
class DiaryMeal {
  const DiaryMeal({
    required this.day,
    required this.slot,
    required this.name,
    required this.grams,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  final int day;
  final String slot;
  final String name;
  final int grams;
  final int calories;
  final int protein;
  final int fat;
  final int carbs;
}

class DemoDashboardStore extends ChangeNotifier {
  final List<DiaryMeal> _meals = [
    const DiaryMeal(
      day: 18,
      slot: 'Завтрак',
      name: 'Овсянка с ягодами',
      grams: 250,
      calories: 420,
      protein: 25,
      fat: 12,
      carbs: 50,
    ),
    const DiaryMeal(
      day: 18,
      slot: 'Обед',
      name: 'Курица с рисом',
      grams: 350,
      calories: 650,
      protein: 50,
      fat: 18,
      carbs: 70,
    ),
    const DiaryMeal(
      day: 18,
      slot: 'Перекус',
      name: 'Творог и банан',
      grams: 280,
      calories: 380,
      protein: 35,
      fat: 15,
      carbs: 40,
    ),
  ];

  static const calorieGoal = 2200;
  static const proteinGoal = 150;
  static const fatGoal = 60;
  static const carbsGoal = 250;

  double weightKg = 70.4;
  String profileName = 'Наризат';
  String profileEmail = '';
  String gender = 'Мужской';
  TrainingExperience experience = TrainingExperience.beginner;
  TrainingGoal goal = TrainingGoal.gainMass;
  TrainingLocation location = TrainingLocation.gym;
  int heightCm = 175;
  int ageYears = 24;
  int? bodyFatPercent;
  int hemoglobin = 138;
  final Set<String> healthRestrictions = {};
  double targetWeightKg = 74;
  int dailyCalorieGoal = 2200;
  bool automaticCalories = true;
  final Map<String, bool> reminders = {
    'Тренировка': true,
    'Завтрак': true,
    'Обед': false,
    'Ужин': true,
    'Вода': false,
    'Взвешивание': true,
  };
  ThemeMode themeMode = ThemeMode.dark;
  int selectedDay = 18;
  final List<Exercise> workout = List.of(demoExercises.take(6));
  String workoutSplit = 'Фулбади';
  int workoutDays = 3;
  int workoutMinutes = 45;
  final Set<int> completedExercises = {};
  final Map<int, Set<int>> completedSets = {};
  final List<FoodProduct> customProducts = [];
  bool workoutStarted = false;
  bool workoutFinished = false;

  List<DiaryMeal> mealsFor(int day) =>
      List.unmodifiable(_meals.where((meal) => meal.day == day));
  int caloriesFor(int day) =>
      mealsFor(day).fold(0, (sum, meal) => sum + meal.calories);
  int proteinFor(int day) =>
      mealsFor(day).fold(0, (sum, meal) => sum + meal.protein);
  int fatFor(int day) => mealsFor(day).fold(0, (sum, meal) => sum + meal.fat);
  int carbsFor(int day) =>
      mealsFor(day).fold(0, (sum, meal) => sum + meal.carbs);

  void selectDay(int day) {
    if (selectedDay == day) return;
    selectedDay = day;
    notifyListeners();
  }

  void setWeight(double kg) {
    weightKg = kg;
    notifyListeners();
  }

  void setProfile({required String name, required String email}) {
    profileName = name;
    profileEmail = email;
    notifyListeners();
  }

  void setBodyParameters({required int height, required int age, int? fat}) {
    heightCm = height;
    ageYears = age;
    bodyFatPercent = fat;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void refresh() => notifyListeners();

  void addMeal(DiaryMeal meal) {
    _meals.add(meal);
    notifyListeners();
  }

  void addCustomProduct(FoodProduct product) {
    customProducts.add(product);
    notifyListeners();
  }

  void replaceExercise(int index, Exercise exercise) {
    workout[index] = exercise;
    completedExercises.remove(index);
    completedSets.remove(index);
    notifyListeners();
  }

  void configureWorkout({
    required String split,
    required int days,
    required int minutes,
  }) {
    workoutSplit = split;
    workoutDays = days;
    workoutMinutes = minutes;
    workout
      ..clear()
      ..addAll(demoExercises.take(split == 'Фулбади' ? 6 : 5));
    completedSets.clear();
    completedExercises.clear();
    workoutStarted = false;
    workoutFinished = false;
    notifyListeners();
  }

  void addExercise(Exercise exercise) {
    if (workout.any((item) => item.name == exercise.name)) return;
    workout.add(exercise);
    notifyListeners();
  }

  void toggleWorkout() {
    if (workoutFinished) {
      workoutFinished = false;
      completedExercises.clear();
      completedSets.clear();
    }
    workoutStarted = !workoutStarted;
    if (!workoutStarted) workoutFinished = true;
    notifyListeners();
  }

  void toggleExercise(int index) {
    if (completedExercises.contains(index)) {
      completedExercises.remove(index);
    } else {
      completedExercises.add(index);
    }
    notifyListeners();
  }

  void toggleSet(int exerciseIndex, int setIndex, int setCount) {
    final sets = completedSets.putIfAbsent(exerciseIndex, () => <int>{});
    if (!sets.add(setIndex)) sets.remove(setIndex);
    if (sets.length == setCount) {
      completedExercises.add(exerciseIndex);
    } else {
      completedExercises.remove(exerciseIndex);
    }
    notifyListeners();
  }
}

class DemoDashboardScope extends InheritedNotifier<DemoDashboardStore> {
  const DemoDashboardScope({
    super.key,
    required DemoDashboardStore store,
    required super.child,
  }) : super(notifier: store);

  static DemoDashboardStore of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DemoDashboardScope>();
    assert(scope != null, 'DemoDashboardScope is missing');
    return scope!.notifier!;
  }
}
