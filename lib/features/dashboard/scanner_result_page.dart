import 'dart:math' as math;
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';
import 'food_plate.dart';
import 'scanner_components.dart';

@RoutePage()
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.day});
  final int day;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String _name = 'Курица с рисом\nи овощами';
  int _grams = 320;
  bool _flash = false;

  int _scaled(int value) => (value * _grams / 320).round();

  Future<void> _edit() async {
    var name = _name.replaceAll('\n', ' ');
    var gramsText = '$_grams';
    final result = await showDialog<({String name, int grams})>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: FormaColors.surface,
        title: Text('Исправить блюдо', style: DashboardStyle.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: name,
              onChanged: (value) => name = value,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextFormField(
              initialValue: gramsText,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => gramsText = value,
              decoration: const InputDecoration(labelText: 'Вес, г'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final grams = int.tryParse(gramsText);
              if (name.trim().isEmpty || grams == null || grams < 20) return;
              Navigator.pop(dialogContext, (name: name.trim(), grams: grams));
            },
            child: const Text('Готово'),
          ),
        ],
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _name = result.name;
        _grams = result.grams;
      });
    }
  }

  void _save() {
    final store = DemoDashboardScope.of(context);
    store.addMeal(
      DiaryMeal(
        day: widget.day,
        slot: store.mealsFor(widget.day).any((meal) => meal.slot == 'Ужин')
            ? 'Добавлено'
            : 'Ужин',
        name: _name.replaceAll('\n', ' '),
        grams: _grams,
        calories: _scaled(520),
        protein: _scaled(42),
        fat: _scaled(9),
        carbs: _scaled(58),
      ),
    );
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final panelHeight = math.min(572.0, constraints.maxHeight - 80);
          return Stack(
            children: [
              Positioned(
                top: 58,
                left: 0,
                right: 0,
                child: Center(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: CustomPaint(
                      size: const Size.square(278),
                      painter: FoodPlatePainter(showCorners: false),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 11,
                left: 24,
                right: 24,
                child: Row(
                  children: [
                    FormaRoundIconButton(
                      icon: Assets.icons.rotateCcw,
                      tooltip: 'Переснять',
                      dimension: 44,
                      onPressed: () => context.router.replace(
                        ScannerCameraRoute(day: widget.day),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Распознано',
                          style: DashboardStyle.body.copyWith(
                            color: FormaColors.accent,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    FormaRoundIconButton(
                      icon: Assets.icons.zap,
                      tooltip: 'Вспышка',
                      dimension: 44,
                      accented: _flash,
                      onPressed: () => setState(() => _flash = !_flash),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: panelHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: FormaColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 19, 24, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: DashboardStyle.title.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FormaColors.focusedLine,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'AI 86%',
                                style: DashboardStyle.body.copyWith(
                                  color: FormaColors.accent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Ужин · 3 ингредиента',
                          style: DashboardStyle.muted.copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.fromLTRB(20, 6, 6, 6),
                          decoration: BoxDecoration(
                            color: FormaColors.raised,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Вес порции',
                                  style: DashboardStyle.muted.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              ScannerPortionAction(
                                icon: Assets.icons.minus,
                                active: _grams > 20,
                                onTap: () => setState(
                                  () => _grams = math.max(20, _grams - 20),
                                ),
                              ),
                              SizedBox(
                                width: 84,
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '$_grams г',
                                      style: DashboardStyle.title.copyWith(
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ScannerPortionAction(
                                icon: Assets.icons.plus,
                                active: true,
                                accented: true,
                                onTap: () => setState(() => _grams += 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ScannerNutrient(
                              value: _scaled(520),
                              label: 'ккал',
                              color: FormaColors.text,
                            ),
                            const SizedBox(width: 6),
                            ScannerNutrient(
                              value: _scaled(42),
                              label: 'белки',
                              color: FormaColors.accent,
                            ),
                            const SizedBox(width: 6),
                            ScannerNutrient(
                              value: _scaled(9),
                              label: 'жиры',
                              color: FormaColors.text,
                            ),
                            const SizedBox(width: 6),
                            ScannerNutrient(
                              value: _scaled(58),
                              label: 'углеводы',
                              color: FormaColors.accentAlt,
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        Text(
                          'СОСТАВ',
                          style: DashboardStyle.muted.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        ScannerIngredient(
                          name: 'Куриная грудка',
                          grams: _scaled(130),
                        ),
                        ScannerIngredient(
                          name: 'Рис отварной',
                          grams: _scaled(140),
                        ),
                        ScannerIngredient(name: 'Брокколи', grams: _scaled(50)),
                        const SizedBox(height: 18),
                        Text(
                          'Вес определён примерно. Проверь его перед сохранением.',
                          style: DashboardStyle.muted.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        FormaPrimaryButton(
                          label: 'Сохранить в дневник',
                          trailingIcon: Assets.icons.check,
                          onPressed: _save,
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: TextButton(
                            onPressed: _edit,
                            child: Text(
                              'Исправить вручную',
                              style: DashboardStyle.muted.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
