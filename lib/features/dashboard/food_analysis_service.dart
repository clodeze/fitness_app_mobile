import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FoodIngredient {
  const FoodIngredient({required this.name, required this.grams});

  final String name;
  final int grams;
}

class FoodAnalysis {
  const FoodAnalysis({
    required this.name,
    required this.weightGrams,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.ingredients,
    this.confidence,
    this.isDemo = false,
  });

  final String name;
  final int weightGrams;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double? confidence;
  final List<FoodIngredient> ingredients;
  final bool isDemo;

  static FoodAnalysis demo() => const FoodAnalysis(
    name: 'Курица с рисом и овощами',
    weightGrams: 320,
    calories: 520,
    protein: 42,
    fat: 9,
    carbs: 58,
    confidence: 0.86,
    isDemo: true,
    ingredients: [
      FoodIngredient(name: 'Куриная грудка', grams: 130),
      FoodIngredient(name: 'Рис отварной', grams: 140),
      FoodIngredient(name: 'Брокколи', grams: 50),
    ],
  );

  factory FoodAnalysis.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final weightGrams = json['weight_grams'];
    final ingredientsJson = json['ingredients'];
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Missing dish name.');
    }
    if (weightGrams is! num ||
        !weightGrams.isFinite ||
        weightGrams < 1 ||
        weightGrams > 10000) {
      throw const FormatException('Invalid portion weight.');
    }

    final ingredients = <FoodIngredient>[];
    if (ingredientsJson != null) {
      if (ingredientsJson is! List) {
        throw const FormatException('Invalid ingredients.');
      }
      for (final ingredient in ingredientsJson) {
        if (ingredient is! Map<String, dynamic> ||
            ingredient['name'] is! String ||
            ingredient['grams'] is! num ||
            !(ingredient['grams'] as num).isFinite ||
            (ingredient['grams'] as num) < 0 ||
            (ingredient['name'] as String).trim().isEmpty) {
          throw const FormatException('Invalid ingredient details.');
        }
        ingredients.add(
          FoodIngredient(
            name: (ingredient['name'] as String).trim(),
            grams: (ingredient['grams'] as num).round(),
          ),
        );
      }
    }

    final confidence = json['confidence'];
    if (confidence != null &&
        (confidence is! num ||
            !confidence.isFinite ||
            confidence < 0 ||
            confidence > 1)) {
      throw const FormatException('Invalid confidence.');
    }

    return FoodAnalysis(
      name: name.trim(),
      weightGrams: weightGrams.round(),
      calories: _requiredNumber(json, 'calories'),
      protein: _requiredNumber(json, 'protein'),
      fat: _requiredNumber(json, 'fat'),
      carbs: _requiredNumber(json, 'carbs'),
      confidence: (confidence as num?)?.toDouble(),
      ingredients: List.unmodifiable(ingredients),
    );
  }

  static double _requiredNumber(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! num || !value.isFinite || value < 0) {
      throw FormatException('Invalid $key value.');
    }
    return value.toDouble();
  }
}

class FoodAnalysisException implements Exception {
  const FoodAnalysisException(this.message);

  final String message;

  @override
  String toString() => message;
}

class FoodAnalysisService {
  const FoodAnalysisService({this.endpoint = defaultEndpoint});

  static const defaultEndpoint = String.fromEnvironment('FOOD_ANALYSIS_URL');
  final String endpoint;

  Future<FoodAnalysis> analyze(XFile image) async {
    final configuredEndpoint = endpoint.trim();
    if (configuredEndpoint.isEmpty) {
      return FoodAnalysis.demo();
    }

    final uri = Uri.tryParse(configuredEndpoint);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty) {
      throw const FoodAnalysisException(
        'Адрес сервера распознавания задан неверно.',
      );
    }

    final client = http.Client();
    try {
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));
      final streamedResponse = await client
          .send(request)
          .timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(
        streamedResponse,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw FoodAnalysisException(
          'Сервер распознавания вернул ошибку (${response.statusCode}).',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid analysis response.');
      }
      return FoodAnalysis.fromJson(decoded);
    } on http.ClientException {
      throw const FoodAnalysisException(
        'Не удалось подключиться к серверу распознавания.',
      );
    } finally {
      client.close();
    }
  }
}
