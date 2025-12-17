import 'package:flutter/material.dart';
import 'package:quorocare3/Welcome_page/View/welcome_view.dart';

void main() {
  runApp(const QurocareApp());
}

class QurocareApp extends StatelessWidget {
  const QurocareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qurocare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // optional
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const WelcomeView(),
    );
  }
}
