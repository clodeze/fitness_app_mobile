import 'package:flutter/foundation.dart';

@immutable
class BodyParameters {
  const BodyParameters({
    required this.weightKg,
    required this.heightCm,
    required this.ageYears,
    this.bodyFatPercent,
  });

  final int weightKg;
  final int heightCm;
  final int ageYears;
  final int? bodyFatPercent;
}

enum TrainingGoal {
  gainMass('Набор массы'),
  loseWeight('Похудение'),
  definition('Рельеф'),
  strength('Сила'),
  endurance('Выносливость');

  const TrainingGoal(this.label);
  final String label;
}

enum TrainingExperience {
  beginner('Я новичок'),
  some('Есть опыт'),
  pro('Профи');

  const TrainingExperience(this.label);
  final String label;
}

enum TrainingLocation {
  gym('В зале'),
  home('Дома');

  const TrainingLocation(this.label);
  final String label;
}
