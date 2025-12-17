import 'package:flutter/material.dart';
import 'package:quorocare2/Verification/verification_export.dart';

class VerifyNumberView extends StatelessWidget {
  final String phoneNumber;

  const VerifyNumberView({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child:LayoutBuilder(
          builder:(context,constraints){
            return SingleChildScrollView(
              physics:const BouncingScrollPhysics(),
              child:ConstrainedBox(
                constraints:BoxConstraints(minHeight:constraints.maxHeight),
child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height*0.08),

              /// Title and Description Section
                       VerifyTitle(phoneNumber: phoneNumber),

                       const SizedBox(height: 40),

              /// Code Input Field
                       const CodeInputField(),

                       const SizedBox(height: 24),

              /// Resend Section
                       const ResendSection(),

                       const SizedBox(height:40),

              // Submit Button
                       Align(alignment: Alignment.centerRight,
                         child: const SubmitButton(),
                       ),
                       const SizedBox(height: 20)
                       
            ],
          ),
        ),
      ),
    );
  },
  ),
      ),
    );
  }
}