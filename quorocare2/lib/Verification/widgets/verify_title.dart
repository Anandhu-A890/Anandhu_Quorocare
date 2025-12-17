import 'package:flutter/material.dart';
import 'package:quorocare2/core/app_color.dart';

class VerifyTitle extends StatelessWidget {
  final String phoneNumber;

  const VerifyTitle({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Verify your number",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color:Colors.black87,
            fontSize:30,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Enter the code we’ve shared by text to $phoneNumber",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color.fromARGB(188, 21, 1, 1),
            height:1.4,
            fontSize:21,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Handle change number
          },
          child:  Text(
            "Change number",
            style: TextStyle(
              color: AppColor.changeNumberTextColor,
              fontWeight: FontWeight.w600,
              fontSize:19,
            ),
          ),
        ),
      ],
    );
  }
}
