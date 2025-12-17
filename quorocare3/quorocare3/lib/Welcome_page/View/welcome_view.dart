import 'package:flutter/material.dart';
import 'package:quorocare3/Welcome_page/Widget/Header.dart';
import 'package:quorocare3/Welcome_page/Widget/Image.dart';
import 'package:quorocare3/Welcome_page/Widget/Welcome_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Spacer(flex: 1),
              WelcomeHeader(),
              Spacer(flex: 2),
              WelcomeImage(),
              Spacer(flex: 2),
              WelcomeButton(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
