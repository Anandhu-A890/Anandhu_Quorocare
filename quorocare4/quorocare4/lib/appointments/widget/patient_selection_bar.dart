import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/style/styles.dart';

class PatientSelectionBar extends StatelessWidget {
  const PatientSelectionBar({super.key});

  final BorderRadius _buttonBorderRadius = const BorderRadius.all(
    Radius.circular(20.0),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Primary Patient Button (Selected Name)
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle patient selection logic
            },
            icon: const Icon(Icons.person, size: 18),
            label: const Text(
              'Sara Salan', // Placeholder for current patient
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.lightText,
              shape: RoundedRectangleBorder(borderRadius: _buttonBorderRadius),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // 2. Add Recipient Button
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {
              // Handle add recipient logic
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.darkText,
              shape: RoundedRectangleBorder(borderRadius: _buttonBorderRadius),
              side: const BorderSide(color: Colors.black12, width: 1.0),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, size: 18),
                Text(
                  'Add', // Shorten label for space
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
