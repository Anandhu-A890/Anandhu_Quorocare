import 'package:flutter/material.dart';

class AppointmentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AppointmentButton({Key? key, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.calendar_today, size: 24),
        label: const Text('View Appointments', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.indigo.shade50,
          foregroundColor: Colors.black87,
        ),
      ),
    );
  }
}
