import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../forma_theme.dart';
import 'actions.dart';

class FormaGoalTile extends StatelessWidget {
  const FormaGoalTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  final String label;
  final SvgGenImage icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? FormaColors.ink : FormaColors.text;
    return Semantics(
      selected: selected,
      child: Material(
        color: selected ? FormaColors.accent : FormaColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FormaSpace.goalRadius),
          side: selected
              ? BorderSide.none
              : BorderSide(color: FormaColors.line),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(FormaSpace.goalRadius),
          onTap: onTap,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FormaIcon(glyph: icon, size: 20, color: foreground),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: FormaType.body.copyWith(
                        color: foreground,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (selected)
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: FormaColors.surface,
                      child: FormaIcon(
                        glyph: Assets.icons.check,
                        size: 22,
                        color: FormaColors.text,
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

class FormaChoiceChip extends StatelessWidget {
  const FormaChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? FormaColors.light
              ? FormaColors.surface
              : FormaColors.ink
        : FormaColors.text;
    return Semantics(
      selected: selected,
      child: Material(
        color: selected
            ? FormaColors.light
                  ? FormaColors.ink
                  : FormaColors.text
            : FormaColors.background,
        shape: StadiumBorder(
          side: selected
              ? BorderSide.none
              : BorderSide(color: FormaColors.line),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 39,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: foreground,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: FormaType.body.copyWith(
                      fontSize: 11,
                      color: foreground,
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
