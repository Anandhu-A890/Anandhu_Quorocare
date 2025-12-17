import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeInputField extends StatefulWidget {
  const CodeInputField({Key? key}) : super(key: key);

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  final int _otpLength=6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for(final controller in _controllers){
      controller.dispose();
    }
    for (final node in _focusNodes){
      node.dispose();
    }
    super.dispose();
  }
  
  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field automatically
      if (index < _otpLength - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus(); // Close keyboard
      }
    
  } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final boxSize=width*0.11;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        const Text(
          "Code",
          style:TextStyle(
            fontSize:20,
            fontWeight:FontWeight.w600,
            color:Colors.black,
          ),
        ),
        Center(
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_otpLength, (index) {
          return SizedBox(
            width: boxSize + 4,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              onChanged: (value) => _onChanged(value, index),
              style:const TextStyle(
                fontSize: 28, // ⬆️ clear and bold digits
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(229, 0, 0, 0), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
                );
              }),
             ),
             ),
      ],
    );
  }
}