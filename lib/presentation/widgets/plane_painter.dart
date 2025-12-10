import 'dart:math' as math;
import 'package:flutter/material.dart';

class PlanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double globeRadius = w * 0.35;

    // 1. Globe (Water)
    final Paint oceanPaint = Paint()
      ..color = const Color(0xFF4FC3F7) // Light Blue
      ..style = PaintingStyle.fill;

    // Add a gradient for 3D effect
    final Rect globeRect = Rect.fromCircle(center: center, radius: globeRadius);
    final Gradient oceanGradient = RadialGradient(
      colors: [
        const Color(0xFF4FC3F7),
        const Color(0xFF0288D1),
      ],
      center: Alignment.topLeft,
      radius: 1.2,
    );
    oceanPaint.shader = oceanGradient.createShader(globeRect);

    canvas.drawCircle(center, globeRadius, oceanPaint);

    // 2. Landmasses (Simplified shapes)
    final Paint landPaint = Paint()
      ..color = const Color(0xFF66BB6A) // Green
      ..style = PaintingStyle.fill;

    final Path landPath = Path();
    // A simplified continent shape
    landPath.moveTo(
        center.dx - globeRadius * 0.6, center.dy - globeRadius * 0.3);
    landPath.quadraticBezierTo(
        center.dx - globeRadius * 0.2,
        center.dy - globeRadius * 0.8,
        center.dx + globeRadius * 0.4,
        center.dy - globeRadius * 0.2);
    landPath.quadraticBezierTo(
        center.dx + globeRadius * 0.6,
        center.dy + globeRadius * 0.4,
        center.dx - globeRadius * 0.1,
        center.dy + globeRadius * 0.6);
    landPath.quadraticBezierTo(
        center.dx - globeRadius * 0.7,
        center.dy + globeRadius * 0.3,
        center.dx - globeRadius * 0.6,
        center.dy - globeRadius * 0.3);

    // Clip to circle so land doesn't overflow
    canvas.save();
    canvas.clipPath(Path()..addOval(globeRect));
    canvas.drawPath(landPath, landPaint);
    canvas.restore();

    // 3. Flight Path (Dotted Arc)
    final Paint pathPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw an arc wrapping around
    // Simplistic approach for dotted line: manual loop
    final double orbitRadius = globeRadius + 30;

    // We want the plane to be at top right, path coming from bottom left behind
    // Let's draw a partial arc

    for (double i = 0; i < math.pi * 1.5; i += 0.2) {
      double x =
          center.dx + orbitRadius * math.cos(i + math.pi); // Start from left
      double y = center.dy + orbitRadius * math.sin(i + math.pi);

      // canvas.drawPoints(ui.PointMode.points, [Offset(x,y)], pathPaint);
      // Draw small segments
      if (i % 0.4 < 0.2) {
        // crude dashing
        canvas.drawArc(Rect.fromCircle(center: center, radius: orbitRadius),
            i + math.pi, 0.1, false, pathPaint);
      }
    }

    // 4. Plane
    final Paint planePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Position plane at end of path (approx top-ish)
    // Let's place it at angle -pi/4 (top right)
    final double planeAngle = -math.pi / 4;
    final double planeX = center.dx + orbitRadius * math.cos(planeAngle);
    final double planeY = center.dy + orbitRadius * math.sin(planeAngle);

    canvas.save();
    canvas.translate(planeX, planeY);
    // Rotate to face trajectory (tangent to circle is angle + pi/2)
    canvas.rotate(planeAngle + math.pi / 2);

    // Draw simple plane shape
    final Path planePath = Path();
    planePath.moveTo(0, -15); // Nose
    planePath.quadraticBezierTo(5, 0, 15, 10); // Right Wing tip
    planePath.lineTo(5, 10); // Right wing body join
    planePath.lineTo(3, 25); // Tail right
    planePath.lineTo(0, 20); // Tail center
    planePath.lineTo(-3, 25); // Tail left
    planePath.lineTo(-5, 10); // Left wing body join
    planePath.lineTo(-15, 10); // Left wing tip
    planePath.quadraticBezierTo(-5, 0, 0, -15); // Nose join

    canvas.drawPath(planePath, planePaint);

    canvas.restore();

    // 5. Cloud (Optional decoration)
    final Paint cloudPaint = Paint()..color = Colors.white.withOpacity(0.7);
    canvas.drawCircle(
        Offset(center.dx - globeRadius - 20, center.dy + 40), 20, cloudPaint);
    canvas.drawCircle(
        Offset(center.dx - globeRadius + 10, center.dy + 30), 25, cloudPaint);
    canvas.drawCircle(
        Offset(center.dx - globeRadius + 15, center.dy + 50), 18, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
