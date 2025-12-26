import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/style/styles.dart';
import 'package:quorocare4/appointments/view/views.dart'
    hide AppColors, AppFonts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Color customPrimary = AppColors.primaryBlue;
  static Color customAccent = AppColors.activeGreen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: customPrimary,

        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(primary: customPrimary, secondary: customAccent),
      ),
      home: const HomeView(),
    );
  }
}
