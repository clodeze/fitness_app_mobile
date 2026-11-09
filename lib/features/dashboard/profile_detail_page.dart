import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import '../questionnaire/questionnaire_data.dart';
import 'dashboard_format.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';
import 'weight_trend_chart.dart';

enum ProfileSection {
  progress('Прогресс'),
  account('Аккаунт'),
  health('Здоровье'),
  goals('Цели и нормы'),
  reminders('Напоминания'),
  settings('Настройки'),
  premium('FORMA Premium');

  const ProfileSection(this.title);
  final String title;
}

@RoutePage()
class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key, required this.section});
  final ProfileSection section;

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  late String _name;
  late String _email;
  late String _gender;
  late TrainingGoal _goal;
  late double _targetWeight;
  late int _calories;
  late int _hemoglobin;
  late bool _autoCalories;
  late Map<String, bool> _reminders;
  late Set<String> _restrictions;
  String _period = 'Неделя';
  String _activity = 'Средняя';
  String _language = 'RU';
  String _units = 'кг · см';
  String _plan = 'Год';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final store = DemoDashboardScope.of(context);
    _name = store.profileName;
    _email = store.profileEmail;
    _gender = store.gender;
    _goal = store.goal;
    _targetWeight = store.targetWeightKg;
    _calories = store.dailyCalorieGoal;
    _hemoglobin = store.hemoglobin;
    _autoCalories = store.automaticCalories;
    _reminders = Map.of(store.reminders);
    _restrictions = Set.of(store.healthRestrictions);
  }

  void _save() {
    final store = DemoDashboardScope.of(context);
    store.setProfile(name: _name.trim(), email: _email.trim());
    store.gender = _gender;
    store.goal = _goal;
    store.targetWeightKg = _targetWeight;
    store.dailyCalorieGoal = _calories;
    store.hemoglobin = _hemoglobin;
    store.automaticCalories = _autoCalories;
    store.reminders
      ..clear()
      ..addAll(_reminders);
    store.healthRestrictions
      ..clear()
      ..addAll(_restrictions);
    store.refresh();
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
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
                      child: Text(
                        widget.section.title,
                        style: DashboardStyle.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: switch (widget.section) {
                    ProfileSection.progress => _progress(store),
                    ProfileSection.account => _account(store),
                    ProfileSection.health => _health(),
                    ProfileSection.goals => _goals(),
                    ProfileSection.reminders => _reminderRows(),
                    ProfileSection.settings => _settings(store),
                    ProfileSection.premium => _premium(),
                  },
                ),
              ),
              const SizedBox(height: 14),
              if (widget.section != ProfileSection.settings)
                FormaPrimaryButton(
                  label: switch (widget.section) {
                    ProfileSection.progress => 'Записать вес',
                    ProfileSection.premium => 'Попробовать 7 дней',
                    _ => 'Сохранить изменения',
                  },
                  trailingIcon: widget.section == ProfileSection.progress
                      ? Assets.icons.plus
                      : Assets.icons.check,
                  onPressed: widget.section == ProfileSection.progress
                      ? () => _recordWeight(store)
                      : widget.section == ProfileSection.premium
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Подписка в демо недоступна'),
                          ),
                        )
                      : _save,
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _progress(DemoDashboardStore store) => [
    Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: FormaColors.surface,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          for (final period in const ['Неделя', 'Месяц', '3 месяца'])
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: () => setState(() => _period = period),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _period == period
                        ? FormaColors.light
                              ? FormaColors.ink
                              : FormaColors.text
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Text(
                    period,
                    style: DashboardStyle.body.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _period == period
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
    const SizedBox(height: 12),
    _card([
      Row(
        children: [
          _label('ВЕС'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: FormaColors.light
                  ? FormaColors.ink
                  : const Color(0xFF384615),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '−1,4 кг за неделю',
              style: DashboardStyle.small.copyWith(
                color: FormaColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formatWeight(store.weightKg),
            style: DashboardStyle.metric.copyWith(fontSize: 32),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text('кг', style: DashboardStyle.muted),
          ),
        ],
      ),
      const SizedBox(height: 22),
      const WeightTrendChart(height: 91),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final day in const ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'])
            Text(day, style: DashboardStyle.small.copyWith(fontSize: 9)),
        ],
      ),
    ]),
    const SizedBox(height: 12),
    _card([
      Row(
        children: [
          _label('КАЛОРИИ ЗА ДЕНЬ'),
          const Spacer(),
          _label('Норма ${formatThousands(store.dailyCalorieGoal)}'),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('2 000', style: DashboardStyle.metric.copyWith(fontSize: 27)),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('в среднем', style: DashboardStyle.muted),
          ),
        ],
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 92,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Container(height: 1, color: FormaColors.accentAlt),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final height in [72.0, 79.0, 66.0, 87.0, 76.0, 58.0, 52.0])
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 27,
                        height: height,
                        decoration: BoxDecoration(
                          color: height == 52
                              ? FormaColors.accent
                              : FormaColors.raised,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final day in const ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'])
            Text(day, style: DashboardStyle.small.copyWith(fontSize: 9)),
        ],
      ),
    ]),
    const SizedBox(height: 12),
    Row(
      children: [
        Expanded(child: _stat('Тренировки', '3 / 3')),
        const SizedBox(width: 8),
        Expanded(child: _stat('Серия', '6 дн.')),
        const SizedBox(width: 8),
        Expanded(child: _stat('Питание', '94%')),
      ],
    ),
  ];

  List<Widget> _account(DemoDashboardStore store) => [
    Center(
      child: CircleAvatar(
        radius: 44,
        backgroundColor: FormaColors.surface,
        child: Text(
          (_name.isEmpty ? 'Н' : _name[0]).toUpperCase(),
          style: DashboardStyle.title.copyWith(color: FormaColors.accent),
        ),
      ),
    ),
    const SizedBox(height: 12),
    Center(
      child: Text(
        'Сменить фото',
        style: DashboardStyle.body.copyWith(color: FormaColors.accent),
      ),
    ),
    const SizedBox(height: 20),
    _label('ИМЯ'),
    _input(_name, (v) => _name = v),
    const SizedBox(height: 15),
    _label('ПОЧТА'),
    _input(_email, (v) => _email = v),
    const SizedBox(height: 15),
    _label('ПОЛ'),
    _choices(
      ['Мужской', 'Женский'],
      _gender,
      (v) => setState(() => _gender = v),
    ),
    const SizedBox(height: 25),
    _row(
      'Вес, рост, % жира',
      '${formatWeight(store.weightKg)} · ${store.heightCm} · ${store.bodyFatPercent ?? '—'} %',
      () => context.router.push(const BodyFatCalculatorRoute()),
    ),
    _row(
      'Сменить пароль',
      '›',
      () => context.router.push(const PasswordResetRoute()),
    ),
    _row('Удалить аккаунт', '›', () => _confirmDelete(), destructive: true),
  ];

  List<Widget> _health() => [
    _card([
      _label('ГЕМОГЛОБИН'),
      const SizedBox(height: 8),
      Text(
        '$_hemoglobin г/л',
        style: DashboardStyle.metric.copyWith(fontSize: 33),
      ),
      Slider(
        value: _hemoglobin.toDouble(),
        min: 80,
        max: 180,
        activeColor: FormaColors.accent,
        onChanged: (v) => setState(() => _hemoglobin = v.round()),
      ),
      _label(
        'Июль                    Авг                 Сен                 Окт',
      ),
    ]),
    const SizedBox(height: 24),
    _label('ИСТОРИЯ АНАЛИЗОВ'),
    _row('18 октября', '$_hemoglobin г/л', () {}),
    _row('14 сентября', '125 г/л', () {}),
    _row('20 августа', '121 г/л', () {}),
    const SizedBox(height: 22),
    _label('ОГРАНИЧЕНИЯ'),
    const SizedBox(height: 10),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in ['Колени', 'Спина', 'Давление', 'Аллергия'])
          FilterChip(
            label: Text(item),
            selected: _restrictions.contains(item),
            onSelected: (v) => setState(
              () => v ? _restrictions.add(item) : _restrictions.remove(item),
            ),
          ),
      ],
    ),
    const SizedBox(height: 20),
    _card([_label('При проблемах со здоровьем обсуди тренировки с врачом.')]),
  ];

  List<Widget> _goals() => [
    _label('ЦЕЛЬ'),
    const SizedBox(height: 10),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in TrainingGoal.values)
          ChoiceChip(
            label: Text(item.label),
            selected: _goal == item,
            onSelected: (_) => setState(() => _goal = item),
          ),
      ],
    ),
    const SizedBox(height: 26),
    _label('ЦЕЛЕВОЙ ВЕС'),
    Slider(
      value: _targetWeight,
      min: 40,
      max: 150,
      activeColor: FormaColors.accent,
      label: '${_targetWeight.round()} кг',
      onChanged: (v) => setState(() => _targetWeight = v),
    ),
    Center(
      child: Text('${_targetWeight.round()} кг', style: DashboardStyle.title),
    ),
    const SizedBox(height: 20),
    _label('АКТИВНОСТЬ'),
    const SizedBox(height: 10),
    _choices(
      ['Низкая', 'Средняя', 'Высокая'],
      _activity,
      (v) => setState(() => _activity = v),
    ),
    const SizedBox(height: 25),
    _card([
      SwitchListTile(
        title: const Text('Калории в день'),
        subtitle: Text(_autoCalories ? 'Авто' : 'Вручную'),
        value: _autoCalories,
        onChanged: (v) => setState(() => _autoCalories = v),
      ),
      Row(
        children: [
          IconButton(
            onPressed: _autoCalories
                ? null
                : () => setState(() => _calories -= 50),
            icon: const Icon(Icons.remove),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$_calories',
                style: DashboardStyle.metric.copyWith(fontSize: 30),
              ),
            ),
          ),
          IconButton(
            onPressed: _autoCalories
                ? null
                : () => setState(() => _calories += 50),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      const SizedBox(height: 8),
      _label('Белки 150 г              Жиры 60 г              Углеводы 250 г'),
    ]),
  ];

  List<Widget> _reminderRows() => [
    Text(
      'Мягко напомним о тренировке и записи еды.',
      style: DashboardStyle.muted,
    ),
    const SizedBox(height: 25),
    for (final entry in _reminders.entries)
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(entry.key, style: DashboardStyle.body),
        subtitle: Text(switch (entry.key) {
          'Тренировка' => 'Пн · Ср · Пт',
          'Вода' => 'Каждые 2 часа · 1–2 л',
          _ => 'Каждый день',
        }, style: DashboardStyle.small),
        value: entry.value,
        activeThumbColor: FormaColors.accent,
        onChanged: (v) => setState(() => _reminders[entry.key] = v),
      ),
    const SizedBox(height: 20),
    _card([_label('Не беспокоить 23:00 – 07:00')]),
  ];

  List<Widget> _settings(DemoDashboardStore store) => [
    _label('ПРИЛОЖЕНИЕ'),
    const SizedBox(height: 15),
    _row(
      'Язык',
      _language,
      () => _select(
        'Язык',
        ['RU', 'KR', 'EN'],
        _language,
        (v) => setState(() => _language = v),
      ),
    ),
    _row(
      'Единицы',
      _units,
      () => _select(
        'Единицы',
        ['кг · см', 'lb · ft'],
        _units,
        (v) => setState(() => _units = v),
      ),
    ),
    _row(
      'Тема',
      store.themeMode == ThemeMode.dark ? 'Тёмная' : 'Светлая',
      () => store.setThemeMode(
        store.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      ),
    ),
    _row(
      'Напоминания',
      '${store.reminders.values.where((v) => v).length} включено',
      () => context.router.push(
        ProfileDetailRoute(section: ProfileSection.reminders),
      ),
    ),
    const SizedBox(height: 24),
    _label('ДАННЫЕ'),
    SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Синхронизация с Health'),
      value: false,
      onChanged: (_) => _notice('Синхронизация пока недоступна'),
    ),
    _row('Экспорт данных', '›', () => _notice('Экспорт пока недоступен')),
    _row('Политика и условия', '›', () => _notice('Документы пока недоступны')),
    const SizedBox(height: 40),
    OutlinedButton(
      onPressed: () => context.router.replaceAll([const StartRoute()]),
      child: const Text('Выйти'),
    ),
    const SizedBox(height: 12),
    TextButton(
      onPressed: _confirmDelete,
      child: const Text(
        'Удалить аккаунт',
        style: TextStyle(color: Colors.redAccent),
      ),
    ),
    const SizedBox(height: 30),
    Center(child: _label('FORMA 1.0.0')),
  ];

  List<Widget> _premium() => [
    const SizedBox(height: 12),
    Text(
      'Больше\nрезультата',
      style: DashboardStyle.title.copyWith(fontSize: 31),
    ),
    const SizedBox(height: 25),
    _card([
      _label('FREE                                  PREMIUM'),
      const SizedBox(height: 14),
      for (final row in const [
        ('AI-сканер', '10 в день', 'Без лимита'),
        ('План тренировок', 'Базовый', 'Под цель'),
        ('Графики прогресса', '30 дней', 'Всё время'),
        ('Свои продукты', '10', 'Без лимита'),
      ])
        _row(row.$1, '${row.$2}   ${row.$3}', () {}),
    ]),
    const SizedBox(height: 25),
    _choices(
      ['Месяц · 490 сом', 'Год · 3 490 сом'],
      _plan == 'Год' ? 'Год · 3 490 сом' : 'Месяц · 490 сом',
      (v) => setState(() => _plan = v.startsWith('Год') ? 'Год' : 'Месяц'),
    ),
    const SizedBox(height: 15),
    _label('Отменить можно в любой момент в настройках подписки.'),
  ];

  Widget _card(List<Widget> children) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: FormaColors.surface,
      borderRadius: BorderRadius.circular(27),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  Widget _stat(String title, String value) => _card([
    _label(title),
    const SizedBox(height: 8),
    Text(
      value,
      style: DashboardStyle.body.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    ),
  ]);

  Widget _label(String text) => Text(text, style: DashboardStyle.small);

  Widget _row(
    String title,
    String value,
    VoidCallback onTap, {
    bool destructive = false,
  }) => ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    title: Text(
      title,
      style: DashboardStyle.body.copyWith(
        color: destructive ? Colors.redAccent : FormaColors.text,
      ),
    ),
    trailing: Text(value, style: DashboardStyle.muted),
  );

  Widget _choices(
    List<String> options,
    String selected,
    ValueChanged<String> onSelected,
  ) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final value in options)
        ChoiceChip(
          label: Text(value),
          selected: selected == value,
          onSelected: (_) => onSelected(value),
        ),
    ],
  );

  Widget _input(String initialValue, ValueChanged<String> onChanged) =>
      TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: FormaColors.surface,
        ),
      );

  Future<void> _select(
    String title,
    List<String> choices,
    String selected,
    ValueChanged<String> onSelected,
  ) async {
    final value = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(title)),
            for (final choice in choices)
              ListTile(
                title: Text(choice),
                trailing: choice == selected ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(ctx, choice),
              ),
          ],
        ),
      ),
    );
    if (value != null && mounted) onSelected(value);
  }

  Future<void> _recordWeight(DemoDashboardStore store) async {
    var input = formatWeight(store.weightKg).replaceAll(',', '.');
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Записать вес'),
        content: TextField(
          controller: TextEditingController(text: input),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
          ],
          onChanged: (v) => input = v,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx, double.tryParse(input.replaceAll(',', '.'))),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
    if (value != null && value > 0 && mounted) store.setWeight(value);
  }

  void _confirmDelete() => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Удалить аккаунт?'),
      content: const Text('Удаление недоступно в демонстрационной версии.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Понятно'),
        ),
      ],
    ),
  );

  void _notice(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
}
