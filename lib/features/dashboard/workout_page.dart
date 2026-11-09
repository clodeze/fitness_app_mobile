import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';
import 'exercise_catalog.dart';

@RoutePage()
class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  String _title = 'Фулбади';
  int? _expandedExercise;

  Future<void> _rename() async {
    var name = _title;
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: FormaColors.surface,
        title: Text('Название тренировки', style: DashboardStyle.title),
        content: TextFormField(
          initialValue: _title,
          autofocus: true,
          onChanged: (value) => name = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, name.trim()),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && mounted) {
      setState(() => _title = result);
    }
  }

  Future<void> _replaceExercise() async {
    final store = DemoDashboardScope.of(context);
    final index = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: FormaColors.surface,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Text(
                'Какое упражнение заменить?',
                style: DashboardStyle.title,
              ),
            ),
            for (var i = 0; i < store.workout.length; i++)
              ListTile(
                title: Text(store.workout[i].name, style: DashboardStyle.body),
                onTap: () => Navigator.pop(sheetContext, i),
              ),
          ],
        ),
      ),
    );
    if (index == null || !mounted) return;
    final exercise = await context.router.root.push<Exercise>(
      const ExercisePickerRoute(),
    );
    if (exercise != null && mounted) store.replaceExercise(index, exercise);
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 11, 24, 0),
              child: Row(
                children: [
                  FormaRoundIconButton(
                    icon: Assets.icons.x,
                    tooltip: 'Закрыть',
                    dimension: 44,
                    onPressed: () => context.router.maybePop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('ТРЕНИРОВКА', style: DashboardStyle.small),
                    ),
                  ),
                  FormaRoundIconButton(
                    icon: Assets.icons.pencil,
                    tooltip: 'Изменить название',
                    dimension: 44,
                    onPressed: _rename,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 23, 24, 18),
                children: [
                  Container(
                    height: 198,
                    padding: const EdgeInsets.fromLTRB(21, 22, 18, 18),
                    decoration: BoxDecoration(
                      color: FormaColors.accent,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -42,
                          top: -14,
                          child: SizedBox.square(
                            dimension: 206,
                            child: CustomPaint(painter: _WorkoutHeroPainter()),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'День 1 из 3',
                              style: DashboardStyle.body.copyWith(
                                color: FormaColors.ink,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              _title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: DashboardStyle.title.copyWith(
                                color: FormaColors.ink,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Набор массы · зал',
                              style: DashboardStyle.body.copyWith(
                                color: FormaColors.ink,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 5,
                              children: [
                                _HeroPill('45 мин'),
                                _HeroPill('6 упражнений'),
                                _HeroPill('~320ккал'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 23),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'УПРАЖНЕНИЯ',
                          style: DashboardStyle.muted.copyWith(fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: _replaceExercise,
                        child: Text(
                          'Заменить',
                          style: DashboardStyle.body.copyWith(
                            color: FormaColors.accent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (
                    var index = 0;
                    index < store.workout.length;
                    index++
                  ) ...[
                    _WorkoutRow(
                      index: index,
                      exercise: store.workout[index],
                      completed: store.completedExercises.contains(index),
                      active: store.workoutStarted,
                      onTap: () => setState(
                        () => _expandedExercise = _expandedExercise == index
                            ? null
                            : index,
                      ),
                    ),
                    if (_expandedExercise == index && store.workoutStarted)
                      _SetList(
                        exercise: store.workout[index],
                        checked: store.completedSets[index] ?? const <int>{},
                        onChanged: (setIndex, count) =>
                            store.toggleSet(index, setIndex, count),
                      ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: FormaPrimaryButton(
                label: store.workoutStarted
                    ? 'Завершить тренировку'
                    : store.workoutFinished
                    ? 'Начать заново'
                    : 'Начать тренировку',
                trailingIcon: store.workoutStarted
                    ? Assets.icons.check
                    : Assets.icons.play,
                onPressed: () {
                  if (store.workoutStarted) {
                    store.toggleWorkout();
                    context.router.push(const WorkoutSummaryRoute());
                    return;
                  }
                  store.toggleWorkout();
                  context.router.push(WorkoutSessionRoute(index: 0));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetList extends StatelessWidget {
  const _SetList({
    required this.exercise,
    required this.checked,
    required this.onChanged,
  });

  final Exercise exercise;
  final Set<int> checked;
  final void Function(int setIndex, int count) onChanged;

  @override
  Widget build(BuildContext context) {
    final count =
        int.tryParse(
          RegExp(r'^\d+').firstMatch(exercise.reps)?.group(0) ?? '',
        ) ??
        3;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 0, 16),
      child: Column(
        children: [
          for (var index = 0; index < count; index++)
            InkWell(
              onTap: () => onChanged(index, count),
              child: SizedBox(
                height: 46,
                child: Row(
                  children: [
                    Checkbox(
                      value: checked.contains(index),
                      activeColor: FormaColors.accent,
                      checkColor: FormaColors.ink,
                      shape: const CircleBorder(),
                      onChanged: (_) => onChanged(index, count),
                    ),
                    Text('Подход ${index + 1}', style: DashboardStyle.body),
                    const Spacer(),
                    Text(
                      exercise.reps.replaceFirst(
                        RegExp(r'^\d+\s*[x×х]\s*'),
                        '',
                      ),
                      style: DashboardStyle.muted,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: FormaColors.ink,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: DashboardStyle.body.copyWith(
        color: FormaColors.accent,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _WorkoutRow extends StatelessWidget {
  const _WorkoutRow({
    required this.index,
    required this.exercise,
    required this.completed,
    required this.active,
    required this.onTap,
  });
  final int index;
  final Exercise exercise;
  final bool completed;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: FormaColors.background,
    child: InkWell(
      onTap: active ? onTap : null,
      child: Container(
        height: 61,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: FormaColors.line)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 38,
              child: Text(
                '${index + 1}'.padLeft(2, '0'),
                style: DashboardStyle.body.copyWith(
                  color: completed ? FormaColors.accent : FormaColors.muted,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DashboardStyle.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: completed ? FormaColors.accent : FormaColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    exercise.category,
                    style: DashboardStyle.muted.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              completed ? '✓' : exercise.reps,
              style: DashboardStyle.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _WorkoutHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFF98CB29)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final radius in [40.0, 72.0, 101.0]) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, line);
    }
    final bar = Paint()
      ..color = FormaColors.ink
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(26, size.height / 2),
      Offset(size.width - 26, size.height / 2),
      bar,
    );
    for (final x in [37.0, 55.0, size.width - 55, size.width - 37]) {
      canvas.drawLine(
        Offset(
          x,
          size.height / 2 - (x == 37 || x == size.width - 37 ? 17 : 28),
        ),
        Offset(
          x,
          size.height / 2 + (x == 37 || x == size.width - 37 ? 17 : 28),
        ),
        bar,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
