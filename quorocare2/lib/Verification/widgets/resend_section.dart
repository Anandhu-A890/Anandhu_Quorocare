import 'package:flutter/material.dart';

class ResendSection extends StatelessWidget {
  const ResendSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    return Center(
      child:Row(
      children: [
         Text("Didn’t get the code? ",
         style:TextStyle(
          color:Color.fromARGB(241, 8, 0, 0),
          fontSize:15,
         ),
         ),
        GestureDetector(
          onTap: () {
            // Handle resend code
          },
          child:  Text(
            "Resend",
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
              fontSize:15
            ),
          ),
        ),
      ],
      ),
    );
  }
}
