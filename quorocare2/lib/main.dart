import 'package:flutter/material.dart';
import 'package:quorocare2/Verification/view/verify_number_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Verification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Roboto'
      ),
      home: const VerifyNumberView(
        phoneNumber: '+919074026293',
      ),
    );
  }
}
