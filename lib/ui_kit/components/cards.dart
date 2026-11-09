import 'package:flutter/material.dart';

import '../forma_theme.dart';

class FormaMetricCard extends StatelessWidget {
  const FormaMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final foreground = highlighted ? FormaColors.ink : FormaColors.text;
    return Container(
      height: 88,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? FormaColors.accent : FormaColors.surface,
        borderRadius: BorderRadius.circular(FormaSpace.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FormaType.caption.copyWith(
              color: highlighted ? FormaColors.ink : FormaColors.muted,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: FormaType.metric.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}

class FormaMealCard extends StatelessWidget {
  const FormaMealCard({
    super.key,
    required this.title,
    required this.description,
    required this.calories,
  });

  final String title;
  final String description;
  final int calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: FormaColors.surface,
        borderRadius: BorderRadius.circular(FormaSpace.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: FormaType.button),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FormaType.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$calories', style: FormaType.metric),
              Text('ККАЛ', style: FormaType.caption.copyWith(fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
