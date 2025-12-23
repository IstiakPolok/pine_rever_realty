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
import '../controller/otpVerificationController.dart';
import 'resetPassScreen.dart';

class otpVerificationScreen extends StatelessWidget {
  final String? email;
  const otpVerificationScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final OtpVerificationController controller = Get.put(
      OtpVerificationController(),
    );
    // Always set email in controller if provided
    if (email != null && controller.email != email) {
      controller.setEmail(email!);
      print('📧 otpVerificationScreen: Email set in controller: $email');
    }
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
                  height: 50.h,
                  child: PinInputTextField(
                    pinLength: 6,
                    controller: controller.otpController,
                    decoration: BoxLooseDecoration(
                      strokeColorBuilder: PinListenColorBuilder(
                        Colors.grey,
                        secondaryColor,
                      ),
                      radius: Radius.circular(3.r),
                      strokeWidth: 2.w,
                      gapSpace: 10.w,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {},
                    onSubmit: (pin) {
                      controller.otpController.text = pin;
                      controller.verifyOtp(context);
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                Obx(
                  () => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Custombutton(
                          text: 'Verify',
                          onPressed: () => controller.verifyOtp(context),
                        ),
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Implement resend logic if needed
                              Get.snackbar(
                                'Info',
                                'Resend code feature coming soon.',
                              );
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
