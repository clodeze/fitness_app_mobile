import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'dashboard_format.dart';
import 'demo_dashboard_store.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    const day = 18;
    final calories = store.caloriesFor(day);
    final remaining = math.max(0, store.dailyCalorieGoal - calories);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ВС, 18 ОКТЯБРЯ', style: DashboardStyle.small),
                    const SizedBox(height: 4),
                    Text(
                      'Привет, ${store.profileName.isEmpty ? 'друг' : store.profileName}',
                      style: DashboardStyle.title.copyWith(fontSize: 25),
                    ),
                  ],
                ),
              ),
              Material(
                color: FormaColors.raised,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => AutoTabsRouter.of(context).setActiveIndex(3),
                  child: SizedBox.square(
                    dimension: 44,
                    child: Center(
                      child: Text(
                        store.profileName.isEmpty
                            ? 'Н'
                            : store.profileName[0].toUpperCase(),
                        style: TextStyle(
                          fontFamily: FontFamily.iBMPlexSans,
                          fontSize: 18,
                          color: FormaColors.light
                              ? FormaColors.text
                              : FormaColors.accent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            decoration: BoxDecoration(
              color: FormaColors.surface,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                FormaSegmentedRing(
                  progress: calories / store.dailyCalorieGoal,
                  size: 208,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$remaining',
                        style: DashboardStyle.metric.copyWith(fontSize: 43),
                      ),
                      Text('ккал осталось', style: DashboardStyle.muted),
                      const SizedBox(height: 4),
                      Text(
                        '${formatThousands(calories)} / ${formatThousands(store.dailyCalorieGoal)}',
                        style: DashboardStyle.body.copyWith(
                          color: FormaColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _MacroSummary(
                        label: 'БЕЛКИ',
                        value: store.proteinFor(day),
                        goal: DemoDashboardStore.proteinGoal,
                        color: FormaColors.accent,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MacroSummary(
                        label: 'ЖИРЫ',
                        value: store.fatFor(day),
                        goal: DemoDashboardStore.fatGoal,
                        color: const Color(0xFF9ED3DF),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MacroSummary(
                        label: 'УГЛЕВОДЫ',
                        value: store.carbsFor(day),
                        goal: DemoDashboardStore.carbsGoal,
                        color: FormaColors.accentAlt,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: FormaColors.light ? FormaColors.ink : FormaColors.accent,
            borderRadius: BorderRadius.circular(32),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () => context.router.root.push(const WorkoutRoute()),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ТРЕНИРОВКА СЕГОДНЯ',
                            style: DashboardStyle.body.copyWith(
                              color: FormaColors.light
                                  ? FormaColors.accent
                                  : FormaColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Фулбади, день 1',
                            style: DashboardStyle.title.copyWith(
                              color: FormaColors.light
                                  ? FormaColors.accent
                                  : FormaColors.ink,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '45 мин · 6 упражнений · зал',
                            style: DashboardStyle.body.copyWith(
                              color: FormaColors.light
                                  ? FormaColors.accent
                                  : FormaColors.ink,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: FormaColors.light
                          ? FormaColors.accent
                          : FormaColors.ink,
                      child: FormaIcon(
                        glyph: Assets.icons.arrowRight,
                        color: FormaColors.light
                            ? FormaColors.ink
                            : FormaColors.accent,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: 'ВЕС',
                  number: formatWeight(store.weightKg),
                  unit: 'кг',
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _MetricCard(label: 'СЕРИЯ', number: '6', unit: 'дней'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroSummary extends StatelessWidget {
  const _MacroSummary({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });
  final String label;
  final int value;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: DashboardStyle.small),
      const SizedBox(height: 6),
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$value',
                style: DashboardStyle.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              TextSpan(
                text: ' / $goal г',
                style: DashboardStyle.muted.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 5),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: (value / goal).clamp(0, 1),
          minHeight: 4,
          backgroundColor: FormaColors.line,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.number,
    required this.unit,
  });
  final String label;
  final String number;
  final String unit;

  @override
  Widget build(BuildContext context) => Container(
    height: 84,
    padding: const EdgeInsets.fromLTRB(19, 15, 12, 12),
    decoration: BoxDecoration(
      color: FormaColors.surface,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DashboardStyle.small),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                number,
                maxLines: 1,
                style: DashboardStyle.title.copyWith(fontSize: 24),
              ),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(unit, style: DashboardStyle.muted),
            ),
          ],
        ),
      ],
    ),
  );
}
