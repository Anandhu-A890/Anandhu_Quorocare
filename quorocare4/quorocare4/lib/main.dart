import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/style/styles.dart'; // Import AppColors
import 'package:quorocare4/appointments/view/views.dart'; // Assuming this exports HomeView

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Use the constants defined in AppColors for clarity
  static const Color customPrimary = AppColors.primaryBlue;
  static const Color customAccent = AppColors.activeGreen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        primaryColor: customPrimary,

        
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo, 
            ).copyWith(
              
              primary: customPrimary,
              secondary: customAccent,
            ),
      ),
      home: const HomeView(),
    );
  }
}
