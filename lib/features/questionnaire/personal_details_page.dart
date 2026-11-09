import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import '../dashboard/demo_dashboard_store.dart';
import 'questionnaire_data.dart';
import 'questionnaire_header.dart';

@RoutePage()
class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  String _gender = 'Мужской';
  TrainingExperience _experience = TrainingExperience.beginner;

  void _next() {
    final store = DemoDashboardScope.of(context);
    store.gender = _gender;
    store.experience = _experience;
    context.router.push(const ParametersRoute());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionnaireHeader(
              step: 1,
              onBack: () => context.router.maybePop(),
            ),
            const SizedBox(height: 28),
            Text(
              'Расскажи\nо себе',
              style: FormaType.heading.copyWith(fontSize: 31),
            ),
            const SizedBox(height: 12),
            Text(
              'Пол влияет на расчёт обмена веществ.',
              style: FormaType.body.copyWith(color: FormaColors.muted),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                for (final gender in ['Мужской', 'Женский']) ...[
                  Expanded(
                    child: _GenderCard(
                      label: gender,
                      selected: _gender == gender,
                      onTap: () => setState(() => _gender = gender),
                    ),
                  ),
                  if (gender == 'Мужской') const SizedBox(width: 12),
                ],
              ],
            ),
            const SizedBox(height: 26),
            Text('ОПЫТ ТРЕНИРОВОК', style: FormaType.caption),
            const SizedBox(height: 10),
            for (final experience in TrainingExperience.values) ...[
              Material(
                color: _experience == experience
                    ? FormaColors.text
                    : FormaColors.surface,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => setState(() => _experience = experience),
                  child: SizedBox(
                    height: 64,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  experience.label,
                                  style: FormaType.body.copyWith(
                                    color: _experience == experience
                                        ? FormaColors.ink
                                        : FormaColors.text,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(switch (experience) {
                                  TrainingExperience.beginner =>
                                    'Меньше 6 месяцев',
                                  TrainingExperience.some =>
                                    'От 6 месяцев до 2 лет',
                                  TrainingExperience.pro => 'Больше 2 лет',
                                }, style: FormaType.caption),
                              ],
                            ),
                          ),
                          if (_experience == experience)
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: FormaColors.ink,
                              child: FormaIcon(
                                glyph: Assets.icons.check,
                                color: FormaColors.accent,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            const Spacer(),
            FormaPrimaryButton(
              label: 'Далее',
              trailingIcon: Assets.icons.arrowRight,
              onPressed: _next,
            ),
          ],
        ),
      ),
    ),
  );
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? FormaColors.accent : FormaColors.surface,
    borderRadius: BorderRadius.circular(28),
    child: InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: SizedBox(
        height: 132,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                label == 'Мужской' ? Icons.male : Icons.female,
                size: 30,
                color: selected ? FormaColors.ink : FormaColors.text,
              ),
              Text(
                label,
                style: FormaType.body.copyWith(
                  color: selected ? FormaColors.ink : FormaColors.text,
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
