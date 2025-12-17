import 'package:flutter/material.dart';
import 'package:quorocare1/Phone_Number/widgets/phonenumberform.dart';

class PhoneNumberPage extends StatelessWidget {
  const PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: PhoneNumberForm(),
      ),
    );
  }
}
