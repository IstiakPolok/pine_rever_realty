import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/feature/auth/roleSelect/screens/roleSelectScreen.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/const/authTextfield.dart';
import '../../../../core/const/customButton.dart';
import '../../../../core/const/custombackbutton.dart';
import '../../../Buyers/bottom_nav_bar/screen/bottom_nav_bar.dart';
import '../../forgetPass/screens/forgetpassScreen.dart';
import '../../signUp/screens/signScreen.dart';
import '../../signUp/screens/AgentSignUpScreen.dart';
import '../../../Agent/bottom_nav_bar/screen/Agent_bottom_nav_bar.dart';
import '../../../Sellers/bottom_nav_bar/screen/Seller_bottom_nav_bar.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  final String userRole;
  const LoginScreen({super.key, this.userRole = 'Buyer'});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                    AuthTextField(
                      hint: 'Email',
                      obscureText: false,
                      controller: _emailController,
                    ),
                    SizedBox(height: 24.h),

                    // Password Field
                    _buildLabel('Password'),
                    AuthTextField(
                      hint: '**************',
                      obscureText: true,
                      enableVisibilityToggle: true,
                      controller: _passwordController,
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
                    Obx(
                      () => Custombutton(
                        text: _loginController.isLoading.value
                            ? 'Signing In...'
                            : 'Sign In',
                        onPressed: _loginController.isLoading.value
                            ? () {}
                            : () async {
                                // Validate inputs
                                if (_emailController.text.trim().isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter your email',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }
                                if (_passwordController.text.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter your password',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                // Call login API
                                final success = await _loginController.login(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  role: widget.userRole,
                                );

                                if (success) {
                                  // Navigate based on role
                                  if (widget.userRole == 'Agent') {
                                    Get.offAll(() => const AgentBottomNavbar());
                                  } else if (widget.userRole == 'Seller') {
                                    Get.offAll(() => SellerBottomNavbar());
                                  } else if (widget.userRole == 'Buyer') {
                                    Get.offAll(() => BottomNavbar());
                                  } else {
                                    Get.offAll(() => const roleSelect());
                                    Get.snackbar(
                                      'Error',
                                      'LogIn again',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                }
                              },
                        color: secondaryColor,
                      ),
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
                                  if (widget.userRole == 'Agent') {
                                    Get.to(() => const AgentSignUpScreen());
                                  } else {
                                    Get.to(() => const SignUpScreen());
                                  }
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
