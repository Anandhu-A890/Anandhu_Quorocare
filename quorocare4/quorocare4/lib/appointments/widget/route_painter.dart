import 'package:flutter/material.dart';
import 'dart:math';
import '../style/styles.dart';



class RoutePainter extends CustomPainter {
  final List<({double latitude, double longitude})> route;
  final int currentRouteIndex;
  final ({double latitude, double longitude}) patientLocation;
  final Random _random = Random(); // Random generator for zig-zag effect

  RoutePainter({
    required this.route,
    required this.currentRouteIndex,
    required this.patientLocation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Define Paints
    final linePaint = Paint()
      ..color = AppColors.primaryBlue.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 2. Coordinate Mapping
    final allLats = route.map((p) => p.latitude).toList()..add(patientLocation.latitude);
    final allLons = route.map((p) => p.longitude).toList()..add(patientLocation.longitude);

    final minLat = allLats.reduce(min);
    final maxLat = allLats.reduce(max);
    final minLon = allLons.reduce(min);
    final maxLon = allLons.reduce(max);

    const horizontalPadding = 0.2; // 20% margin
    const verticalPadding = 0.15; // 15% margin
    final mapWidth = size.width * (1.0 - 2 * horizontalPadding);
    final mapHeight = size.height * (1.0 - 2 * verticalPadding);
    final centerOffset = Offset(size.width * horizontalPadding, size.height * verticalPadding);

    Offset mapPointToOffset(double lat, double lon) {
      final normalizedLon = (lon - minLon) / (maxLon - minLon);
      final normalizedLat = (lat - minLat) / (maxLat - minLat);

      final x = centerOffset.dx + normalizedLon * mapWidth;
      // Y is inverted for screen coordinates (0 is top)
      final y = size.height - centerOffset.dy - normalizedLat * mapHeight;

      return Offset(x, y);
    }

    // 3. Draw the Path (Doctor's current position to Patient)
    if (route.isNotEmpty && currentRouteIndex < route.length) {
      final path = Path();
      
      final currentPoint = mapPointToOffset(
        route[currentRouteIndex].latitude, 
        route[currentRouteIndex].longitude
      );
      path.moveTo(currentPoint.dx, currentPoint.dy);
      
      Offset lastOffset = currentPoint;

      // Draw random, curved segments between route points
      for (int i = currentRouteIndex; i < route.length - 1; i++) {
        final startOffset = mapPointToOffset(route[i].latitude, route[i].longitude);
        final endOffset = mapPointToOffset(route[i + 1].latitude, route[i + 1].longitude);

        // Generate a random curve/zig-zag effect
        final dx = endOffset.dx - startOffset.dx;
        final dy = endOffset.dy - startOffset.dy;

        // Calculate control point that forces a curve
        final controlX1 = startOffset.dx + (dx * 0.3) + (_random.nextDouble() * 30 - 15);
        final controlY1 = startOffset.dy + (dy * 0.7) + (_random.nextDouble() * 30 - 15);

        final controlX2 = startOffset.dx + (dx * 0.7) + (_random.nextDouble() * 30 - 15);
        final controlY2 = startOffset.dy + (dy * 0.3) + (_random.nextDouble() * 30 - 15);
        
        // Use a Cubic Bezier curve for a smooth, complex path
        path.cubicTo(
          controlX1, controlY1, 
          controlX2, controlY2, 
          endOffset.dx, endOffset.dy
        );
        lastOffset = endOffset;
      }
      
      // If the doctor is on the last segment, draw to the patient location
      if (currentRouteIndex == route.length - 1) {
          lastOffset = mapPointToOffset(route.last.latitude, route.last.longitude);
      }
      
      // Draw the final segment to the Patient Location
      final patientOffset = mapPointToOffset(patientLocation.latitude, patientLocation.longitude);
      path.lineTo(patientOffset.dx, patientOffset.dy); // Straight line to the final destination

      canvas.drawPath(path, linePaint);
    }

    // 4. Draw Markers
    final patientOffset = mapPointToOffset(patientLocation.latitude, patientLocation.longitude);
    final doctorOffset = mapPointToOffset(
      route[currentRouteIndex].latitude, 
      route[currentRouteIndex].longitude
    );

    // Home Marker (Patient)
    _drawMarker(canvas, patientOffset, Icons.home, AppColors.primaryBlue, 'Home');

    // Doctor Marker (Car/Hospital)
    _drawIconMarker(canvas, doctorOffset, Icons.local_hospital_rounded, AppColors.lightText, AppColors.primaryBlue);
  }

  // --- Marker Drawing Methods (same as before) ---
  void _drawIconMarker(Canvas canvas, Offset center, IconData icon, Color iconColor, Color borderColor) {
    canvas.drawCircle(center, 18.0, Paint()..color = Colors.white);
    canvas.drawCircle(center, 20.0, Paint()..color = borderColor..style = PaintingStyle.stroke..strokeWidth = 3.0);
    
    final TextPainter iconPainter = TextPainter(textDirection: TextDirection.rtl);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 26.0, fontFamily: icon.fontFamily, color: borderColor, package: icon.fontPackage,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(canvas, Offset(center.dx - 13, center.dy - 13));
  }
  
  void _drawMarker(Canvas canvas, Offset center, IconData icon, Color color, String label) {
    final TextPainter homePainter = TextPainter(textDirection: TextDirection.rtl);
    homePainter.text = TextSpan(
      text: String.fromCharCode(Icons.home_filled.codePoint),
      style: TextStyle(
        fontSize: 45.0, fontFamily: Icons.home_filled.fontFamily, color: color.withOpacity(0.8), package: Icons.home_filled.fontPackage,
      ),
    );
    homePainter.layout();
    
    homePainter.paint(canvas, Offset(center.dx - homePainter.width / 2, center.dy - homePainter.height)); 

    final TextPainter labelPainter = TextPainter(textDirection: TextDirection.rtl);
    labelPainter.text = TextSpan(
      text: label,
      style: AppFonts.subtleText.copyWith(color: AppColors.darkText, fontSize: 10),
    );
    labelPainter.layout();
    labelPainter.paint(canvas, Offset(center.dx - labelPainter.width / 2, center.dy + 5)); 
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) {
    return oldDelegate.currentRouteIndex != currentRouteIndex;
  }
}