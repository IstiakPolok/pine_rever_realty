import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/const/authTextfield.dart';
import '../../../../core/const/customButton.dart';
import '../../../../core/const/custombackbutton.dart';
import 'otpVerificationScreen.dart';

class forgetpassScreen extends StatelessWidget {
  const forgetpassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/signInbg.png', fit: BoxFit.fill),
          ),
          Positioned(top: 30.h, left: 8.w, child: custombackbuttom()),

          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                // "Welcome Back" Title
                Center(
                  child: Text(
                    'Forgot Password',
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
                    'Enter your email to reset password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      height: 0.8,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // Email Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildLabel('Email'),
                ),
                AuthTextField(hint: 'Enter your email', obscureText: false),
                SizedBox(height: 16.h),

                // Forgot Password
                SizedBox(height: 24.h),

                // Sign In Button
                // _buildAuthButton(
                //   text: 'Sign in',
                //   backgroundColor: secondaryColor,
                //   textColor: Colors.white,
                //   onPressed: () {
                //     // Handle sign in logic
                //   },
                // ),
                Custombutton(
                  text: 'Send Code',
                  onPressed: () {
                    Get.to(const otpVerificationScreen());
                  },
                  color: secondaryColor,
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper for text field labels
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: primaryText,
      ),
    );
  }
}
