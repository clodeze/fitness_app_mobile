import 'package:flutter/material.dart';

import '../../ui_kit/forma_theme.dart';

class FoodPlatePainter extends CustomPainter {
  FoodPlatePainter({this.showCorners = true});

  final bool showCorners;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 278;
    canvas.scale(scale);
    final plate = Paint()..color = const Color(0xFF1F1F22);
    canvas.drawCircle(const Offset(139, 139), 131, plate);
    canvas.drawCircle(
      const Offset(139, 139),
      130,
      Paint()
        ..color = const Color(0xFF2A2A2E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(
      const Offset(139, 139),
      101,
      Paint()..color = const Color(0xFF27272A),
    );
    canvas.drawCircle(
      const Offset(105, 154),
      52,
      Paint()..color = const Color(0xFFE8E4D2),
    );
    canvas.drawCircle(
      const Offset(94, 140),
      14,
      Paint()..color = const Color(0xFFF4F0DF),
    );
    final chicken = Path()
      ..moveTo(151, 91)
      ..cubicTo(166, 76, 177, 84, 192, 91)
      ..cubicTo(216, 101, 229, 110, 224, 128)
      ..cubicTo(219, 151, 204, 149, 183, 140)
      ..cubicTo(159, 130, 140, 111, 151, 91)
      ..close();
    canvas.drawPath(chicken, Paint()..color = const Color(0xFFC98A45));
    final second = Path()
      ..moveTo(167, 138)
      ..cubicTo(181, 132, 203, 130, 216, 139)
      ..cubicTo(228, 148, 234, 169, 216, 176)
      ..lineTo(176, 190)
      ..cubicTo(157, 195, 148, 177, 153, 158)
      ..cubicTo(156, 148, 160, 141, 167, 138)
      ..close();
    canvas.drawPath(second, Paint()..color = const Color(0xFFB57632));
    canvas.drawCircle(
      const Offset(184, 205),
      8,
      Paint()..color = const Color(0xFF5F903C),
    );
    canvas.drawCircle(
      const Offset(198, 195),
      12,
      Paint()..color = const Color(0xFF76A348),
    );
    canvas.drawCircle(
      const Offset(222, 188),
      10,
      Paint()..color = const Color(0xFF88B153),
    );
    if (!showCorners) return;
    final corners = Paint()
      ..color = FormaColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final corner in [
      [
        const Offset(0, 42),
        const Offset(0, 22),
        const Offset(22, 0),
        const Offset(44, 0),
      ],
      [
        const Offset(234, 0),
        const Offset(256, 0),
        const Offset(278, 22),
        const Offset(278, 42),
      ],
      [
        const Offset(0, 236),
        const Offset(0, 256),
        const Offset(22, 278),
        const Offset(44, 278),
      ],
      [
        const Offset(234, 278),
        const Offset(256, 278),
        const Offset(278, 256),
        const Offset(278, 236),
      ],
    ]) {
      final path = Path()
        ..moveTo(corner[0].dx, corner[0].dy)
        ..lineTo(corner[1].dx, corner[1].dy)
        ..quadraticBezierTo(
          corner[2].dx,
          corner[2].dy,
          corner[3].dx,
          corner[3].dy,
        );
      canvas.drawPath(path, corners);
    }
  }

  @override
  bool shouldRepaint(covariant FoodPlatePainter oldDelegate) =>
      oldDelegate.showCorners != showCorners;
}
