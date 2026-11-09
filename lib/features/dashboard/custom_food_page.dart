import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'food_catalog.dart';
import 'food_widgets.dart';

@RoutePage()
class CustomFoodPage extends StatefulWidget {
  const CustomFoodPage({super.key});

  @override
  State<CustomFoodPage> createState() => _CustomFoodPageState();
}

class _CustomFoodPageState extends State<CustomFoodPage> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Крупы';
  String _name = '';
  int _calories = 0;
  double _protein = 0;
  double _fat = 0;
  double _carbs = 0;
  int _portion = 100;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    context.router.pop(
      FoodProduct(
        _name,
        _category,
        _calories,
        _protein,
        _fat,
        _carbs,
        _portion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          children: [
            Row(
              children: [
                FormaRoundIconButton(
                  icon: Assets.icons.arrowLeft,
                  tooltip: 'Назад',
                  dimension: 44,
                  onPressed: () => context.router.maybePop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Свой продукт',
                      style: DashboardStyle.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Укажи значения с упаковки на 100 г. Продукт сохранится в твоей базе.',
                      style: DashboardStyle.muted,
                    ),
                    const SizedBox(height: 20),
                    _label('НАЗВАНИЕ'),
                    const SizedBox(height: 8),
                    _field(
                      'Название продукта',
                      onSaved: (v) => _name = v!.trim(),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Укажи название'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _label('КАТЕГОРИЯ'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final category in const [
                          'Крупы',
                          'Молочное',
                          'Снеки',
                          'Напитки',
                          'Мясо и птица',
                          'Рыба',
                          'Овощи',
                        ])
                          SizedBox(
                            height: 38,
                            child: FoodCategoryChip(
                              label: category,
                              selected: _category == category,
                              onTap: () => setState(() => _category = category),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _numberField(
                            'КАЛОРИИ',
                            'ккал',
                            (v) => _calories = v.round(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _numberField(
                            'БЕЛКИ',
                            'г',
                            (v) => _protein = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _numberField('ЖИРЫ', 'г', (v) => _fat = v),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _numberField(
                            'УГЛЕВОДЫ',
                            'г',
                            (v) => _carbs = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _numberField(
                      'ВЕС ОДНОЙ ПОРЦИИ',
                      'г',
                      (v) => _portion = v.round(),
                      positive: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FormaPrimaryButton(
              label: 'Сохранить продукт',
              trailingIcon: Assets.icons.check,
              onPressed: _save,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _label(String value) => Text(value, style: DashboardStyle.small);

  Widget _field(
    String hint, {
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    String? suffix,
  }) => TextFormField(
    style: DashboardStyle.body.copyWith(fontSize: 17),
    keyboardType: keyboardType,
    inputFormatters: formatters,
    validator: validator,
    onSaved: onSaved,
    decoration: InputDecoration(
      hintText: hint,
      suffixText: suffix,
      filled: true,
      fillColor: FormaColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: FormaColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: FormaColors.line),
      ),
    ),
  );

  Widget _numberField(
    String label,
    String unit,
    ValueChanged<double> onSaved, {
    bool positive = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _label(label),
      const SizedBox(height: 8),
      _field(
        '0',
        suffix: unit,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
        validator: (value) {
          final number = double.tryParse((value ?? '').replaceAll(',', '.'));
          if (number == null || number < 0 || positive && number == 0) {
            return 'Укажи число';
          }
          return null;
        },
        onSaved: (value) => onSaved(double.parse(value!.replaceAll(',', '.'))),
      ),
    ],
  );
}
