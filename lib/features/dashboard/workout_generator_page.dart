import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';
import 'exercise_catalog.dart';

@RoutePage()
class WorkoutGeneratorPage extends StatefulWidget {
  const WorkoutGeneratorPage({super.key});

  @override
  State<WorkoutGeneratorPage> createState() => _WorkoutGeneratorPageState();
}

class _WorkoutGeneratorPageState extends State<WorkoutGeneratorPage> {
  String _location = 'В зале';
  String _split = 'Фулбади';
  int _days = 3;
  int _minutes = 45;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: ListView(
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
                    child: Text('ГЕНЕРАТОР', style: DashboardStyle.small),
                  ),
                ),
                SizedBox(width: 44),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Свой план',
              style: DashboardStyle.title.copyWith(fontSize: 31),
            ),
            SizedBox(height: 10),
            Text(
              'Подберём упражнения под цель и место.',
              style: DashboardStyle.muted,
            ),
            SizedBox(height: 24),
            Text('ГДЕ ТРЕНИРУЕШЬСЯ', style: DashboardStyle.small),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  for (final value in const ['В зале', 'Дома'])
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _location = value),
                        borderRadius: BorderRadius.circular(13),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _location == value
                                ? FormaColors.light
                                      ? FormaColors.ink
                                      : FormaColors.text
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            value,
                            style: DashboardStyle.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _location == value
                                  ? FormaColors.light
                                        ? FormaColors.surface
                                        : FormaColors.ink
                                  : FormaColors.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text('СПЛИТ', style: DashboardStyle.small),
            SizedBox(height: 10),
            for (final item in [
              ('Фулбади', 'Всё тело за тренировку'),
              ('Сплит', 'Тренировка отдельных групп мышц'),
              ('Верх / низ', 'Две части программы'),
            ]) ...[
              Material(
                color: _split == item.$1
                    ? FormaColors.accent
                    : FormaColors.surface,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => setState(() => _split = item.$1),
                  child: Padding(
                    padding: EdgeInsets.all(17),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.$1,
                                style: DashboardStyle.body.copyWith(
                                  color: _split == item.$1
                                      ? FormaColors.ink
                                      : FormaColors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                item.$2,
                                style: DashboardStyle.small.copyWith(
                                  color: _split == item.$1
                                      ? FormaColors.ink.withValues(alpha: .58)
                                      : FormaColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_split == item.$1)
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: FormaColors.ink,
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: FormaColors.accent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
            SizedBox(height: 18),
            Text('ДНЕЙ В НЕДЕЛЮ', style: DashboardStyle.small),
            SizedBox(height: 10),
            _choices(
              ['2', '3', '4', '5', '6'],
              '$_days',
              (v) => setState(() => _days = int.parse(v)),
            ),
            SizedBox(height: 20),
            Text('ДЛИТЕЛЬНОСТЬ', style: DashboardStyle.small),
            SizedBox(height: 10),
            _choices(
              ['30 мин', '45 мин', '60 мин'],
              '$_minutes мин',
              (v) => setState(() => _minutes = int.parse(v.split(' ').first)),
            ),
            SizedBox(height: 28),
            FormaPrimaryButton(
              label: 'Собрать план',
              trailingIcon: Assets.icons.arrowRight,
              onPressed: () {
                DemoDashboardScope.of(context).configureWorkout(
                  split: _split,
                  days: _days,
                  minutes: _minutes,
                );
                context.router.replace(WorkoutRoute());
              },
            ),
          ],
        ),
      ),
    ),
  );

  Widget _choices(
    List<String> options,
    String selected,
    ValueChanged<String> onTap,
  ) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final value in options)
        Material(
          color: selected == value
              ? FormaColors.light
                    ? FormaColors.ink
                    : FormaColors.text
              : FormaColors.background,
          shape: StadiumBorder(
            side: selected == value
                ? BorderSide.none
                : BorderSide(color: FormaColors.line),
          ),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () => onTap(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              child: Text(
                value,
                style: DashboardStyle.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected == value
                      ? FormaColors.light
                            ? FormaColors.surface
                            : FormaColors.ink
                      : FormaColors.muted,
                ),
              ),
            ),
          ),
        ),
    ],
  );
}

@RoutePage()
class ExerciseDetailsPage extends StatelessWidget {
  const ExerciseDetailsPage({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text('УПРАЖНЕНИЕ', style: DashboardStyle.small),
                  ),
                ),
                IconButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Добавлено в избранное')),
                  ),
                  icon: Icon(Icons.bookmark_border),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: FormaIcon(
                  glyph: Assets.icons.dumbbell,
                  color: FormaColors.accent,
                  size: 90,
                ),
              ),
            ),
            SizedBox(height: 22),
            Text(
              exercise.name,
              style: DashboardStyle.title.copyWith(fontSize: 28),
            ),
            SizedBox(height: 8),
            Text(
              '${exercise.equipment.toUpperCase()} · ЗАЛ · СРЕДНИЙ УРОВЕНЬ',
              style: DashboardStyle.small,
            ),
            SizedBox(height: 16),
            Chip(label: Text(exercise.category)),
            SizedBox(height: 20),
            Text('КАК ДЕЛАТЬ', style: DashboardStyle.small),
            SizedBox(height: 8),
            for (final entry in [
              'Займи устойчивое положение и подготовь оборудование.',
              'Выполняй движение плавно, сохраняя контроль корпуса.',
              'Вернись в исходное положение и повтори подход.',
            ].asMap().entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  '${entry.key + 1}',
                  style: DashboardStyle.body.copyWith(
                    color: FormaColors.accent,
                  ),
                ),
                title: Text(entry.value, style: DashboardStyle.body),
              ),
            Spacer(),
            FormaPrimaryButton(
              label: 'Добавить в тренировку',
              trailingIcon: Assets.icons.plus,
              onPressed: () {
                DemoDashboardScope.of(context).addExercise(exercise);
                context.router.replace(WorkoutRoute());
              },
            ),
          ],
        ),
      ),
    ),
  );
}
