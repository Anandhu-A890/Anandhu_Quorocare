import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/style/styles.dart';
import 'package:quorocare4/appointments/widget/widgets.dart';
import 'package:quorocare4/appointments/view/appointment_details_view.dart'; // Import for navigation

// ---------------------------------------------
// DUMMY DATA STRUCTURE for the appointment cards
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
// APPOINTMENT CARD WIDGET
// ---------------------------------------------

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isUpcoming;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.isUpcoming,
  }) : super(key: key);

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppointmentDetailsView(appointment: appointment),
      ),
    );
  }

  Widget _buildStatusLabel(String status) {
    Color displayColor = AppColors.backgroundGrey; // Default/Fallback

    if (status == 'On the way') {
      displayColor = AppColors.statusLabelColorOnTheWay; // Dark Purple
    } else if (status == 'Confirmed' || status == 'Completed') {
      displayColor = AppColors.statusLabelColorConfirmed; // Bright Teal/Green
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

  // Helper widget for the "View Details" link
  Widget _buildViewDetailsButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _navigateToDetails(context),
      icon: const Text('View Details', style: AppFonts.linkText),
      label: const Icon(Icons.arrow_forward, color: AppColors.darkText),
    );
  }

  // Helper widget for the "Track" button
  Widget _buildTrackButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement tracking logic
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.trackButtonColor,
        foregroundColor: AppColors.lightText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        minimumSize: const Size(90, 36), // Adjusted size for better look
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.directions_run, size: 20),
          SizedBox(width: 4),
          Text('Track', style: AppFonts.bodyText),
        ],
      ),
    );
  }

  // The core function to build the action/indicator row
  Widget _buildActionRow(BuildContext context) {
    // Logic for Upcoming Tab
    if (isUpcoming) {
      if (appointment.title.contains('Doctor Consultation')) {
        // Home Doctor: Progress Indicator (Left) + Track Button (Right)
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: TrackStatusIndicator(progress: 0.7), // Progress bar
            ),
            const SizedBox(width: 8), // Spacer
            _buildTrackButton(), // Track button
          ],
        );
      } else if (appointment.status == 'Confirmed') {
        // Home Sample Collection / Clinic Nurse Visit: View Details (Right)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_buildViewDetailsButton(context)],
        );
      }
    }

    // Logic for Completed/Cancelled Tabs (View Details on the right)
    if (appointment.status == 'Completed' ||
        appointment.status == 'Cancelled') {
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
    if (appointment.title.contains('Doctor Consultation')) {
      iconData = Icons.medical_services;
      iconColor = AppColors.primaryBlue;
    } else if (appointment.title.contains('Sample Collection')) {
      iconData = Icons.science;
      iconColor = Colors.purple.shade700;
    } else if (appointment.title.contains('Nurse Visit')) {
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
                color: isUpcoming && appointment.status == 'On the way'
                    ? AppColors.primaryBlue
                    : AppColors.cardBorderColor,
                width: 1.0,
              ),
            ),
            child: InkWell(
              onTap:
                  !isUpcoming || appointment.title != 'Home Doctor Consultation'
                  ? () => _navigateToDetails(context)
                  : null, // Allow tapping if it's not a 'trackable' upcoming item
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
                            appointment.title,
                            style: AppFonts.cardTitle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(appointment.name, style: AppFonts.bodyText),
                    Text(appointment.date, style: AppFonts.bodyText),
                    Text(appointment.address, style: AppFonts.subtleText),
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
            child: _buildStatusLabel(appointment.status),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------
// APPOINTMENT LIST (The Content of Each Tab)
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
          status: 'On the way',
        ),
        Appointment(
          title: 'Home Sample Collection',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Confirmed',
        ),
        Appointment(
          title: 'Clinic Nurse Visit',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Confirmed',
        ),
      ];
    } else if (pageType == 'Completed') {
      return [
        Appointment(
          title: 'Home Doctor Consultation',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Completed', // Changed from Done/Completed
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
