import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'exercise_catalog.dart';

@RoutePage()
class GymPage extends StatelessWidget {
  const GymPage({super.key});

  @override
  Widget build(BuildContext context) => const ExerciseLibraryView();
}

@RoutePage()
class ExercisePickerPage extends StatelessWidget {
  const ExercisePickerPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ExerciseLibraryView(
      picking: true,
      onChosen: (exercise) => context.router.pop<Exercise>(exercise),
    ),
  );
}

class ExerciseLibraryView extends StatefulWidget {
  const ExerciseLibraryView({super.key, this.picking = false, this.onChosen});
  final bool picking;
  final ValueChanged<Exercise>? onChosen;

  @override
  State<ExerciseLibraryView> createState() => _ExerciseLibraryViewState();
}

class _ExerciseLibraryViewState extends State<ExerciseLibraryView> {
  final _search = TextEditingController();
  String _category = 'Все';
  String _location = 'Зал';
  int _difficulty = 0;

  @override
  void initState() {
    super.initState();
    _search.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _search.removeListener(_refresh);
    _search.dispose();
    super.dispose();
  }

  List<Exercise> get _visible => demoExercises.where((exercise) {
    final query = _search.text.trim().toLowerCase();
    return (query.isEmpty || exercise.name.toLowerCase().contains(query)) &&
        (_category == 'Все' || exercise.category == _category) &&
        (_location == 'Зал' ||
            exercise.equipment == 'без оборудования' ||
            exercise.equipment == 'гантели') &&
        (_difficulty == 0 || exercise.difficulty == _difficulty);
  }).toList();

  void _openExercise(Exercise exercise) {
    if (widget.onChosen != null) {
      widget.onChosen!(exercise);
      return;
    }
    context.router.root.push(ExerciseDetailsRoute(exercise: exercise));
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Material(
      color: FormaColors.background,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(27, 30, 27, 20),
          children: [
            Row(
              children: [
                if (widget.picking) ...[
                  FormaRoundIconButton(
                    icon: Assets.icons.arrowLeft,
                    tooltip: 'Назад',
                    dimension: 40,
                    onPressed: () => context.router.maybePop(),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    'Упражнения',
                    style: DashboardStyle.title.copyWith(fontSize: 23),
                  ),
                ),
                Text('${visible.length}', style: DashboardStyle.muted),
              ],
            ),
            const SizedBox(height: 21),
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 17),
                  FormaIcon(
                    glyph: Assets.icons.search,
                    color: FormaColors.muted,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      style: DashboardStyle.body.copyWith(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Поиск упражнений',
                        hintStyle: DashboardStyle.muted.copyWith(fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final category in const [
                    'Все',
                    'Грудь',
                    'Спина',
                    'Ноги',
                    'Плечи',
                    'Пресс',
                  ]) ...[
                    _FilterChip(
                      label: category,
                      selected: _category == category,
                      onTap: () => setState(() => _category = category),
                    ),
                    const SizedBox(width: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PopupMenuButton<String>(
                    onSelected: (value) => setState(() => _location = value),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'Зал', child: Text('Зал')),
                      PopupMenuItem(value: 'Дома', child: Text('Дома')),
                    ],
                    child: _SmallDropdown(label: _location),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: PopupMenuButton<int>(
                    onSelected: (value) => setState(() => _difficulty = value),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 0, child: Text('Любой уровень')),
                      PopupMenuItem(value: 1, child: Text('Лёгкая')),
                      PopupMenuItem(value: 2, child: Text('Средняя')),
                      PopupMenuItem(value: 3, child: Text('Сложная')),
                    ],
                    child: _SmallDropdown(
                      label: const [
                        'Любой уровень',
                        'Лёгкая',
                        'Средняя',
                        'Сложная',
                      ][_difficulty],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 23),
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Text(
                  'Упражнения не найдены',
                  style: DashboardStyle.muted,
                ),
              ),
            for (final exercise in visible)
              _ExerciseRow(
                exercise: exercise,
                onTap: () => _openExercise(exercise),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? FormaColors.text : FormaColors.background,
    shape: StadiumBorder(
      side: BorderSide(color: selected ? Colors.transparent : FormaColors.line),
    ),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            label,
            style: DashboardStyle.body.copyWith(
              color: selected ? FormaColors.ink : FormaColors.text,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    ),
  );
}

class _SmallDropdown extends StatelessWidget {
  const _SmallDropdown({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: FormaColors.raised,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DashboardStyle.muted.copyWith(fontSize: 12),
          ),
        ),
        const SizedBox(width: 6),
        FormaIcon(
          glyph: Assets.icons.chevronDown,
          color: FormaColors.muted,
          size: 12,
        ),
      ],
    ),
  );
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({required this.exercise, required this.onTap});
  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: FormaColors.background,
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 83,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: FormaColors.line)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FormaIcon(
                  glyph: exercise.equipment == 'без оборудования'
                      ? Assets.icons.personStanding
                      : Assets.icons.dumbbell,
                  color: FormaColors.accent,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 15),
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exercise.category} · ${exercise.equipment}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: DashboardStyle.muted.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                for (var index = 0; index < 3; index++)
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: index < exercise.difficulty
                          ? FormaColors.accent
                          : FormaColors.line,
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
