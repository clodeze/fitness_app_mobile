import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';
import 'food_catalog.dart';
import 'food_widgets.dart';

@RoutePage()
class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key, required this.day, this.initialSlot = 'Ужин'});
  final int day;
  final String initialSlot;

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _search = TextEditingController();
  final Map<FoodProduct, int> _selected = {};
  late String _slot;
  String _category = 'Крупы';

  @override
  void initState() {
    super.initState();
    _slot = widget.initialSlot;
    _search.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _search.removeListener(_refresh);
    _search.dispose();
    super.dispose();
  }

  List<FoodProduct> get _visible =>
      [
        ...sampleProducts,
        ...DemoDashboardScope.of(context).customProducts,
      ].where((product) {
        final query = _search.text.trim().toLowerCase();
        return (query.isNotEmpty || product.category == _category) &&
            (query.isEmpty || product.name.toLowerCase().contains(query));
      }).toList();

  int get _totalCalories => _selected.entries.fold(
    0,
    (sum, entry) => sum + (entry.key.calories * entry.value / 100).round(),
  );

  void _toggle(FoodProduct product) => setState(() {
    if (_selected.containsKey(product)) {
      _selected.remove(product);
    } else {
      _selected[product] = product.portionGrams;
    }
  });

  Future<void> _editWeight(FoodProduct product) async {
    var gramsText = '${_selected[product]}';
    final grams = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: FormaColors.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (dialogContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          8,
          24,
          MediaQuery.viewInsetsOf(dialogContext).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: DashboardStyle.title),
            const SizedBox(height: 8),
            Text('Укажи вес порции', style: DashboardStyle.muted),
            const SizedBox(height: 20),
            Row(
              children: [
                for (final amount in [100, 150, 200, 250])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext, amount),
                        child: Text('$amount г'),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              autofocus: true,
              initialValue: gramsText,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) => gramsText = value,
              decoration: const InputDecoration(
                labelText: 'Свой вес',
                suffixText: 'г',
              ),
            ),
            const SizedBox(height: 20),
            FormaPrimaryButton(
              label: 'Готово',
              trailingIcon: Assets.icons.check,
              onPressed: () =>
                  Navigator.pop(dialogContext, int.tryParse(gramsText)),
            ),
          ],
        ),
      ),
    );
    if (grams != null && grams > 0 && mounted) {
      setState(() => _selected[product] = grams);
    }
  }

  Future<void> _addCustom() async {
    final product = await context.router.root.push<FoodProduct>(
      const CustomFoodRoute(),
    );
    if (product == null || !mounted) return;
    DemoDashboardScope.of(context).addCustomProduct(product);
    _search.clear();
    setState(() {
      _category = product.category;
      _selected[product] = product.portionGrams;
    });
  }

  void _save() {
    if (_selected.isEmpty) return;
    final store = DemoDashboardScope.of(context);
    for (final entry in _selected.entries) {
      final product = entry.key;
      final grams = entry.value;
      store.addMeal(
        DiaryMeal(
          day: widget.day,
          slot: _slot,
          name: product.name,
          grams: grams,
          calories: (product.calories * grams / 100).round(),
          protein: (product.protein * grams / 100).round(),
          fat: (product.fat * grams / 100).round(),
          carbs: (product.carbs * grams / 100).round(),
        ),
      );
    }
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          children: [
            Row(
              children: [
                FormaRoundIconButton(
                  icon: Assets.icons.arrowLeft,
                  tooltip: 'Назад',
                  dimension: 40,
                  onPressed: () => context.router.maybePop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Добавить еду',
                      style: DashboardStyle.title.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FormaColors.line),
              ),
              child: Row(
                children: [
                  for (final slot in const [
                    'Завтрак',
                    'Обед',
                    'Ужин',
                    'Перекус',
                  ])
                    Expanded(
                      child: Material(
                        color: _slot == slot
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => setState(() => _slot = slot),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                slot,
                                style: DashboardStyle.body.copyWith(
                                  color: _slot == slot
                                      ? FormaColors.ink
                                      : FormaColors.muted,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: FormaColors.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: FormaColors.accent),
                    ),
                    child: Row(
                      children: [
                        FormaIcon(
                          glyph: Assets.icons.search,
                          color: FormaColors.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _search,
                            style: DashboardStyle.body.copyWith(fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: 'Поиск продукта',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 26),
                FormaRoundIconButton(
                  icon: Assets.icons.camera,
                  tooltip: 'Сканировать блюдо',
                  accented: true,
                  dimension: 52,
                  iconSize: 24,
                  onPressed: () => context.router.root.push(
                    ScannerCameraRoute(day: widget.day),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_search.text.trim().isNotEmpty && visible.isNotEmpty) ...[
              Material(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  children: [
                    for (final product in visible.take(5))
                      ListTile(
                        title: Text(product.name, style: DashboardStyle.body),
                        subtitle: Text(
                          '${product.calories} ккал / 100 г',
                          style: DashboardStyle.muted,
                        ),
                        onTap: () {
                          if (!_selected.containsKey(product)) _toggle(product);
                          _search.clear();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final category in const [
                    'Крупы',
                    'Мясо и птица',
                    'Рыба',
                    'Овощи',
                    'Молочное',
                    'Снеки',
                    'Напитки',
                  ]) ...[
                    FoodCategoryChip(
                      label: category,
                      selected: _category == category,
                      onTap: () => setState(() => _category = category),
                    ),
                    const SizedBox(width: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'НАЙДЕНО ${visible.length}',
              style: DashboardStyle.muted.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 6),
            for (final product in visible)
              FoodProductRow(
                product: product,
                selected: _selected.containsKey(product),
                onTap: () => _toggle(product),
              ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _addCustom,
              icon: FormaIcon(
                glyph: Assets.icons.plus,
                color: FormaColors.accent,
                size: 20,
              ),
              label: Text(
                'Нет в списке? Добавить свой продукт',
                style: DashboardStyle.body.copyWith(
                  color: FormaColors.accent,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _selected.isEmpty
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                decoration: BoxDecoration(
                  color: FormaColors.raised,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_slot.toUpperCase()} СЕГОДНЯ',
                            style: DashboardStyle.muted.copyWith(fontSize: 12),
                          ),
                        ),
                        Text(
                          '${_selected.length} ${_selected.length == 1 ? 'позиция' : 'позиции'}',
                          style: DashboardStyle.muted.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final entry in _selected.entries)
                            Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => _editWeight(entry.key),
                                    child: Text(
                                      '${entry.key.name} · ${entry.value} г',
                                      style: DashboardStyle.body.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _toggle(entry.key),
                                    icon: FormaIcon(
                                      glyph: Assets.icons.minus,
                                      color: FormaColors.text,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    FormaPrimaryButton(
                      label: 'Добавить в дневник · $_totalCalories ккал',
                      trailingIcon: Assets.icons.check,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
