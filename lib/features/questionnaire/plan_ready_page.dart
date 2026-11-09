import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import '../dashboard/demo_dashboard_store.dart';
import 'questionnaire_header.dart';

@RoutePage()
class PlanReadyPage extends StatelessWidget {
  const PlanReadyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionnaireHeader(
                step: 5,
                onBack: () => context.router.maybePop(),
              ),
              const SizedBox(height: 26),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Твой план\n'),
                    TextSpan(
                      text: 'готов',
                      style: FormaType.heading.copyWith(
                        color: FormaColors.accent,
                      ),
                    ),
                  ],
                ),
                style: FormaType.heading.copyWith(fontSize: 30),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: FormaColors.surface,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    FormaSegmentedRing(
                      progress: 1,
                      size: 170,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('НОРМА', style: FormaType.caption),
                          Text(
                            '${store.dailyCalorieGoal}',
                            style: FormaType.number.copyWith(fontSize: 30),
                          ),
                          Text('ккал в день', style: FormaType.caption),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        Expanded(
                          child: _Macro(label: 'Белки', value: '150'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _Macro(label: 'Жиры', value: '60'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _Macro(label: 'Углеводы', value: '250'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Detail(label: 'ЦЕЛЬ', value: store.goal.label),
              _Detail(
                label: 'ТРЕНИРОВКИ',
                value:
                    'Фулбади · 3 дня · ${store.location.label.toLowerCase()}',
              ),
              const _Detail(label: 'ОБМЕН ВЕЩЕСТВ', value: '1 710 ккал'),
              const SizedBox(height: 10),
              Text(
                'Расчёт ориентировочный и основан на данных анкеты.',
                style: FormaType.caption,
              ),
              const Spacer(),
              FormaPrimaryButton(
                label: 'Начать',
                trailingIcon: Assets.icons.arrowRight,
                onPressed: () =>
                    context.router.replaceAll([const MainShellRoute()]),
              ),
              Center(
                child: TextButton(
                  onPressed: () => context.router.popUntilRoot(),
                  child: const Text('Изменить параметры'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  const _Macro({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 13),
    decoration: BoxDecoration(
      color: FormaColors.raised,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        Text(value, style: FormaType.heading.copyWith(fontSize: 17)),
        Text(label, style: FormaType.caption),
      ],
    ),
  );
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 55,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: FormaColors.line)),
    ),
    child: Row(
      children: [
        Text(label, style: FormaType.caption),
        const Spacer(),
        Flexible(
          child: Text(value, textAlign: TextAlign.right, style: FormaType.body),
        ),
      ],
    ),
  );
}
