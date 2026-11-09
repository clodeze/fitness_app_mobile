import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../forma_theme.dart';
import 'actions.dart';

enum FormaTab { home, nutrition, gym, profile }

class FormaBottomNavigation extends StatelessWidget {
  const FormaBottomNavigation({
    super.key,
    required this.selected,
    required this.onSelected,
    this.labelStyle,
  });

  final FormaTab selected;
  final ValueChanged<FormaTab> onSelected;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: FormaColors.surface,
        border: Border.all(color: FormaColors.line),
        borderRadius: BorderRadius.circular(FormaSpace.pillRadius),
      ),
      child: Row(
        children: [
          _item(FormaTab.home, 'Главная', Assets.icons.house),
          _item(FormaTab.nutrition, 'Питание', Assets.icons.utensils),
          _item(FormaTab.gym, 'Зал', Assets.icons.dumbbell),
          _item(FormaTab.profile, 'Профиль', Assets.icons.userRound),
        ],
      ),
    );
  }

  Widget _item(FormaTab tab, String label, SvgGenImage icon) {
    final isSelected = selected == tab;
    final color = isSelected
        ? FormaColors.light
              ? FormaColors.accent
              : FormaColors.ink
        : FormaColors.muted;
    return Expanded(
      child: Semantics(
        selected: isSelected,
        child: Material(
          color: isSelected
              ? FormaColors.light
                    ? FormaColors.ink
                    : FormaColors.accent
              : Colors.transparent,
          borderRadius: BorderRadius.circular(FormaSpace.pillRadius),
          child: InkWell(
            borderRadius: BorderRadius.circular(FormaSpace.pillRadius),
            onTap: () => onSelected(tab),
            child: SizedBox(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormaIcon(glyph: icon, size: 20, color: color),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: (labelStyle ?? FormaType.caption).copyWith(
                      color: color,
                    ),
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
