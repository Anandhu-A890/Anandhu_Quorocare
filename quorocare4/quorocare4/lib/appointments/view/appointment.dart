// home_view.dart

import 'package:flutter/material.dart';
// Import the custom button widget
import 'package:quorocare4/appointments/widget/appointment_button.dart';

// appointments_page.dart

// ---------------------------------------------
// DUMMY DATA STRUCTURE for the appointment cards
// ---------------------------------------------

class Appointment {
  final String title;
  final String name;
  final String date;
  final String address;
  final String status;
  final bool hasTrackButton;
  Appointment({
    required this.title,
    required this.name,
    required this.date,
    required this.address,
    required this.status,
    this.hasTrackButton = true,
  });
}

// ---------------------------------------------
// APPOINTMENT CARD WIDGET
// ---------------------------------------------
const Color activeTabColor = Color(0xFF23138E);
const Color statusLabelColorConfirmed = Color(0xFF00D2AA);
const Color statusLabelColorOnTheWay = Color(0xFF23138E);
const Color trackButtonColor = Color(0xFF231391);

const Color gradientStartColor = Color(0xFF231391);
const Color gradientEndColor = Color(0xFF887FC6);

class TrackStatusIndicator extends StatelessWidget {
  // progress should be between 0.0 and 1.0
  final double progress;

  const TrackStatusIndicator({Key? key, required this.progress})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        // The Gradient Bar
        Container(
          height: 8, // Thin bar height
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Background color for the empty part
            borderRadius: BorderRadius.circular(4),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(
                  0.0,
                  1.0,
                ), // Clamp progress between 0 and 1
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    // Apply the horizontal gradient
                    gradient: const LinearGradient(
                      colors: [gradientStartColor, gradientEndColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Color statusColor;
  final bool isUpcoming;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.statusColor,
    required this.isUpcoming,
  }) : super(key: key);
  Widget _buildStatusLabel(String status) {
    Color displayColor;
    if (status == 'On the way') {
      displayColor = statusLabelColorOnTheWay; // Dark Purple
    } else if (status == 'Confirmed') {
      displayColor = statusLabelColorConfirmed; // Bright Teal/Green
    } else {
      displayColor = statusColor; // Default for non-upcoming pages
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: displayColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // Helper widget for the "View Details" link (The missing piece)
  Widget _buildViewDetailsButton() {
    return TextButton.icon(
      onPressed: () {
        /* View Details action */
      },
      icon: const Text('View Details', style: TextStyle(color: Colors.black)),
      label: const Icon(Icons.arrow_forward, color: Colors.black),
    );
  }

  // Helper widget for the "Track" button
  Widget _buildTrackButton() {
    return ElevatedButton.icon(
      onPressed: () {
        /* functionality */
      },
      icon: const Icon(Icons.directions_run),
      label: const Text('Track'),
      style: ElevatedButton.styleFrom(
        backgroundColor: trackButtonColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  // The core function to build the action/indicator row
  Widget _buildActionRow() {
    if (!isUpcoming) {
      // Completed/Cancelled tabs don't have a dynamic action row based on the screenshot
      return const SizedBox.shrink();
    }

    if (appointment.title == 'Home Doctor Consultation') {
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
    } else if (appointment.title == 'Home Sample Collection' ||
        appointment.title == 'Clinic Nurse Visit') {
      // Home Sample Collection / Clinic Nurse Visit: View Details (Right)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildViewDetailsButton()],
      );
    }

    // Default or fallback
    return const SizedBox.shrink();
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
              // Border color based on status (Confirmed/On the way)
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: statusLabelColorConfirmed, width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Placeholder for Image (Dummy Image) - Keep your original icon/image logic
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        // Displaying a dummy icon based on title for the screenshot
                        child: Icon(
                          appointment.title.contains('Doctor')
                              ? Icons.medical_services
                              : appointment.title.contains('Sample')
                              ? Icons.science
                              : Icons.local_hospital,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          appointment.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(appointment.name),
                  Text(appointment.date),
                  Text(
                    appointment.address,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  // **THE NEW ACTION ROW CALL**
                  _buildActionRow(),
                ],
              ),
            ),
          ),
          // Status Label (Pinned to Top Right - Only for Upcoming)
          if (isUpcoming)
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
          hasTrackButton: true,
        ),
        Appointment(
          title: 'Home Sample Collection',
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Confirmed',
          hasTrackButton: false,
        ),
        Appointment(
          title: 'Clinic Nurse Visit', // New appointment
          name: 'Sreekrishnan p',
          date: 'Fri, 9 Nov. 5:30PM.',
          address: 'SRA 30, Vadacode thozhukkal neyyattinkara po,695121',
          status: 'Confirmed', // Status for display above card
          hasTrackButton: false,
        ),
      ];
    } else if (pageType == 'Completed') {
      return [
        Appointment(
          title: 'Dental Checkup',
          name: 'Rahul K',
          date: 'Mon, 1 Oct. 10:00AM.',
          address: 'Old Town Hospital, 4th Street',
          status: 'Done',
        ),
      ];
    }
    return [];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return statusLabelColorConfirmed;
      case 'On the way':
        return statusLabelColorOnTheWay;

      case 'Done':
        return Colors.blue.shade500;
      case 'Cancelled':
        return Colors.red.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointments = _getAppointments();
    final isUpcoming = pageType == 'Upcoming';

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final statusColor = _getStatusColor(appointment.status);

        /* return Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align status label to the right
          children: [
            // Status Label above the card (only for Upcoming)
            if (isUpcoming)
              Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                  top: 8.0,
                  bottom: 4.0,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appointment.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

            // The appointment card itself*/
        return AppointmentCard(
          appointment: appointment,
          statusColor: statusColor,
          isUpcoming: isUpcoming,
        );
      },
    );
  }
}
// appointments_page.dart (Add this new class near your other classes)

