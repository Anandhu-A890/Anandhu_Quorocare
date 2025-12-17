import 'package:flutter/material.dart';
import 'package:quorocare1/Phone_Number/widgets/GradientCircleButton.dart';
import 'package:quorocare1/Phone_Number/widgets/PhoneNumberField.dart';
import 'package:quorocare1/Phone_Number/widgets/countrycodefield.dart';
class PhoneNumberForm extends StatefulWidget {
  const PhoneNumberForm({super.key});

  @override
  State<PhoneNumberForm> createState() => _PhoneNumberFormState();
}

class _PhoneNumberFormState extends State<PhoneNumberForm> {
  final List<String> _countryCodeController =
       ['IN +91', 'US +1', 'UK +44', 'AU +61', 'CA +1'];
    String _selectedCountryCode = 'IN +91';
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonVisible= false;
  
  @override
  void initState(){
    super.initState();
    _phoneController.addListener(_updateButtonVisibility);
  }

  @override
  void dispose(){
    _phoneController.removeListener(_updateButtonVisibility);
    _phoneController.dispose();
    super.dispose();
  }

  void _updateButtonVisibility(){
    setState((){
      _isButtonVisible= _phoneController.text.isNotEmpty;
    });
  }


  void _submit() {
    // Your submit logic here
    final phone = _phoneController.text;
    final countryCode = _selectedCountryCode;
    print('Submitting: $countryCode $phone');
  }
  
  void _onFocusChanged(bool hasFocus){
    setState(() {
      _isButtonVisible= hasFocus || _phoneController.text.isNotEmpty;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
        "Can we get your number, please?",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        "We only use phone numbers to make sure you get quality care",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 20,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 28),

          
      Padding(
        padding:const EdgeInsets.only(top:35.0), 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryCodeField(options: _countryCodeController,
                selectedCode: _selectedCountryCode,
              onChanged: (value) {
                setState(() {
                  _selectedCountryCode = value ?? _countryCodeController.first;
                });
              },
            ),
            
            const SizedBox(width: 12),
            Expanded(
              child: PhoneNumberField(
                controller: _phoneController,
                onFocusChanged: _onFocusChanged,
                ),
              ),
          ],
       ),
    ),        
      const SizedBox(height:80),
      Align(
          alignment: Alignment.centerRight,
          child: AnimatedOpacity(
            opacity:_isButtonVisible ? 1.0 : 0.0,
            duration:const Duration(milliseconds:300),
            child: IgnorePointer(
              ignoring: !_isButtonVisible,
              child:GestureDetector(
               onTap: _submit,
               child: const GradientCircleButton(),
        ),
        ),
          ),
        ),
        const SizedBox(height:30),
      ],
      ),
    );   
    
  }
}