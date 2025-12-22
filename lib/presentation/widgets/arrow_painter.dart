import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  /// The color of the arrow.
  final Color color;

  /// Value from 0.0 to 1.0 for the shimmer animation
  final double shimmerValue;

  /// Scale factor for the arrow size (1.0 = 100%)
  final double scale;

  const ArrowPainter({
    this.color = Colors.grey,
    this.shimmerValue = 0.0,
    this.scale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Apply scale transformation
    canvas.save();

    // Scale from center
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    canvas.translate(centerX, centerY);
    canvas.scale(scale, scale);
    canvas.translate(-centerX, -centerY);

    // Create a Gradient to mimic the glossy look
    // Using simple LinearGradient for light to dark transition
    final Rect rect = Offset.zero & size;

    // Base gradient (static body color)
    final Paint bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          // Colors.grey.shade200,
          // Colors.grey.shade400,
          // Colors.grey.shade600,
          Colors.grey.shade200,
          Colors.grey.shade300,
          Colors.grey.shade500,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    // Shimmer/Gloss animation overlay
    // We create a separate paint for the shimmer so it moves over the body
    final Paint shimmerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.0), // Transparent
          Colors.white.withOpacity(0.5), // Highlight
          Colors.white.withOpacity(0.0), // Transparent
        ],
        stops: [
          shimmerValue - 0.2,
          shimmerValue,
          shimmerValue + 0.2,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcATop;

    // Define the path again to be clean
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;

    // Tail Start
    path.moveTo(w * 0.1, h * 0.8);

    // Top Edge of body: Curve up
    // Control point pushes it up-right
    path.quadraticBezierTo(w * 0.4, -h * 0.1, w * 0.8, h * 0.45);

    // Arrow Head - Top Wing
    path.lineTo(w * 0.95, h * 0.35); // Slight outward for the barb

    // Arrow Tip
    path.lineTo(w * 0.9, h * 0.95);

    // Arrow Head - Bottom Wing
    path.lineTo(w * 0.6, h * 0.65);

    // Arrow Head - Inner Corner (Join with body)
    path.lineTo(w * 0.72, h * 0.58);

    // Bottom Edge of body: Curve down back to tail
    // Control point matches roughly to keep parallel-ish thickness
    path.quadraticBezierTo(w * 0.45, h * 0.2, w * 0.15, h * 0.85);

    path.close();

    // Draw Shadow first for depth
    canvas.drawShadow(path, Colors.black, 4.0 * scale, true);

    // Draw Main Body (Static)
    canvas.drawPath(path, bodyPaint);

    // Draw Shimmer Overlay
    // We re-use 'path' to ensure shimmer is clipped to the arrow
    canvas.drawPath(path, shimmerPaint);

    // Top Highlight / Reflection (Glassy effect - Static)
    final Paint highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.9),
          Colors.white.withOpacity(0.1),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Inner path for highlight
    // Simplified: just stroke the top edge
    final Path highlightPath = Path();
    highlightPath.moveTo(w * 0.12, h * 0.82);
    highlightPath.quadraticBezierTo(w * 0.4, 0, w * 0.75, h * 0.48);
    canvas.drawPath(highlightPath, highlightPaint);

    // Outline for crispy definition
    final Paint borderPaint = Paint()
      // ..color = Colors.grey.shade400
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPaint);

    // Restore canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ArrowPainter oldDelegate) {
    return oldDelegate.shimmerValue != shimmerValue ||
        oldDelegate.color != color ||
        oldDelegate.scale != scale;
  }
}
