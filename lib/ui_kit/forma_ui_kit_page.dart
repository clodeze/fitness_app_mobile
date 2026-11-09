import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'forma_ui_kit.dart';

/// A mobile gallery for the reusable FORMA design system.
@RoutePage()
class FormaUiKitPage extends StatefulWidget {
  const FormaUiKitPage({super.key});

  @override
  State<FormaUiKitPage> createState() => _FormaUiKitPageState();
}

class _FormaUiKitPageState extends State<FormaUiKitPage> {
  int _selectedGoal = 0;
  int _selectedChip = 0;
  FormaTab _selectedTab = FormaTab.home;

  void _showAction(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(label, style: FormaType.body),
          backgroundColor: FormaColors.raised,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                FormaSpace.screen,
                32,
                FormaSpace.screen,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 36),
                  Divider(color: FormaColors.line, height: 1),
                  const SizedBox(height: 40),
                  _section('01 · ЦВЕТА', [_palette()]),
                  _section('02 · ШРИФТЫ', [_typography()]),
                  _section('03 · КНОПКИ', [_buttons()]),
                  _section('04 · ВЫБОР', [_selection()]),
                  _section('05 · ПОЛЯ', [_fields()]),
                  _section('06 · КАРТОЧКИ', [_cards()]),
                  _section('07 · КОЛЬЦО И НАВИГАЦИЯ', [_ringAndNavigation()]),
                  Divider(color: FormaColors.line, height: 1),
                  const SizedBox(height: 24),
                  Text(
                    'СЕТКА  ·  Шаг 8 px, поля экрана 24 px',
                    style: FormaType.caption,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'РАДИУСЫ  ·  Поля 14, карточки 22, кнопки 100',
                    style: FormaType.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: FormaColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'FORMA',
              style: FormaType.heading.copyWith(
                fontSize: 32,
                letterSpacing: -1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'UI-kit · тёмная тема, яркий акцент, шрифты Unbounded / Onest',
          style: FormaType.body.copyWith(color: FormaColors.muted),
        ),
      ],
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: FormaType.section),
        const SizedBox(height: 20),
        ...children,
        const SizedBox(height: 44),
      ],
    );
  }

  Widget _palette() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ColorSwatch(
                'bg_primary',
                '#0D0D0D',
                FormaColors.background,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ColorSwatch('bg_surface', '#19191B', FormaColors.surface),
            ),
          ],
        ),
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ColorSwatch('bg_raised', '#242426', FormaColors.raised),
            ),
            SizedBox(width: 12),
            Expanded(child: _ColorSwatch('line', '#2B2B2D', FormaColors.line)),
          ],
        ),
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ColorSwatch('text_primary', '#F3F1E8', FormaColors.text),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ColorSwatch('text_muted', '#777773', FormaColors.muted),
            ),
          ],
        ),
        SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _ColorSwatch('accent', '#C4FF2C', FormaColors.accent),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ColorSwatch(
                'accent_alt',
                '#F16B3C',
                FormaColors.accentAlt,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _typography() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('2 200', style: FormaType.number),
        const SizedBox(height: 8),
        Text('Цифры · Unbounded Medium 44 / -2', style: FormaType.caption),
        const SizedBox(height: 22),
        Text('Твои параметры', style: FormaType.heading),
        const SizedBox(height: 8),
        Text(
          'Заголовки · Unbounded SemiBold 24 / -1',
          style: FormaType.caption,
        ),
        const SizedBox(height: 22),
        Text(
          'Тренировки под твои цели и график жизни — без сложностей.',
          style: FormaType.body,
        ),
        const SizedBox(height: 8),
        Text('Текст · Onest Regular 14 / 140%', style: FormaType.caption),
        const SizedBox(height: 22),
        Text('НОРМА НА ДЕНЬ', style: FormaType.overline),
        const SizedBox(height: 8),
        Text('Подписи · Onest 10 / +1.5', style: FormaType.caption),
      ],
    );
  }

  Widget _buttons() {
    return Column(
      children: [
        FormaPrimaryButton(
          label: 'Главная кнопка',
          onPressed: () => _showAction('Главная кнопка'),
        ),
        const SizedBox(height: 14),
        FormaSecondaryButton(
          label: 'Второстепенная',
          onPressed: () => _showAction('Второстепенная кнопка'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            FormaRoundIconButton(
              icon: Assets.icons.arrowLeft,
              tooltip: 'Назад',
              onPressed: () => _showAction('Назад'),
            ),
            const SizedBox(width: 12),
            FormaRoundIconButton(
              icon: Assets.icons.plus,
              tooltip: 'Добавить',
              onPressed: () => _showAction('Добавить'),
            ),
            const SizedBox(width: 12),
            FormaRoundIconButton(
              icon: Assets.icons.camera,
              tooltip: 'Камера',
              accented: true,
              onPressed: () => _showAction('Камера'),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: FormaTextLink(
                label: 'Текстовая ссылка',
                onPressed: () => _showAction('Текстовая ссылка'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _selection() {
    return Column(
      children: [
        FormaGoalTile(
          label: 'Набор массы',
          icon: Assets.icons.dumbbell,
          selected: _selectedGoal == 0,
          onTap: () => setState(() => _selectedGoal = 0),
        ),
        const SizedBox(height: 14),
        FormaGoalTile(
          label: 'Похудение',
          icon: Assets.icons.flame,
          selected: _selectedGoal == 1,
          onTap: () => setState(() => _selectedGoal = 1),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            FormaChoiceChip(
              label: 'Выбрано',
              selected: _selectedChip == 0,
              onTap: () => setState(() => _selectedChip = 0),
            ),
            const SizedBox(width: 8),
            FormaChoiceChip(
              label: 'Не выбрано',
              selected: _selectedChip == 1,
              onTap: () => setState(() => _selectedChip = 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fields() {
    return const Column(
      children: [
        FormaTextField(label: 'ИМЯ', initialValue: 'Никита'),
        SizedBox(height: 20),
        FormaTextField(
          label: 'В ФОКУСЕ',
          initialValue: 'nikita@example.com',
          keyboardType: TextInputType.emailAddress,
          showFocusedStyle: true,
        ),
      ],
    );
  }

  Widget _cards() {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FormaMetricCard(label: 'ВЕС', value: '70.4 кг'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: FormaMetricCard(
                label: 'СЕГОДНЯ',
                value: 'Фулбоди',
                highlighted: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        FormaMealCard(
          title: 'Завтрак',
          description: 'Овсянка с ягодами, яйца',
          calories: 420,
        ),
      ],
    );
  }

  Widget _ringAndNavigation() {
    return Column(
      children: [
        const Center(child: FormaSegmentedRing(progress: 0.65)),
        const SizedBox(height: 18),
        Text(
          'Кольцо из штрихов · 60–72 сегмента, активный лайм. '
          'Центральное значение всегда на первом плане.',
          textAlign: TextAlign.center,
          style: FormaType.body.copyWith(
            fontSize: 12,
            color: FormaColors.muted,
          ),
        ),
        const SizedBox(height: 30),
        FormaBottomNavigation(
          selected: _selectedTab,
          onSelected: (tab) => setState(() => _selectedTab = tab),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.name, this.hex, this.color);

  final String name;
  final String hex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: color == FormaColors.background
                ? Border.all(color: FormaColors.line)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FormaType.body.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(hex, style: FormaType.caption),
            ],
          ),
        ),
      ],
    );
  }
}
