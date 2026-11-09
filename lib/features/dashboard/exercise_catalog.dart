import 'package:flutter/foundation.dart';

@immutable
class Exercise {
  const Exercise(
    this.name,
    this.category,
    this.equipment,
    this.difficulty,
    this.reps,
  );
  final String name;
  final String category;
  final String equipment;
  final int difficulty;
  final String reps;
}

const demoExercises = <Exercise>[
  Exercise('Жим лёжа', 'Грудь', 'штанга', 2, '4 x 10'),
  Exercise('Тяга верхнего блока', 'Спина', 'тренажёр', 1, '3 x 12'),
  Exercise('Приседания со штангой', 'Ноги', 'штанга', 3, '4 x 8'),
  Exercise('Жим гантелей сидя', 'Плечи', 'гантели', 2, '3 x 10'),
  Exercise('Планка', 'Пресс', 'без оборудования', 1, '3 x 45с'),
  Exercise('Отжимания', 'Грудь', 'без оборудования', 1, '3 x 12'),
  Exercise('Тяга гантели в наклоне', 'Спина', 'гантели', 2, '3 x 10'),
  Exercise('Выпады', 'Ноги', 'гантели', 2, '3 x 12'),
];
