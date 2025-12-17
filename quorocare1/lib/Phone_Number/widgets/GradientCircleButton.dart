
import 'package:flutter/material.dart';

class GradientCircleButton extends StatelessWidget {
  const GradientCircleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(5, 42, 78, 1), // Dark violet at top
            Color.fromARGB(255, 180, 144, 247), // Light violet
          ],
        ),
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
    );
  }
}