import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';
import 'food_analysis_service.dart';
import 'scanner_components.dart';

class FoodAnalysisConfirmationPage extends StatefulWidget {
  const FoodAnalysisConfirmationPage({
    super.key,
    required this.day,
    required this.imagePath,
    required this.analysis,
  });

  final int day;
  final String imagePath;
  final FoodAnalysis analysis;

  @override
  State<FoodAnalysisConfirmationPage> createState() =>
      _FoodAnalysisConfirmationPageState();
}

class _FoodAnalysisConfirmationPageState
    extends State<FoodAnalysisConfirmationPage> {
  late int _grams = widget.analysis.weightGrams;

  int _scaled(double value) =>
      (value * _grams / widget.analysis.weightGrams).round();

  Future<void> _editWeight() async {
    var value = '$_grams';
    final formKey = GlobalKey<FormState>();
    final grams = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: FormaColors.surface,
        title: Text('Вес порции', style: DashboardStyle.title),
        content: Form(
          key: formKey,
          child: TextFormField(
            autofocus: true,
            initialValue: value,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Вес в граммах',
              suffixText: 'г',
            ),
            onChanged: (newValue) => value = newValue,
            validator: (input) {
              final parsed = int.tryParse(input ?? '');
              if (parsed == null || parsed < 1 || parsed > 10000) {
                return 'Введите число от 1 до 10 000 г';
              }
              return null;
            },
            onFieldSubmitted: (_) => _submitWeight(
              dialogContext,
              formKey,
              value,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () =>
                _submitWeight(dialogContext, formKey, value),
            child: const Text('Готово'),
          ),
        ],
      ),
    );
    if (grams != null && mounted) {
      setState(() => _grams = grams);
    }
  }

  void _submitWeight(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String value,
  ) {
    if (formKey.currentState?.validate() != true) return;
    Navigator.pop(context, int.parse(value));
  }

  void _save() {
    final store = DemoDashboardScope.of(context);
    store.addMeal(
      DiaryMeal(
        day: widget.day,
        slot: store.mealsFor(widget.day).any((meal) => meal.slot == 'Ужин')
            ? 'Добавлено'
            : 'Ужин',
        name: widget.analysis.name,
        grams: _grams,
        calories: _scaled(widget.analysis.calories),
        protein: _scaled(widget.analysis.protein),
        fat: _scaled(widget.analysis.fat),
        carbs: _scaled(widget.analysis.carbs),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                FormaRoundIconButton(
                  icon: Assets.icons.arrowLeft,
                  tooltip: 'Назад',
                  dimension: 44,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    'ПРОВЕРЬ БЛЮДО',
                    textAlign: TextAlign.center,
                    style: DashboardStyle.small.copyWith(fontSize: 11),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: kIsWeb
                      ? Image.network(
                          widget.imagePath,
                          height: 230,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            height: 230,
                            color: FormaColors.raised,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: FormaColors.muted,
                            ),
                          ),
                        )
                      : Image.file(
                          File(widget.imagePath),
                          height: 230,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            height: 230,
                            color: FormaColors.raised,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: FormaColors.muted,
                            ),
                          ),
                        ),
                ),
                if (widget.analysis.isDemo) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FormaColors.raised,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: FormaColors.focusedLine),
                    ),
                    child: Text(
                      'ДЕМО: это пример распознавания. Данные не получены '
                      'из фото и не отражают состав блюда.',
                      style: DashboardStyle.muted.copyWith(fontSize: 12),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.analysis.name,
                        style: DashboardStyle.title.copyWith(fontSize: 21),
                      ),
                    ),
                    if (widget.analysis.confidence case final confidence?)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: FormaColors.focusedLine),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'AI ${(confidence * 100).round()}%',
                          style: DashboardStyle.body.copyWith(
                            color: FormaColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 58,
                  padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
                  decoration: BoxDecoration(
                    color: FormaColors.raised,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Вес порции',
                          style: DashboardStyle.muted.copyWith(fontSize: 14),
                        ),
                      ),
                      ScannerPortionAction(
                        icon: Assets.icons.minus,
                        active: _grams > 1,
                        onTap: () => setState(
                          () => _grams = math.max(1, _grams - 10).toInt(),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: TextButton(
                          onPressed: _editWeight,
                          child: Text(
                            '$_grams г',
                            style: DashboardStyle.title.copyWith(fontSize: 18),
                          ),
                        ),
                      ),
                      ScannerPortionAction(
                        icon: Assets.icons.plus,
                        active: _grams < 10000,
                        accented: true,
                        onTap: () => setState(
                          () => _grams = math.min(10000, _grams + 10).toInt(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ScannerNutrient(
                      value: _scaled(widget.analysis.calories),
                      label: 'ккал',
                      color: FormaColors.text,
                    ),
                    const SizedBox(width: 6),
                    ScannerNutrient(
                      value: _scaled(widget.analysis.protein),
                      label: 'белки',
                      color: FormaColors.accent,
                    ),
                    const SizedBox(width: 6),
                    ScannerNutrient(
                      value: _scaled(widget.analysis.fat),
                      label: 'жиры',
                      color: FormaColors.text,
                    ),
                    const SizedBox(width: 6),
                    ScannerNutrient(
                      value: _scaled(widget.analysis.carbs),
                      label: 'углеводы',
                      color: FormaColors.accentAlt,
                    ),
                  ],
                ),
                if (widget.analysis.ingredients.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    'СОСТАВ',
                    style: DashboardStyle.muted.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  for (final ingredient in widget.analysis.ingredients)
                    ScannerIngredient(
                      name: ingredient.name,
                      grams: _scaled(ingredient.grams.toDouble()),
                    ),
                ],
                const SizedBox(height: 18),
                Text(
                  'Проверь распознанное блюдо и примерный вес перед сохранением.',
                  style: DashboardStyle.muted.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 14),
                FormaPrimaryButton(
                  label: 'Сохранить в дневник',
                  trailingIcon: Assets.icons.check,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
