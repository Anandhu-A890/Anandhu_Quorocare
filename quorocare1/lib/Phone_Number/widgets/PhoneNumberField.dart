import 'package:flutter/material.dart';
class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<bool> onFocusChanged;
  const PhoneNumberField({
    super.key, 
    required this.controller,
    required this.onFocusChanged,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone number',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Focus(
        onFocusChange: onFocusChanged,
        
        child: Container(
          decoration:BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow:[
                BoxShadow(
                  color:const Color.fromARGB(255, 47, 45, 168),
                  offset:const Offset(0,13),
                  blurRadius:0,
                  spreadRadius:0,
                ),
                BoxShadow(
                  color:Colors.deepPurple.withOpacity(0.2),
                  offset:const Offset(0,8),
                  blurRadius:10,
                  spreadRadius:0,
                ),
            ],
           ),
        
        child:TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration:  InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:const BorderSide(
                color:Colors.black,
                width:1.0,
              ),
            ),
            focusedBorder:OutlineInputBorder(
              borderRadius:BorderRadius.circular(8),
              borderSide:const BorderSide(
                color:Colors.black,
                width:1.5,
              ),
            ),
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(8),
              borderSide:const BorderSide(
                color: Colors.black,
                width:1.0,
              ),
            ),
            contentPadding:const EdgeInsets.symmetric(horizontal:12,vertical:12),

          ),
        ),
       ),
        ), 
      ],
  
    );
  }
}