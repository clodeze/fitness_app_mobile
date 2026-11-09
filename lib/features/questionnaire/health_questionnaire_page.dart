import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import '../dashboard/demo_dashboard_store.dart';
import 'questionnaire_header.dart';

@RoutePage()
class HealthQuestionnairePage extends StatefulWidget {
  const HealthQuestionnairePage({super.key});

  @override
  State<HealthQuestionnairePage> createState() =>
      _HealthQuestionnairePageState();
}

class _HealthQuestionnairePageState extends State<HealthQuestionnairePage> {
  double _hemoglobin = 138;
  final Set<String> _restrictions = {};

  void _next() {
    final store = DemoDashboardScope.of(context);
    store.hemoglobin = _hemoglobin.round();
    store.healthRestrictions
      ..clear()
      ..addAll(_restrictions);
    context.router.push(const PlanReadyRoute());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionnaireHeader(
              step: 4,
              onBack: () => context.router.maybePop(),
            ),
            const SizedBox(height: 28),
            Text('Здоровье', style: FormaType.heading.copyWith(fontSize: 29)),
            const SizedBox(height: 12),
            Text(
              'Подстроим нагрузку и питание. Этот шаг можно пропустить.',
              style: FormaType.body.copyWith(color: FormaColors.muted),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('ГЕМОГЛОБИН', style: FormaType.caption),
                      const Spacer(),
                      Text(
                        '${_hemoglobin.round()}',
                        style: FormaType.number.copyWith(fontSize: 32),
                      ),
                      Text(' г/л', style: FormaType.caption),
                    ],
                  ),
                  Slider(
                    value: _hemoglobin,
                    min: 80,
                    max: 180,
                    activeColor: FormaColors.accent,
                    onChanged: (value) => setState(() => _hemoglobin = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('80', style: FormaType.caption),
                      Text('Норма 120–160', style: FormaType.caption),
                      Text('180', style: FormaType.caption),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text('ОГРАНИЧЕНИЯ', style: FormaType.caption),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final restriction in const [
                  'Колени',
                  'Спина',
                  'Давление',
                  'Сахар',
                  'Аллергия на продукты',
                ])
                  ChoiceChip(
                    label: Text(restriction),
                    selected: _restrictions.contains(restriction),
                    onSelected: (selected) => setState(() {
                      if (selected) {
                        _restrictions.add(restriction);
                      } else {
                        _restrictions.remove(restriction);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Укажи важное для плана. При проблемах со здоровьем обсуди тренировки с врачом.',
              style: FormaType.caption.copyWith(fontSize: 12),
            ),
            const Spacer(),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: FormaSecondaryButton(
                    label: 'Назад',
                    onPressed: () => context.router.maybePop(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FormaPrimaryButton(
                    label: 'Далее',
                    trailingIcon: Assets.icons.arrowRight,
                    onPressed: _next,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
