import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/const/customButton.dart';
import '../../../../core/const/custombackbutton.dart';
import 'resetPassScreen.dart';

class otpVerificationScreen extends StatelessWidget {
  const otpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/signInbg.png', fit: BoxFit.fill),
          ),
          Positioned(top: 30.h, left: 8.w, child: custombackbuttom()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                // "Welcome Back" Title
                Center(
                  child: Text(
                    'Verify Code',
                    style: GoogleFonts.lora(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Subtitle
                Center(
                  child: Text(
                    "We've sent a 6-digit code to your email. \nEnter the code below to continue",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                SizedBox(
                  height: 60.h, // Total height for input field area
                  child: PinInputTextField(
                    pinLength: 4,
                    decoration: BoxLooseDecoration(
                      strokeColorBuilder: PinListenColorBuilder(
                        Colors.grey,
                        secondaryColor,
                      ),
                      radius: Radius.circular(3.r),
                      strokeWidth: 2.w,
                      gapSpace: 40.w, // spacing between boxes
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    // textStyle: const TextStyle(
                    //   fontFamily: 'Inter',
                    //   fontSize: 24,
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.black,
                    // ),
                    onChanged: (value) {},
                    onSubmit: (pin) {
                      print('Entered PIN: $pin');
                    },
                  ),
                ),

                SizedBox(height: 30.h),

                /// Verify Button
                Custombutton(
                  text: 'Verify',
                  onPressed: () {
                    Get.to(resetPassScreen());
                  },
                ),

                SizedBox(height: 30.h),

                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: "Don't get the code?  ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                          // Add recognizer to make it tappable
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/signup');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
