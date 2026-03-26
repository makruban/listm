// import 'dart:math' as math;
// import 'package:flutter/material.dart';

// class GlobePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final double w = size.width;
//     final double h = size.height;
//     final Offset center = Offset(w / 2, h / 2);
//     // Use a slightly smaller radius than full width to leave room for effects/margin
//     final double radius = math.min(w, h) * 0.4;

//     // 1. Globe Background (Ocean)
//     final Paint oceanPaint = Paint()
//       ..shader = RadialGradient(
//         colors: [
//           const Color(0xFF4FC3F7), // Lighter blue
//           const Color(0xFF0288D1), // Darker blue
//         ],
//         center: Alignment.topLeft,
//         radius: 1.5,
//       ).createShader(Rect.fromCircle(center: center, radius: radius));

//     canvas.drawCircle(center, radius, oceanPaint);

//     // 2. Lat/Lon Lines (Meridians/Parallels)
//     final Paint linePaint = Paint()
//       ..color = Colors.white.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;

//     // Draw Longitude lines (Curves)
//     for (int i = 0; i < 5; i++) {
//       // Logic for curves mimicking 3D sphere
//       // Simplified approach: Draw ovals of varying width centered on the globe
//       double widthFactor = (i + 1) / 5;
//       Rect ovalRect = Rect.fromCenter(
//         center: center,
//         width: radius * 2 * widthFactor,
//         height: radius * 2,
//       );
//       canvas.drawOval(ovalRect, linePaint);
//     }
//     // Vertical center line
//     canvas.drawLine(Offset(center.dx, center.dy - radius),
//         Offset(center.dx, center.dy + radius), linePaint);

//     // Draw Latitude lines (Horizontal curves or Straight lines for simplicity in 2D projection)
//     // To look 3D, latitudes are ellipses too, but horizontal
//     for (int i = 1; i < 4; i++) {
//       double heightFactor = i / 4; // 0.25, 0.5, 0.75
//       // Top hemisphere
//       _drawLatitude(canvas, center, radius, heightFactor, linePaint);
//       // Bottom hemisphere
//       _drawLatitude(canvas, center, radius, -heightFactor, linePaint);
//     }
//     // Equator
//     canvas.drawLine(
//       Offset(center.dx - radius, center.dy),
//       Offset(center.dx + radius, center.dy),
//       linePaint,
//     );

//     // 3. Continents (Stylized abstract shapes)
//     final Paint continentPaint = Paint()
//       ..color = const Color(0xFF81C784).withOpacity(0.9) // Light Green
//       ..style = PaintingStyle.fill;

//     // Create a path for some "lands"
//     final Path landPath = Path();

//     // Abstract "Americas" shape on left
//     landPath.moveTo(center.dx - radius * 0.6, center.dy - radius * 0.5);
//     landPath.quadraticBezierTo(
//         center.dx - radius * 0.3,
//         center.dy - radius * 0.2,
//         center.dx - radius * 0.5,
//         center.dy + radius * 0.1);
//     landPath.quadraticBezierTo(
//         center.dx - radius * 0.6,
//         center.dy + radius * 0.5,
//         center.dx - radius * 0.4,
//         center.dy + radius * 0.6);
//     landPath.quadraticBezierTo(
//         center.dx - radius * 0.8,
//         center.dy + radius * 0.3,
//         center.dx - radius * 0.6,
//         center.dy - radius * 0.5);

//     // Abstract "Eurasia/Africa" shape on right
//     landPath.moveTo(center.dx + radius * 0.2, center.dy - radius * 0.6);
//     landPath.quadraticBezierTo(
//         center.dx + radius * 0.6,
//         center.dy - radius * 0.4,
//         center.dx + radius * 0.7,
//         center.dy - radius * 0.1);
//     landPath.quadraticBezierTo(
//         center.dx + radius * 0.5,
//         center.dy + radius * 0.4,
//         center.dx + radius * 0.2,
//         center.dy + radius * 0.3);
//     landPath.quadraticBezierTo(
//         center.dx + radius * 0.1,
//         center.dy - radius * 0.2,
//         center.dx + radius * 0.2,
//         center.dy - radius * 0.6);

//     canvas.drawPath(landPath, continentPaint);

//     // 4. Globe Border/Gloss (Rim)
//     final Paint borderPaint = Paint()
//       ..color = Colors.white.withOpacity(0.2)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;

//     canvas.drawCircle(center, radius, borderPaint);

//     // Gloss highlight (top left)
//     final Paint highlightPaint = Paint()
//       ..shader = LinearGradient(
//         colors: [Colors.white.withOpacity(0.6), Colors.transparent],
//         begin: Alignment.topLeft,
//         end: Alignment.center,
//       ).createShader(Rect.fromCircle(center: center, radius: radius));

//     // Draw a smaller oval for highlight
//     canvas.drawOval(
//         Rect.fromCenter(
//             center: Offset(center.dx - radius * 0.4, center.dy - radius * 0.4),
//             width: radius * 0.5,
//             height: radius * 0.3),
//         highlightPaint);
//   }

//   void _drawLatitude(Canvas canvas, Offset center, double radius,
//       double dyFactor, Paint paint) {
//     // dyFactor is -1 to 1 (relative to radius)
//     // Calculate the width of the circle at this latitude
//     // x^2 + y^2 = r^2  => x = sqrt(r^2 - y^2)
//     double y = center.dy + radius * dyFactor;
//     double rAtY =
//         math.sqrt(radius * radius - (radius * dyFactor) * (radius * dyFactor));

//     // Draw a flat line or curve?
//     // Let's draw a line from -x to +x at y
//     canvas.drawLine(
//       Offset(center.dx - rAtY, y),
//       Offset(center.dx + rAtY, y),
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
