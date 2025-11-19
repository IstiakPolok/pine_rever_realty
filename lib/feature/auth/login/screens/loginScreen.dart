import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/const/authTextfield.dart';
import '../../../../core/const/customButton.dart';
import '../../../../core/const/custombackbutton.dart';
import '../../../Buyers/bottom_nav_bar/screen/bottom_nav_bar.dart';
import '../../forgetPass/screens/forgetpassScreen.dart';
import '../../signUp/screens/signScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    // "Welcome Back" Title
                    Center(
                      child: Text(
                        'Welcome Back',
                        style: GoogleFonts.lora(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Subtitle
                    Text(
                      'Sign in to manage your properties and connect with clients effortlessly',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        height: 2,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Email Field
                    _buildLabel('Email'),
                    AuthTextField(hint: 'Email', obscureText: false),
                    SizedBox(height: 24.h),

                    // Password Field
                    _buildLabel('Password'),
                    AuthTextField(
                      hint: '**************',
                      obscureText: true,
                      enableVisibilityToggle: true,
                    ),
                    SizedBox(height: 16.h),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(const forgetpassScreen());
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
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
                      text: 'Sign In',
                      onPressed: () {
                        Get.to(() => const BottomNavbar());
                      },
                      color: secondaryColor,
                    ),
                    SizedBox(height: 32.h),

                    // Don't have account?
                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have account? ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'Signup',
                              style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              // Add recognizer to make it tappable
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const SignUpScreen());
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h), // For bottom padding
                  ],
                ),
              ),
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

  // Helper for text fields
}
