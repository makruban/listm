import 'package:flutter/material.dart';

class ChecklistPainter extends CustomPainter {
  final Color? baseColor;
  ChecklistPainter({this.baseColor});
  @override
  void paint(Canvas canvas, Size size) {
    // Colors
    final boardColor = baseColor ?? const Color(0xFF8D6E63); // Brown
    final paperColor = baseColor ?? Colors.white;
    final clipColor = baseColor ?? const Color(0xFF757575); // Grey
    final textColor =
        baseColor ?? const Color(0xFFBDBDBD); // Light Grey for lines
    final checkColor = baseColor ?? const Color(0xFF4CAF50); // Green
    final circleColor = baseColor ?? const Color(0xFF424242); // Grey

    // Dimensions
    final double w = size.width;
    final double h = size.height;

    // Clipboard dimensions
    final double boardWidth = w * 0.55;
    final double boardHeight = boardWidth * 1.5;
    final double left = (w - boardWidth) / 2;
    final double top = (h - boardHeight) / 2;

    // 1. Draw Board
    final RRect boardRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, boardWidth, boardHeight),
      const Radius.circular(12),
    );
    canvas.drawRRect(boardRRect, Paint()..color = boardColor);

    // 2. Draw Paper
    final double paperMargin = 15;
    final double paperWidth = boardWidth - (paperMargin * 2);
    final double paperHeight =
        boardHeight - (paperMargin * 2) - 30; // Leave space at top for clip
    final double paperTop = top + 40;

    final Rect paperRect =
        Rect.fromLTWH(left + paperMargin, paperTop, paperWidth, paperHeight);
    canvas.drawRect(paperRect, Paint()..color = paperColor);

    // 3. Draw Lines & Checks
    final double lineHeight = 20;
    final double startY = paperTop + 30;
    final int lineCount = 6;

    final linePaint = Paint()
      ..color = textColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final checkPaint = Paint()
      ..color = checkColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < lineCount; i++) {
      double y = startY + (i * 35);

      // Draw Checkbox area (visual only)
      // canvas.drawRect(Rect.fromLTWH(left + paperMargin + 10, y - 10, 15, 15), Paint()..color = Colors.grey.shade200);

      // Draw Checkmark (on first 3 items)
      if (i < 3) {
        Path checkPath = Path();
        double checkX = left + paperMargin + 10;
        double checkY = y;
        checkPath.moveTo(checkX, checkY);
        checkPath.lineTo(checkX + 5, checkY + 5);
        checkPath.lineTo(checkX + 15, checkY - 10);
        canvas.drawPath(checkPath, checkPaint);
      }

      // Draw Line text representation
      canvas.drawLine(
        Offset(left + paperMargin + 35, y),
        Offset(left + paperMargin + paperWidth - 10, y),
        linePaint,
      );
    }

    // 4. Draw Clip (Top)
    final double clipWidth = boardWidth * 0.6;
    final double clipHeight = 30;
    final RRect clipRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w / 2, top + 20),
        width: clipWidth,
        height: clipHeight,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(clipRRect, Paint()..color = clipColor);

    // Tiny metallic hole in clip
    canvas.drawCircle(Offset(w / 2, top + 15), 5, Paint()..color = circleColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
