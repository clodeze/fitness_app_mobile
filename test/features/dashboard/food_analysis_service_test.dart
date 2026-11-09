import 'package:fitness_trainer/features/dashboard/food_analysis_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  test('uses clearly marked sample recognition without an API', () async {
    final analysis = await const FoodAnalysisService(
      endpoint: '',
    ).analyze(XFile('sample.jpg'));

    expect(analysis.isDemo, isTrue);
    expect(analysis.name, 'Курица с рисом и овощами');
    expect(analysis.weightGrams, 320);
    expect(analysis.ingredients, hasLength(3));
  });

  test('parses a dish analysis returned by the API', () {
    final analysis = FoodAnalysis.fromJson({
      'name': 'Курица с рисом',
      'weight_grams': 320,
      'calories': 520,
      'protein': 42,
      'fat': 9,
      'carbs': 58,
      'confidence': 0.86,
      'ingredients': [
        {'name': 'Куриная грудка', 'grams': 130},
      ],
    });

    expect(analysis.name, 'Курица с рисом');
    expect(analysis.weightGrams, 320);
    expect(analysis.calories, 520);
    expect(analysis.confidence, 0.86);
    expect(analysis.ingredients.single.name, 'Куриная грудка');
    expect(analysis.ingredients.single.grams, 130);
  });

  test('rejects an invalid portion weight', () {
    expect(
      () => FoodAnalysis.fromJson({
        'name': 'Блюдо',
        'weight_grams': 0,
        'calories': 100,
        'protein': 10,
        'fat': 5,
        'carbs': 15,
      }),
      throwsA(isA<FormatException>()),
    );
  });
}