class PatientSelectionBar extends StatelessWidget {
  const PatientSelectionBar({super.key});

  // Custom rounded border radius matching the TabBar style
  final BorderRadius _buttonBorderRadius = const BorderRadius.all(
    Radius.circular(20.0),
  );
  final Color _primaryColor = const Color(
    0xFF231391,
  ); // Primary Patient Button Color

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Primary Patient Button (Selected Name)
        Expanded(
          flex: 2, // Give more space to the name
          child: ElevatedButton(
            onPressed: () {
              // Handle patient selection logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor, // Background 0xFF231391
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: _buttonBorderRadius),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 0,
            ),
            child: const Text(
              'Sara Salan', // Placeholder for current patient
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // 2. Add Recipient Button
        Expanded(
          flex: 1, // Give less space to the add recipient button
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle add recipient logic
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black, // + sign color
            ),
            label: const Text(
              'Add Recipient',
              style: TextStyle(color: Colors.black),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white, // Background white
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: _buttonBorderRadius),
              side: const BorderSide(
                color: Colors.black12, // Subtle border
                width: 1.0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class AppointmentView extends StatelessWidget {
  const AppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // For Upcoming, Completed, Cancelled
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Appointments'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                /*Handle Search functionality*/
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.black),
              onPressed: () {},
            ),

            const SizedBox(width: 8),
          ],
          // The TabBar is placed inside a Container for styling its background
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120.0), // Height of the TabBar
            child: Column(
              children: [
                // 1. New Patient Selection Bar
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: PatientSelectionBar(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 10.0,
                  ),

                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      // Overall background color of the tab bar area (optional)
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Builder(
                      builder: (BuildContext context) {
                        final TabController tabController =
                            DefaultTabController.of(context);
                        return Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),

                          child: TabBar(
                            labelPadding: EdgeInsets.zero,
                            dividerColor: Colors.transparent,
                            // 1. Custom Indicator Style
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              // The required background color for the selected tab (indicator)
                              //color: const Color(0xFF23138E),
                              color: activeTabColor,
                            ),
                            // 2. Tab Colors and Labels
                            labelColor: Colors
                                .white, // Color of the text for the selected tab
                            unselectedLabelColor: Colors
                                .black54, // Color of the text for unselected tabs

                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),

                            indicatorColor: Colors.transparent,
                            indicatorWeight: 0.1,
                            tabs: const [
                              Tab(child: Center(child: Text('Upcoming'))),
                              Tab(child: Center(child: Text('Completed'))),
                              Tab(child: Center(child: Text('Cancelled'))),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          // TabBarView enables the vertical sliding bar functionality (scrollable content)
          children: [
            AppointmentList(pageType: 'Upcoming'),
            AppointmentList(pageType: 'Completed'),
            AppointmentList(pageType: 'Cancelled'),
          ],
        ),
      ),
    );
  }
}
