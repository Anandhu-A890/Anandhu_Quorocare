import 'package:flutter/material.dart';
import '../style/styles.dart';

class TrackStatusIndicator extends StatelessWidget {
  final double progress; // progress should be between 0.0 and 1.0

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
            color:
                AppColors.backgroundGrey, // Background color for the empty part
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
                      colors: [AppColors.primaryBlue, AppColors.accentPurple],
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
