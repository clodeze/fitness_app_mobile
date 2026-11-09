import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../forma_theme.dart';

class FormaSegmentedRing extends StatelessWidget {
  const FormaSegmentedRing({
    super.key,
    required this.progress,
    this.label = 'нормы',
    this.size = 158,
    this.center,
  });

  final double progress;
  final String label;
  final double size;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final visibleProgress = progress.clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _FormaRingPainter(visibleProgress),
        child: Center(
          child:
              center ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(visibleProgress * 100).round()}%',
                    style: FormaType.number.copyWith(
                      fontSize: 33,
                      letterSpacing: -1.5,
                    ),
                  ),
                  Text(label, style: FormaType.caption.copyWith(fontSize: 9.5)),
                ],
              ),
        ),
      ),
    );
  }
}

class _FormaRingPainter extends CustomPainter {
  const _FormaRingPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const segments = 64;
    final active = (segments * progress.clamp(0.0, 1.0)).round();
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide * (0.5 - 7 / 292);
    for (var index = 0; index < segments; index++) {
      final angle = -math.pi / 2 + index * 2 * math.pi / segments;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final start =
          center + direction * (outerRadius - size.shortestSide * 0.055);
      final end = center + direction * outerRadius;
      final paint = Paint()
        ..color = index < active ? FormaColors.accent : FormaColors.line
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.butt;
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FormaRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
