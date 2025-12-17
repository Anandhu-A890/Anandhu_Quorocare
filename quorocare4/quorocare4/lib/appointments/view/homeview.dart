// home_view.dart

import 'package:flutter/material.dart';
// Assuming you have defined the widget and the new page in separate files
import 'package:quorocare4/appointments/widget/appointment_button.dart';
import 'package:quorocare4/appointments/view/appointment.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  void _handleAppointmentsTap(BuildContext context) {
    // Navigate to the AppointmentsPage when the button is pressed
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AppointmentView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        // Use the custom AppointmentButton widget
        child: AppointmentButton(
          onPressed: () => _handleAppointmentsTap(context),
        ),
      ),
    );
  }
}
