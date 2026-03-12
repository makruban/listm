import 'package:flutter/material.dart';
import 'dart:math';

class TripProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0 representing completeness
  final double size;
  final Color trackColor;
  final Color progressColor;
  final TextStyle? textStyle;

  const TripProgressIndicator({
    super.key,
    required this.progress,
    this.size = 56.0,
    this.trackColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFFFF7A00), // Vibrant orange
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp progress between 0 and 1 just in case
    final safeProgress = progress.clamp(0.0, 1.0);
    int percentage = (safeProgress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ProgressArcPainter(
          progress: safeProgress,
          trackColor: trackColor,
          progressColor: progressColor,
        ),
        child: Center(
          child: Text(
            '$percentage%',
            style: textStyle ??
                TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.28,
                  letterSpacing: -0.5,
                  color: progress > 0 ? progressColor : Colors.grey.shade600,
                ),
          ),
        ),
      ),
    );
  }
}

class _ProgressArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _ProgressArcPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Determine the geometric properties
    final strokeWidth = size.width * 0.12; // Thicker stroke for modern look
    final center = Offset(size.width / 2, size.height / 2);
    // Draw inside the bounds by subtracting half the stroke width
    final radius = (size.width - strokeWidth) / 2;

    // Based on user image:
    // Gap at the bottom. Start angle is roughly bottom-left (135 degrees).
    // Sweep angle is 270 degrees.
    const startAngle = (135 * pi) / 180.0;
    const sweepAngle = (270 * pi) / 180.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Draw the gray track background
    final trackPaint = Paint()
      ..color = trackColor.withAlpha(150)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false, // useCenter = false for stroke outline
      trackPaint,
    );

    // 2. Draw the colored progress foreground
    if (progress > 0) {
      final currentSweep = sweepAngle * progress;

      // Soft glow shadow behind the progress path
      final shadowPaint = Paint()
        ..color = progressColor.withAlpha(100)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
      
      canvas.drawArc(rect, startAngle, currentSweep, false, shadowPaint);

      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        currentSweep,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
