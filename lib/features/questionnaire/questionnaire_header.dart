import 'package:flutter/material.dart';

import '../../ui_kit/forma_ui_kit.dart';

class QuestionnaireHeader extends StatelessWidget {
  const QuestionnaireHeader({
    super.key,
    required this.step,
    required this.onBack,
  });

  final int step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              FormaRoundIconButton(
                icon: Assets.icons.arrowLeft,
                tooltip: 'Назад',
                dimension: 40,
                iconSize: 20,
                onPressed: onBack,
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: step.toString().padLeft(2, '0'),
                      style: const TextStyle(color: FormaColors.accent),
                    ),
                    const TextSpan(text: ' / 05'),
                  ],
                ),
                style: FormaType.body.copyWith(
                  fontSize: 13,
                  color: FormaColors.muted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            width: double.infinity,
            height: 3,
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  Positioned.fill(child: ColoredBox(color: FormaColors.line)),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: constraints.maxWidth * step / 5,
                    child: const ColoredBox(color: FormaColors.accent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
