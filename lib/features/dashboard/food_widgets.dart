import 'package:flutter/material.dart';

import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'food_catalog.dart';

class FoodCategoryChip extends StatelessWidget {
  const FoodCategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? FormaColors.accent : FormaColors.background,
    shape: StadiumBorder(
      side: BorderSide(color: selected ? Colors.transparent : FormaColors.line),
    ),
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Text(
            label,
            style: DashboardStyle.body.copyWith(
              color: selected ? FormaColors.ink : FormaColors.text,
              fontSize: 13,
            ),
          ),
        ),
      ),
    ),
  );
}

class FoodProductRow extends StatelessWidget {
  const FoodProductRow({
    super.key,
    required this.product,
    required this.selected,
    required this.onTap,
  });
  final FoodProduct product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    height: 64,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: FormaColors.line)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DashboardStyle.body.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'на 100 г · Б ${product.protein} · Ж ${product.fat} · У ${product.carbs}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DashboardStyle.muted.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 7),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${product.calories}',
              style: DashboardStyle.title.copyWith(fontSize: 18),
            ),
            Text('ккал', style: DashboardStyle.small),
          ],
        ),
        const SizedBox(width: 13),
        FormaRoundIconButton(
          icon: selected ? Assets.icons.check : Assets.icons.plus,
          tooltip: selected ? 'Удалить' : 'Добавить',
          accented: selected,
          dimension: 44,
          iconSize: 20,
          onPressed: onTap,
        ),
      ],
    ),
  );
}
