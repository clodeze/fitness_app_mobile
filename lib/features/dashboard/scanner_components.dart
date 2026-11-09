import 'package:flutter/material.dart';

import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';

class ScannerPortionAction extends StatelessWidget {
  const ScannerPortionAction({
    super.key,
    required this.icon,
    required this.active,
    required this.onTap,
    this.accented = false,
  });
  final SvgGenImage icon;
  final bool active;
  final bool accented;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: accented ? FormaColors.accent : FormaColors.raised,
    shape: CircleBorder(
      side: accented ? BorderSide.none : BorderSide(color: FormaColors.line),
    ),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: active ? onTap : null,
      child: SizedBox.square(
        dimension: 42,
        child: Center(
          child: FormaIcon(
            glyph: icon,
            color: accented ? FormaColors.ink : FormaColors.muted,
            size: 18,
          ),
        ),
      ),
    ),
  );
}

class ScannerNutrient extends StatelessWidget {
  const ScannerNutrient({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });
  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 61,
      decoration: BoxDecoration(
        color: FormaColors.raised,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: DashboardStyle.title.copyWith(fontSize: 18, color: color),
          ),
          Text(label, style: DashboardStyle.small),
        ],
      ),
    ),
  );
}

class ScannerIngredient extends StatelessWidget {
  const ScannerIngredient({super.key, required this.name, required this.grams});
  final String name;
  final int grams;

  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: FormaColors.line)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: DashboardStyle.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '$grams г',
          style: DashboardStyle.body.copyWith(
            fontSize: 14,
            color: FormaColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
