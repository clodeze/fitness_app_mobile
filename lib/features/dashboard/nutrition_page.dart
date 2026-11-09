import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'dashboard_format.dart';
import 'demo_dashboard_store.dart';

@RoutePage()
class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  void _openScanner(BuildContext context, int day) =>
      context.router.root.push(ScannerCameraRoute(day: day));

  void _addFood(BuildContext context, int day, String slot) =>
      context.router.root.push(AddFoodRoute(day: day, initialSlot: slot));

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    final day = store.selectedDay;
    final meals = store.mealsFor(day);
    final calories = store.caloriesFor(day);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Питание', style: DashboardStyle.title),
              Text(
                'ОКТЯБРЬ 2026',
                style: DashboardStyle.small.copyWith(fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              for (var index = 0; index < 7; index++)
                Expanded(
                  child: _DayChoice(
                    label: const [
                      'Пн',
                      'Вт',
                      'Ср',
                      'Чт',
                      'Пт',
                      'Сб',
                      'Вс',
                    ][index],
                    day: index + 12,
                    selected: day == index + 12,
                    onTap: () => store.selectDay(index + 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatThousands(calories),
                    style: DashboardStyle.metric.copyWith(fontSize: 44),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  '/ ${formatThousands(store.dailyCalorieGoal)} ккал',
                  style: DashboardStyle.muted.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (calories / store.dailyCalorieGoal).clamp(0, 1),
              minHeight: 8,
              backgroundColor: FormaColors.line,
              valueColor: const AlwaysStoppedAnimation(FormaColors.accent),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MacroLine(
                letter: 'Б',
                current: store.proteinFor(day),
                goal: DemoDashboardStore.proteinGoal,
                color: FormaColors.accent,
              ),
              _MacroLine(
                letter: 'Ж',
                current: store.fatFor(day),
                goal: DemoDashboardStore.fatGoal,
                color: const Color(0xFF9ED3DF),
              ),
              _MacroLine(
                letter: 'У',
                current: store.carbsFor(day),
                goal: DemoDashboardStore.carbsGoal,
                color: FormaColors.accentAlt,
              ),
            ],
          ),
          const SizedBox(height: 19),
          Material(
            color: FormaColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: FormaColors.focusedLine),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => _openScanner(context, day),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: FormaColors.accent,
                      child: FormaIcon(
                        glyph: Assets.icons.camera,
                        color: FormaColors.ink,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Сканировать блюдо',
                            style: DashboardStyle.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Вес и КБЖУ по фото',
                            style: DashboardStyle.muted,
                          ),
                        ],
                      ),
                    ),
                    FormaIcon(
                      glyph: Assets.icons.arrowRight,
                      color: FormaColors.accent,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          for (final meal in meals) ...[
            _MealTile(
              meal: meal,
              onTap: () => _addFood(context, day, meal.slot),
            ),
            const SizedBox(height: 9),
          ],
          for (final slot in const ['Завтрак', 'Обед', 'Ужин', 'Перекус'])
            if (!meals.any((meal) => meal.slot == slot))
              Material(
                color: FormaColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                  side: BorderSide(
                    color: FormaColors.line,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(26),
                  onTap: () => _addFood(context, day, slot),
                  child: SizedBox(
                    height: 62,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            slot,
                            style: DashboardStyle.body.copyWith(
                              color: FormaColors.muted,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: FormaColors.raised,
                            child: FormaIcon(
                              glyph: Assets.icons.plus,
                              color: FormaColors.accent,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _DayChoice extends StatelessWidget {
  const _DayChoice({
    required this.label,
    required this.day,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final int day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Material(
      color: selected ? FormaColors.accent : FormaColors.background,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: DashboardStyle.body.copyWith(
                  color: selected ? FormaColors.ink : FormaColors.muted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$day',
                style: DashboardStyle.body.copyWith(
                  color: selected ? FormaColors.ink : FormaColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _MacroLine extends StatelessWidget {
  const _MacroLine({
    required this.letter,
    required this.current,
    required this.goal,
    required this.color,
  });
  final String letter;
  final int current;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$letter ',
          style: DashboardStyle.body.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextSpan(
          text: '$current / $goal',
          style: DashboardStyle.body.copyWith(color: FormaColors.muted),
        ),
      ],
    ),
  );
}

class _MealTile extends StatelessWidget {
  const _MealTile({required this.meal, required this.onTap});
  final DiaryMeal meal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: FormaColors.surface,
    borderRadius: BorderRadius.circular(26),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    meal.slot,
                    style: DashboardStyle.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${meal.name}, ${meal.grams} г',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DashboardStyle.muted.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.calories}',
                  style: DashboardStyle.title.copyWith(fontSize: 20),
                ),
                Text('ккал', style: DashboardStyle.small),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
