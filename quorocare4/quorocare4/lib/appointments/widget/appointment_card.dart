import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/style/styles.dart';
import 'package:quorocare4/appointments/widget/widgets.dart';
import 'package:quorocare4/appointments/view/appointment_details_view.dart';
import 'package:quorocare4/appointments/view/track_map_view.dart'
    hide AppColors, AppFonts;

// ---------------------------------------------
// DUMMY DATA STRUCTURE
// ---------------------------------------------

class Appointment {
  final String title;
  final String name;
  final String date;
  final String address;
  final String status;
  final bool isCompleted;

  Appointment({
    required this.title,
    required this.name,
    required this.date,
    required this.address,
    required this.status,
    this.isCompleted = false,
  });
}

// ---------------------------------------------
// APPOINTMENT CARD WIDGET (STATEFUL)
// ---------------------------------------------

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;
  final bool isUpcoming;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.isUpcoming,
  }) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  // State to hold the dynamic progress of the doctor's vehicle
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize with a non-zero progress if the status is 'On the way'
    if (widget.appointment.status == 'On the way') {
      _currentProgress = 0.3;
    }
  }

  // --- NAVIGATION FUNCTIONS ---

  // Standard navigation to details page
  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AppointmentDetailsView(appointment: widget.appointment),
      ),
    );
  }

  // Navigation to the tracking page, expecting a result back
  void _navigateToTracking(BuildContext context) async {
    // Navigate to the TrackMapView
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const TrackMapView()));

    // Check if the result is a valid progress value (double)
    if (result != null && result is double) {
      setState(() {
        _currentProgress = result;
      });
      // Optionally, show a confirmation snackbar
      if (_currentProgress >= 1.0) {
        // Handle completion logic if progress reached 1.0
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doctor has arrived!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // --- BUILD HELPERS ---

  Widget _buildStatusLabel(String status) {
    Color displayColor = AppColors.backgroundGrey;

    // Check if the current progress is 1.0, which might supersede the initial status
    if (_currentProgress >= 1.0 && widget.isUpcoming && status != 'Cancelled') {
      status = 'Arrived'; // Override status for visual feedback
      displayColor = AppColors.statusLabelColorConfirmed;
    } else if (status == 'On the way') {
      displayColor = AppColors.statusLabelColorOnTheWay;
    } else if (status == 'Confirmed' || status == 'Completed') {
      displayColor = AppColors.statusLabelColorConfirmed;
    } else if (status == 'Cancelled') {
      displayColor = Colors.red.shade600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: displayColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status, style: AppFonts.statusLabel),
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _navigateToDetails(context),
      icon: Text('View Details', style: AppFonts.linkText),
      label: Icon(Icons.arrow_forward, color: AppColors.darkText),
    );
  }

  // Updated to use the tracking navigation function
  Widget _buildTrackButton() {
    return ElevatedButton(
      onPressed: () => _navigateToTracking(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.trackButtonColor,
        foregroundColor: AppColors.lightText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        minimumSize: const Size(90, 36),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_run, size: 20),
          const SizedBox(width: 4),
          Text('Track', style: AppFonts.bodyText),
        ],
      ),
    );
  }

  // The core function to build the action/indicator row
  Widget _buildActionRow(BuildContext context) {
    // Check if the current item is the 'Home Doctor' and is upcoming
    final bool isTrackable =
        widget.isUpcoming &&
        widget.appointment.title.contains('Doctor Consultation');

    if (isTrackable) {
      // If tracking is complete (progress 1.0 or more), show View Details
      if (_currentProgress >= 1.0) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_buildViewDetailsButton(context)],
        );
      }

      // Home Doctor: Show Progress Indicator (Left) + Track Button (Right)
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Pass the dynamic progress state to the indicator
            child: TrackStatusIndicator(progress: _currentProgress),
          ),
          const SizedBox(width: 8), // Spacer
          _buildTrackButton(), // Track button
        ],
      );
    }

    // Logic for other Upcoming appointments (Confirmed status)
    if (widget.isUpcoming && widget.appointment.status == 'Confirmed') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildViewDetailsButton(context)],
      );
    }

    // Logic for Completed/Cancelled Tabs (View Details on the right)
    if (widget.appointment.status == 'Completed' ||
        widget.appointment.status == 'Cancelled') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildViewDetailsButton(context)],
      );
    }

    // Default or fallback
    return const SizedBox.shrink();
  }

  // Icon logic based on the appointment title
  Widget _buildAppointmentIcon() {
    IconData iconData;
    Color iconColor;
    if (widget.appointment.title.contains('Doctor Consultation')) {
      iconData = Icons.medical_services;
      iconColor = AppColors.primaryBlue;
    } else if (widget.appointment.title.contains('Sample Collection')) {
      iconData = Icons.science;
      iconColor = Colors.purple.shade700;
    } else if (widget.appointment.title.contains('Nurse Visit')) {
      iconData = Icons.local_hospital;
      iconColor = Colors.teal.shade700;
    } else {
      iconData = Icons.person;
      iconColor = Colors.grey.shade700;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
      child: Icon(iconData, color: AppColors.lightText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              // Conditional Border Color based on status
              side: BorderSide(
                color:
                    widget.isUpcoming &&
                        widget.appointment.status == 'On the way'
                    ? AppColors.primaryBlue
                    : AppColors.cardBorderColor,
                width: 1.0,
              ),
            ),
            child: InkWell(
              // Tap navigates to details page
              onTap: () => _navigateToDetails(context),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildAppointmentIcon(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.appointment.title,
                            style: AppFonts.cardTitle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(widget.appointment.name, style: AppFonts.bodyText),
                    Text(widget.appointment.date, style: AppFonts.bodyText),
                    Text(
                      widget.appointment.address,
                      style: AppFonts.subtleText,
                    ),
                    const SizedBox(height: 10),

                    // **THE ACTION ROW CALL**
                    _buildActionRow(context),
                  ],
                ),
              ),
            ),
          ),
          // Status Label (Pinned to Top Right)
          Positioned(
            top: 10,
            right: 10,
            // Pass the original status, letting the builder handle the 'Arrived' override
            child: _buildStatusLabel(widget.appointment.status),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------
// APPOINTMENT LIST (Restored to include all original data)
// ---------------------------------------------

class AppointmentList extends StatelessWidget {
  final String pageType;

  const AppointmentList({Key? key, required this.pageType}) : super(key: key);

  // Generate dummy data based on the tab
  List<Appointment> _getAppointments() {
    if (pageType == 'Upcoming') {
      return [
        Appointment(
          title: 'Home Doctor Consultation',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'On the way', // Trackable item
        ),
        Appointment(
          title: 'Home Sample Collection',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Confirmed', // View Details item
        ),
        Appointment(
          title: 'Clinic Nurse Visit',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Confirmed', // View Details item
        ),
      ];
    } else if (pageType == 'Completed') {
      return [
        Appointment(
          title: 'Home Doctor Consultation',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Completed',
          isCompleted: true,
        ),
        Appointment(
          title: 'Home Doctor Consultation',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Completed',
          isCompleted: true,
        ),
        Appointment(
          title: 'Home Doctor Consultation',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Completed',
          isCompleted: true,
        ),
      ];
    } else if (pageType == 'Cancelled') {
      return [
        Appointment(
          title: 'ECG Checkup',
          name: 'Arun M',
          date: 'Tue, 12 Nov. 10:00AM.',
          address: 'City Clinic, Near Main Bus Stop',
          status: 'Cancelled',
          isCompleted: true,
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final appointments = _getAppointments();
    final isUpcoming = pageType == 'Upcoming';

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return AppointmentCard(
          appointment: appointment,
          isUpcoming: isUpcoming,
        );
      },
    );
  }
}
