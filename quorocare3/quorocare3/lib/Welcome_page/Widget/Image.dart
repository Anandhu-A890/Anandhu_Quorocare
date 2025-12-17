import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/qurocar.png', // replace with your real image if needed
      fit: BoxFit.contain,
      width: MediaQuery.of(context).size.width * 0.9,
    );
  }
}
