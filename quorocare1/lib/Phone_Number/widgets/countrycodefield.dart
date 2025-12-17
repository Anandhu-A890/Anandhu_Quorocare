import 'package:flutter/material.dart';
class CountryCodeField extends StatelessWidget {
  const CountryCodeField({
    super.key, 
    required this.options,
    required this.selectedCode,
    required this.onChanged,});
  final List<String> options;
  final String selectedCode;
  final ValueChanged<String?> onChanged;


 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Country',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 118,
          child:  DropdownButtonFormField<String>(
            value: selectedCode,
            onChanged: onChanged,
            items: options.map((code) {
              return DropdownMenuItem<String>(
                value: code,
                child: Text(code),
              );
            }).toList(),
            decoration:  InputDecoration(
              border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),  
              ),
            ),
          ),
      ],
    );
  }
}