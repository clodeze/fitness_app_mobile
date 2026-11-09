import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../dashboard/demo_dashboard_store.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'questionnaire_data.dart';
import 'questionnaire_header.dart';

@RoutePage()
class GoalPage extends StatefulWidget {
  const GoalPage({super.key, required this.parameters});

  final BodyParameters parameters;

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  TrainingGoal? _goal;
  TrainingExperience? _experience;
  TrainingLocation? _location;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _assemblePlan() {
    if (_goal == null) {
      _showMessage('Выбери цель');
      return;
    }
    if (_experience == null) {
      _showMessage('Выбери опыт тренировок');
      return;
    }
    if (_location == null) {
      _showMessage('Выбери место тренировок');
      return;
    }

    final store = DemoDashboardScope.of(context);
    store.goal = _goal!;
    store.experience = _experience!;
    store.location = _location!;
    store.setWeight(widget.parameters.weightKg.toDouble());
    context.router.push(const HealthQuestionnaireRoute());
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomSpace = math.max(0.0, 32 - bottomInset);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(334.0, constraints.maxWidth - 56);
            return Center(
              child: SizedBox(
                width: contentWidth,
                height: constraints.maxHeight,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 2),
                          QuestionnaireHeader(
                            step: 3,
                            onBack: () => context.router.maybePop(),
                          ),
                          const SizedBox(height: 26),
                          Text(
                            'Какая твоя\nцель?',
                            style: FormaType.heading.copyWith(
                              fontSize: 31,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 21),
                          for (final goal in TrainingGoal.values) ...[
                            _GoalOption(
                              goal: goal,
                              selected: _goal == goal,
                              onTap: () => setState(() => _goal = goal),
                            ),
                            if (goal != TrainingGoal.values.last)
                              const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 19),
                          Text('ОПЫТ ТРЕНИРОВОК', style: FormaType.caption),
                          const SizedBox(height: 13),
                          Row(
                            children: [
                              for (final experience
                                  in TrainingExperience.values) ...[
                                _ExperienceChip(
                                  experience: experience,
                                  selected: _experience == experience,
                                  onTap: () =>
                                      setState(() => _experience = experience),
                                ),
                                if (experience !=
                                    TrainingExperience.values.last)
                                  const SizedBox(width: 8),
                              ],
                            ],
                          ),
                          const SizedBox(height: 37),
                          Text('ГДЕ ТРЕНИРУЕШЬСЯ', style: FormaType.caption),
                          const SizedBox(height: 13),
                          Row(
                            children: [
                              Expanded(
                                child: _LocationChoice(
                                  location: TrainingLocation.gym,
                                  icon: Assets.icons.dumbbell,
                                  selected: _location == TrainingLocation.gym,
                                  onTap: () => setState(
                                    () => _location = TrainingLocation.gym,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _LocationChoice(
                                  location: TrainingLocation.home,
                                  icon: Assets.icons.house,
                                  selected: _location == TrainingLocation.home,
                                  onTap: () => setState(
                                    () => _location = TrainingLocation.home,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FormaPrimaryButton(
                              label: 'Собрать мой план',
                              onPressed: _assemblePlan,
                            ),
                            SizedBox(height: bottomSpace),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final TrainingGoal goal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? FormaColors.ink : FormaColors.text;
    return Semantics(
      selected: selected,
      child: Material(
        color: selected ? FormaColors.accent : FormaColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
          side: selected
              ? BorderSide.none
              : BorderSide(color: FormaColors.line),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    child: Text(
                      (goal.index + 1).toString().padLeft(2, '0'),
                      style: FormaType.body.copyWith(
                        fontSize: 11,
                        color: selected ? FormaColors.ink : FormaColors.muted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      goal.label,
                      style: FormaType.body.copyWith(
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: foreground,
                      ),
                    ),
                  ),
                  if (selected)
                    FormaIcon(
                      glyph: Assets.icons.check,
                      color: FormaColors.ink,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExperienceChip extends StatelessWidget {
  const _ExperienceChip({
    required this.experience,
    required this.selected,
    required this.onTap,
  });

  final TrainingExperience experience;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = switch (experience) {
      TrainingExperience.beginner => 84.0,
      TrainingExperience.some => 82.0,
      TrainingExperience.pro => 66.0,
    };
    return Semantics(
      selected: selected,
      child: Material(
        color: selected ? FormaColors.text : FormaColors.background,
        shape: StadiumBorder(
          side: selected
              ? BorderSide.none
              : BorderSide(color: FormaColors.line),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            width: width,
            height: 39,
            child: Center(
              child: Text(
                experience.label,
                style: FormaType.body.copyWith(
                  fontSize: 11,
                  color: selected ? FormaColors.ink : FormaColors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationChoice extends StatelessWidget {
  const _LocationChoice({
    required this.location,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final TrainingLocation location;
  final SvgGenImage icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? FormaColors.ink : FormaColors.muted;
    return Semantics(
      selected: selected,
      child: Material(
        color: selected ? FormaColors.text : FormaColors.surface,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormaIcon(glyph: icon, color: foreground, size: 20),
                const SizedBox(width: 8),
                Text(
                  location.label,
                  style: FormaType.body.copyWith(
                    fontSize: 12,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
