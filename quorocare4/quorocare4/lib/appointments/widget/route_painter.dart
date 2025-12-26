import 'package:quorocare4/appointments/style/styles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RoutePainter extends CustomPainter {
  final List<({double latitude, double longitude})> route;
  final int currentRouteIndex;
  final ({double latitude, double longitude}) patientLocation;

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

    final basePaint = Paint()..color = AppColors.primaryBlue;

    // 2. Coordinate Mapping
    // Normalize coordinates based on the bounds of the entire route and patient location.
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

    // Function to map LatLng to screen Offset
    Offset mapPointToOffset(double lat, double lon) {
      final normalizedLon = (lon - minLon) / (maxLon - minLon);
      final normalizedLat = (lat - minLat) / (maxLat - minLat);

      // X: Maps Longitude to width (left to right)
      final x = centerOffset.dx + normalizedLon * mapWidth;
      
      // Y: Maps Latitude (0=minLat, 1=maxLat) to screen height (bottom to top)
      final y = size.height - centerOffset.dy - normalizedLat * mapHeight;
      
      return Offset(x, y);
    }
    
    // 3. Draw the Path (Doctor's current position to Patient)
    if (route.isNotEmpty && currentRouteIndex < route.length) {
      final path = Path();
      
      // Start the path at the doctor's current location
      final doctorOffset = mapPointToOffset(
        route[currentRouteIndex].latitude, 
        route[currentRouteIndex].longitude
      );
      path.moveTo(doctorOffset.dx, doctorOffset.dy);
      
      // Draw lines (poly-line) to the remaining route points
      for (int i = currentRouteIndex + 1; i < route.length; i++) {
        final nextOffset = mapPointToOffset(route[i].latitude, route[i].longitude);
        
        // Use a slight curve/bezier effect for a smoother look like the image
        if (i < route.length - 1) {
            final nextNextOffset = mapPointToOffset(route[i+1].latitude, route[i+1].longitude);
            final controlPoint = Offset(
                (nextOffset.dx + nextNextOffset.dx) / 2,
                nextOffset.dy
            );
            path.lineTo(nextOffset.dx, nextOffset.dy);
        } else {
            path.lineTo(nextOffset.dx, nextOffset.dy);
        }
      }
      
      // The path ends at the patient's location
      final patientOffset = mapPointToOffset(patientLocation.latitude, patientLocation.longitude);
      path.lineTo(patientOffset.dx, patientOffset.dy);
      
      canvas.drawPath(path, linePaint);
    }

    // 4. Draw Markers
    final patientOffset = mapPointToOffset(patientLocation.latitude, patientLocation.longitude);
    final doctorOffset = mapPointToOffset(
      route[currentRouteIndex].latitude, 
      route[currentRouteIndex].longitude
    );

    // Home Marker (Patient) - Placed near the bottom-left of the visualized path
    _drawMarker(canvas, patientOffset, Icons.home, AppColors.primaryBlue, 'Home');

    // Doctor Marker (Car/Hospital) - Placed at the current route index
    _drawIconMarker(canvas, doctorOffset, Icons.local_hospital_rounded, AppColors.lightText, AppColors.primaryBlue);
  }

  void _drawIconMarker(Canvas canvas, Offset center, IconData icon, Color iconColor, Color borderColor) {
    // White background circle
    canvas.drawCircle(center, 18.0, Paint()..color = Colors.white);
    
    // Blue border
    canvas.drawCircle(center, 20.0, Paint()..color = borderColor..style = PaintingStyle.stroke..strokeWidth = 3.0);
    
    // Draw the icon
    final TextPainter iconPainter = TextPainter(textDirection: TextDirection.rtl);
    iconPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 26.0, 
        fontFamily: icon.fontFamily,
        color: borderColor,
        package: icon.fontPackage,
      ),
    );
    iconPainter.layout();
    iconPainter.paint(canvas, Offset(center.dx - 13, center.dy - 13));
  }
  
  void _drawMarker(Canvas canvas, Offset center, IconData icon, Color color, String label) {
    // The patient icon in the image is a custom pin/home icon that is slightly large
    final TextPainter homePainter = TextPainter(textDirection: TextDirection.rtl);
    homePainter.text = TextSpan(
      text: String.fromCharCode(Icons.home_filled.codePoint),
      style: TextStyle(
        fontSize: 45.0, 
        fontFamily: Icons.home_filled.fontFamily,
        color: color.withOpacity(0.8), 
        package: Icons.home_filled.fontPackage,
      ),
    );
    homePainter.layout();
    
    // Custom positioning to make it look like a map pin pointing down
    homePainter.paint(canvas, Offset(center.dx - homePainter.width / 2, center.dy - homePainter.height)); 

    // Text "Home" label (subtle)
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
// --- End of CustomPainter Class ---