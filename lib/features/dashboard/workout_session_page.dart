import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';

@RoutePage()
class WorkoutSessionPage extends StatefulWidget {
  const WorkoutSessionPage({super.key, required this.index});
  final int index;

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  Timer? _timer;
  int _seconds = 90;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (!mounted || _seconds == 0) return;
      setState(() => _seconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _next(DemoDashboardStore store) {
    if (widget.index + 1 < store.workout.length) {
      context.router.replace(WorkoutSessionRoute(index: widget.index + 1));
    } else {
      if (store.workoutStarted) store.toggleWorkout();
      context.router.replace(WorkoutSummaryRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    final exercise = store.workout[widget.index];
    final count =
        int.tryParse(
          RegExp(r'^\d+').firstMatch(exercise.reps)?.group(0) ?? '',
        ) ??
        3;
    final checked = store.completedSets[widget.index] ?? <int>{};
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: ListView(
            children: [
              Row(
                children: [
                  FormaRoundIconButton(
                    icon: Assets.icons.x,
                    tooltip: 'Закрыть',
                    dimension: 44,
                    onPressed: () => context.router.maybePop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${(widget.index + 1).toString().padLeft(2, '0')} / ${store.workout.length.toString().padLeft(2, '0')}',
                        style: DashboardStyle.small.copyWith(
                          color: FormaColors.accent,
                        ),
                      ),
                    ),
                  ),
                  Text('12:40', style: DashboardStyle.small),
                ],
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: (widget.index + 1) / store.workout.length,
                color: FormaColors.accent,
                backgroundColor: FormaColors.line,
              ),
              SizedBox(height: 23),
              Text(
                exercise.name,
                style: DashboardStyle.title.copyWith(fontSize: 27),
              ),
              SizedBox(height: 8),
              Text(
                'Подход ${checked.length + 1} из $count · отдых',
                style: DashboardStyle.muted,
              ),
              SizedBox(height: 25),
              SizedBox(
                height: 230,
                child: Center(
                  child: FormaSegmentedRing(
                    progress: _seconds / 90,
                    size: 230,
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ОТДЫХ', style: DashboardStyle.small),
                        SizedBox(height: 12),
                        Text(
                          '${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}',
                          style: DashboardStyle.metric,
                        ),
                        Text('из 1:30', style: DashboardStyle.muted),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => setState(
                      () => _seconds = (_seconds - 15).clamp(0, 600),
                    ),
                    child: Text('−15 с'),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => setState(
                      () => _seconds = (_seconds + 15).clamp(0, 600),
                    ),
                    child: Text('+15 с'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              for (var i = 0; i < count; i++)
                InkWell(
                  onTap: () => store.toggleSet(widget.index, i, count),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: FormaColors.line),
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: checked.contains(i),
                          shape: CircleBorder(),
                          activeColor: FormaColors.accent,
                          onChanged: (_) =>
                              store.toggleSet(widget.index, i, count),
                        ),
                        Text('Подход ${i + 1}', style: DashboardStyle.body),
                        Spacer(),
                        Text(exercise.reps, style: DashboardStyle.body),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 22),
              FormaPrimaryButton(
                label: widget.index + 1 == store.workout.length
                    ? 'Завершить тренировку'
                    : 'Следующее упражнение',
                trailingIcon: Assets.icons.arrowRight,
                onPressed: () => _next(store),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@RoutePage()
class WorkoutSummaryPage extends StatefulWidget {
  const WorkoutSummaryPage({super.key});

  @override
  State<WorkoutSummaryPage> createState() => _WorkoutSummaryPageState();
}

class _WorkoutSummaryPageState extends State<WorkoutSummaryPage> {
  String _feeling = 'Нормально';

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    final totalSets = store.workout.fold<int>(
      0,
      (sum, exercise) =>
          sum +
          (int.tryParse(
                RegExp(r'^\d+').firstMatch(exercise.reps)?.group(0) ?? '',
              ) ??
              3),
    );
    final doneSets = store.completedSets.values.fold<int>(
      0,
      (sum, sets) => sum + sets.length,
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'ТРЕНИРОВКА ЗАВЕРШЕНА',
                        style: DashboardStyle.small,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        context.router.replaceAll([MainShellRoute()]),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 28),
              Icon(
                Icons.emoji_events_outlined,
                size: 86,
                color: FormaColors.accent,
              ),
              SizedBox(height: 18),
              Text(
                'Фулбади\nвыполнено',
                textAlign: TextAlign.center,
                style: DashboardStyle.title.copyWith(fontSize: 28),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _SummaryStat('ВРЕМЯ', '${store.workoutMinutes} мин'),
                  ),
                  SizedBox(width: 8),
                  Expanded(child: _SummaryStat('СОЖЖЕНО', '318 ккал')),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _SummaryStat('ОБЪЁМ', '6 420 кг')),
                  SizedBox(width: 8),
                  Expanded(
                    child: _SummaryStat('ПОДХОДОВ', '$doneSets из $totalSets'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: FormaColors.accent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Новый рекорд · Жим лёжа 60 кг × 10',
                  style: DashboardStyle.body.copyWith(
                    color: FormaColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('КАК ОЩУЩЕНИЯ', style: DashboardStyle.small),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  for (final value in ['Легко', 'Нормально', 'Тяжело'])
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: FittedBox(child: Text(value)),
                          selected: _feeling == value,
                          onSelected: (_) => setState(() => _feeling = value),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 18),
              FormaPrimaryButton(
                label: 'Готово',
                trailingIcon: Assets.icons.check,
                onPressed: () => context.router.replaceAll([MainShellRoute()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 80,
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: FormaColors.surface,
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DashboardStyle.small),
        Spacer(),
        Text(
          value,
          style: DashboardStyle.body.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
