import 'package:flutter/material.dart';
//import 'package:quorocare4/appointments/view/appointment.dart';

// Import all necessary files
import 'package:quorocare4/appointments/view/homeview.dart';
// Note: In a real project, you would need to adjust the import paths
// (e.g., 'package:quorocare4/appointments/widget/appointment_button.dart').

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeView(),
    );
  }
}
