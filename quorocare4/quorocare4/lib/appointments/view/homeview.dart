import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/view/views.dart';
import 'package:quorocare4/appointments/widget/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  void _handleAppointmentsTap(BuildContext context) {
    
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AppointmentView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: AppointmentButton(
          onPressed: () => _handleAppointmentsTap(context),
        ),
      ),
    );
  }
}
