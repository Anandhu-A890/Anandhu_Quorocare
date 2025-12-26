import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' show MapController;
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';
import 'package:quorocare4/appointments/widget/widgets.dart';
import '../style/styles.dart';


// Patient's fixed location (Trivandrum area)
const PatientLocation = (latitude: 8.5, longitude: 76.95);

// Simulated Route Points for the Doctor
const List<({double latitude, double longitude})> DoctorRoute = [
  (latitude: 8.40, longitude: 77.05), // Start point
  (latitude: 8.43, longitude: 77.02),
  (latitude: 8.46, longitude: 76.99),
  (latitude: 8.48, longitude: 76.97),
  (latitude: 8.50, longitude: 76.95), // End point
];


const double AVG_SPEED_KMH = 30.0; // Average speed of care unit in km/h

class TrackMapView extends StatefulWidget {
  const TrackMapView({super.key});

  @override
  State<TrackMapView> createState() => _TrackMapViewState();
}

class _TrackMapViewState extends State<TrackMapView> {
  // State for simulated progress
  int _currentRouteIndex = 0;
  double _currentDistanceKm = 0.0;
  int _estimatedMinutes = 20;
  String _targetAddress = "SRA-30, SUSHMI BHAVAN VADA......";
  String _careUnitStatus = "is on the way!";
  Timer? _routeTimer;
  
  // Kept MapController only for disposal, though not strictly needed if FlutterMap is gone
  final MapController _mapController = MapController();

  // --- HELPER FUNCTIONS ---

  double _calculateDistance(double startLat, double startLon, double endLat, double endLon) {
    // Uses the geolocator package's helper function
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon) / 1000.0; // Convert meters to kilometers
  }

  void _updateDistanceAndEta() {
    final currentPoint = DoctorRoute[_currentRouteIndex];
    final distance = _calculateDistance(
      currentPoint.latitude, currentPoint.longitude, PatientLocation.latitude, PatientLocation.longitude,
    );

    // Calculate ETA: Time (hours) = Distance (km) / Speed (km/h)
    final timeInMinutes = (distance / AVG_SPEED_KMH) * 60;

    setState(() {
      _currentDistanceKm = distance;
      _estimatedMinutes = max(0, timeInMinutes.round()); // Ensure non-negative
      _careUnitStatus = (_currentRouteIndex == DoctorRoute.length - 1) ? "has arrived!" : "is on the way!";

      if (_estimatedMinutes <= 1) {
        _estimatedMinutes = 0;
        _careUnitStatus = "has arrived!";
      }
    });
  }

  // --- SIMULATED TRACKING LOGIC ---

  @override
  void initState() {
    super.initState();
    // Calculate initial status
    _updateDistanceAndEta();
    // Start the timer to move the doctor every few seconds
    _startRouteSimulation();
  }

  @override
  void dispose() {
    _routeTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _startRouteSimulation() {
    _routeTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentRouteIndex < DoctorRoute.length - 1) {
        setState(() {
          _currentRouteIndex++;
          _updateDistanceAndEta();
        });
      } else {
        // Doctor has reached the destination
        timer.cancel();
        // Force update to ensure final 'Arrived' status
        _updateDistanceAndEta();
      }
    });
  }

  // --- CLEANED: Map Area Widget Builder ---
  Widget _buildEmptyMapArea(double height) {
    return Container(
      height: height, // Height is now controlled by the layout
      color: AppColors.backgroundGrey,
      child: CustomPaint(
        painter: RoutePainter(
          route: DoctorRoute,
          currentRouteIndex: _currentRouteIndex,
          patientLocation: PatientLocation,
        ),
        // Use an empty container as a child to ensure the CustomPaint takes up space
        child: Container(),
      ),
    );
  }

  // --- UI BUILDERS (MODIFIED) ---

  Widget _buildStatusCard(BuildContext context, double progress) {
    bool isArrived = _estimatedMinutes <= 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.lightText,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blue divider at the top
          Center(
            child: Container(
              height: 4,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Care Unit Status Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Care unit $_careUnitStatus',
                      style: AppFonts.heading1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArrived
                          ? 'The doctor is at your location.'
                          : 'Our healthcare specialists are on your way, ${_currentDistanceKm.toStringAsFixed(1)} km away.',
                      style: AppFonts.subtleText.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // ETA Badge
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isArrived ? AppColors.activeGreen : AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    isArrived ? 'DONE' : '$_estimatedMinutes\nmins',
                    textAlign: TextAlign.center,
                    style: AppFonts.bodyText.copyWith(
                      color: AppColors.lightText,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          // Assuming TrackStatusIndicator is provided by 'widgets.dart'
          TrackStatusIndicator(progress: progress),
          const SizedBox(height: 16),

          const Divider(height: 30, thickness: 1),

          // Instructions/Call Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Give Instructions about your location',
                style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.w500),
              ),
              // Placeholder for Call Icon/Button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.phone,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  
  Widget _buildAdBanner() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'WHILE YOU WAIT: Join Qurocare Family',
            style: AppFonts.heading1.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4B0082),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.lightText, size: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Qurocare Family @2499/Year', style: AppFonts.heading1.copyWith(color: AppColors.lightText, fontSize: 16)),
                    Text('Protect your closed ones!', style: AppFonts.subtleText.copyWith(color: AppColors.lightText, fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightText,
                  foregroundColor: AppColors.primaryBlue,
                ),
                child: const Text('Join now'),
              )
            ],
          ),
        ),
      ],
    );
  }
  // ---------------------------------------------------

  // --- MAIN BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    // Calculate initial distance and progress
    final initialDistance = _calculateDistance(
      DoctorRoute.first.latitude, DoctorRoute.first.longitude, PatientLocation.latitude, PatientLocation.longitude,
    );
    final finalProgress = initialDistance > 0 ? 1.0 - (_currentDistanceKm / initialDistance) : 1.0;
    
    final mapHeight = MediaQuery.of(context).size.height * 0.55;

    // Use a standard scrollable structure to fix the 'shaking' issue
    return Scaffold(
      appBar: AppBar(
        // Match map background for smooth transition when scrolling
        backgroundColor: AppColors.backgroundGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () {
            Navigator.of(context).pop(finalProgress);
          },
        ),
        // Home Icon and Address
        title: Row(
          mainAxisSize: MainAxisSize.min, // Keep the Row size minimum
          children: [
            // Home Icon
            const Icon(
              Icons.home_outlined,
              color: AppColors.darkText,
              size: 18,
            ),
            const SizedBox(width: 6),
            // Address Text
            Flexible(
              child: Text(
                'Reaching to... $_targetAddress',
                style: AppFonts.subtleText.copyWith(color: AppColors.darkText),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // Use SingleChildScrollView to wrap the entire screen content
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // 1. Map Area - Fixed height
            _buildEmptyMapArea(mapHeight),

            // 2. Status Card - Immediately follows the map and starts the scrollable content
            _buildStatusCard(context, finalProgress),

            // 3. Ad Banner
            _buildAdBanner(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}