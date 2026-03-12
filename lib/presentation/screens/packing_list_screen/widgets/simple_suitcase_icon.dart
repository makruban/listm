import 'package:flutter/material.dart';

/// A minimalist, flat-vector style suitcase icon based on user reference.
class SimpleSuitcaseIcon extends StatelessWidget {
  final double size;
  final Color color;

  const SimpleSuitcaseIcon({
    super.key,
    this.size = 48.0,
    this.color = const Color(0xFF193B68), // Dark blue from reference image
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SimpleSuitcasePainter(color: color),
      ),
    );
  }
}

class _SimpleSuitcasePainter extends CustomPainter {
  final Color color;

  _SimpleSuitcasePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 1. Draw the handle
    final handlePath = Path()
      ..moveTo(w * 0.425, h * 0.3)
      ..lineTo(w * 0.425, h * 0.15)
      ..quadraticBezierTo(w * 0.425, h * 0.1, w * 0.45, h * 0.1)
      ..lineTo(w * 0.55, h * 0.1)
      ..quadraticBezierTo(w * 0.575, h * 0.1, w * 0.575, h * 0.15)
      ..lineTo(w * 0.575, h * 0.3);

    final handlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.butt;

    canvas.drawPath(handlePath, handlePaint);

    // 2. We use a layer to easily erase the gaps from the main body
    canvas.saveLayer(Rect.fromLTWH(0, 0, w, h), Paint());

    // Main body (Rounded Rectangle)
    final bodyRect = Rect.fromLTRB(w * 0.1, h * 0.3, w * 0.9, h * 0.9);
    final bodyRadius = Radius.circular(w * 0.08);
    canvas.drawRRect(RRect.fromRectAndRadius(bodyRect, bodyRadius), paint);

    // Erase vertical gaps
    final erasePaint = Paint()..blendMode = BlendMode.clear;
    // Left gap
    canvas.drawRect(
        Rect.fromLTRB(w * 0.25, h * 0.3, w * 0.35, h * 0.9), erasePaint);
    // Right gap
    canvas.drawRect(
        Rect.fromLTRB(w * 0.65, h * 0.3, w * 0.75, h * 0.9), erasePaint);

    // Now draw the luggage tag in the left gap
    // Horizontal strap across the gap
    canvas.drawRect(
        Rect.fromLTRB(w * 0.25, h * 0.48, w * 0.35, h * 0.52), paint);

    // Dangling piece of the tag
    final tagPath = Path()
      ..moveTo(w * 0.27, h * 0.52)
      ..lineTo(w * 0.33, h * 0.52)
      ..lineTo(w * 0.33, h * 0.64)
      ..lineTo(w * 0.30, h * 0.68) // point of the tag
      ..lineTo(w * 0.27, h * 0.64)
      ..close();
    canvas.drawPath(tagPath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SimpleSuitcasePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
