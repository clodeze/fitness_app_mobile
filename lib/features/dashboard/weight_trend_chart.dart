import 'package:flutter/material.dart';

import '../../ui_kit/forma_theme.dart';

/// Shared seven-day weight trend used on the profile and progress screens.
class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart({super.key, this.height = 72});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(painter: _WeightTrendPainter(color: FormaColors.accent)),
  );
}

class _WeightTrendPainter extends CustomPainter {
  const _WeightTrendPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const values = [0.60, 0.49, 0.36, 0.47, 0.26, 0.26, 0.14];
    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(
          size.width * i / (values.length - 1),
          size.height * (1 - values[i]),
        ),
    ];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    for (final point in points) {
      canvas.drawCircle(point, 2.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightTrendPainter oldDelegate) =>
      color != oldDelegate.color;
}
