import 'package:flutter/material.dart';

class SuitcasePainter extends CustomPainter {
  final Color? color;

  const SuitcasePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Styles
    // Use provided color or default blue
    final Color baseColor = color ?? const Color(0xFF5D9CEC);

    // Derive palette
    // If we have a custom grey (like usually passed for arrow), we want shades.
    // Assuming baseColor is the main body color.

    final bodyPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    // Use a darker shade for border/handle
    final Color darkColor =
        color ?? HSVColor.fromColor(baseColor).withValue(0.4).toColor();
    // For specific grey gradient match, we might want to be smarter, but darkening is safe.

    final borderPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final handlePaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.fill;

    final wheelPaint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.fill;

    final ribPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Dimensions
    final double w = size.width;
    final double h = size.height;

    // Suppose we draw the suitcase in the center, taking up e.g. 50% width max and appropriate height
    final double luggageWidth = w * 0.5;
    final double luggageHeight = luggageWidth * 1.4; // Aspect ratio

    final double left = (w - luggageWidth) / 2;
    final double top = (h - luggageHeight) / 2;

    // 1. Wheels
    // We draw wheels first so they are behind (or we can draw them after to pop out). Usually below.
    final double wheelRadius = 10;
    final double wheelOffset = 20;

    canvas.drawCircle(Offset(left + wheelOffset, top + luggageHeight + 5),
        wheelRadius, wheelPaint);
    canvas.drawCircle(
        Offset(left + luggageWidth - wheelOffset, top + luggageHeight + 5),
        wheelRadius,
        wheelPaint);

    // 2. Handle
    // Retract handle (lines going up)
    final double handleBarX1 = left + luggageWidth * 0.35;
    final double handleBarX2 = left + luggageWidth * 0.65;
    final double handleTopY = top - 30;

    // Draw rods
    canvas.drawLine(
        Offset(handleBarX1, top), Offset(handleBarX1, handleTopY), borderPaint);
    canvas.drawLine(
        Offset(handleBarX2, top), Offset(handleBarX2, handleTopY), borderPaint);

    // Draw grip
    final Rect gripRect = Rect.fromCenter(
        center: Offset(left + luggageWidth / 2, handleTopY),
        width: luggageWidth * 0.35,
        height: 10);
    canvas.drawRRect(
        RRect.fromRectAndRadius(gripRect, const Radius.circular(4)),
        handlePaint);

    // 3. Body
    final Rect bodyRect = Rect.fromLTWH(left, top, luggageWidth, luggageHeight);
    final RRect rBodyRect =
        RRect.fromRectAndRadius(bodyRect, const Radius.circular(16));

    canvas.drawRRect(rBodyRect, bodyPaint);
    canvas.drawRRect(rBodyRect, borderPaint);

    // 4. Ribs / Texture
    // Draw 3 or 4 horizontal lines
    for (int i = 1; i <= 4; i++) {
      double y = top + (luggageHeight / 5) * i;
      // Inset slightly
      canvas.drawLine(
          Offset(left + 15, y), Offset(left + luggageWidth - 15, y), ribPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
