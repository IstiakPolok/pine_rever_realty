import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:pine_rever_realty/core/const/customButton.dart';
import 'package:pine_rever_realty/core/const/custombackbutton.dart';
import '../controller/signController.dart';
import '../../login/screens/loginScreen.dart';
import 'AgentMakeProfileScreen.dart';

class AgentSignUpScreen extends StatefulWidget {
  const AgentSignUpScreen({super.key});

  @override
  State<AgentSignUpScreen> createState() => _AgentSignUpScreenState();
}

class _AgentSignUpScreenState extends State<AgentSignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  // Text Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Controller
  final SignController _signController = Get.put(SignController());

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    // Validation
    if (_firstNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your first name');
      return;
    }

    if (_lastNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your last name');
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    if (_passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your password');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (!_agreedToTerms) {
      Get.snackbar('Error', 'Please agree to the Terms & Privacy Policy');
      return;
    }

    // Generate username from email
    final username = _emailController.text.trim().split('@').first + '_agent';

    // Call Agent registration API
    final success = await _signController.registerAgent(
      username: username,
      email: _emailController.text.trim(),
      password: _passwordController.text,
      password2: _confirmPasswordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    if (success) {
      Get.snackbar('Success', 'Registration successful!');
      Get.to(() => const AgentMakeProfileScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Decorative circles (Bottom Right)
          Positioned(
            bottom: -100.h,
            right: -50.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 50.h,
            right: -80.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF4A6F66,
                ).withOpacity(0.9), // Darker green/teal
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    custombackbuttom(),
                    SizedBox(height: 30.h),
                    Center(
                      child: Text(
                        'Create Your Account',
                        style: GoogleFonts.lora(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        'Create an account to start browsing properties and scheduling showings',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    _buildLabel('First Name'),
                    _buildTextField(
                      hint: 'Enter your first name',
                      controller: _firstNameController,
                    ),
                    SizedBox(height: 16.h),

                    _buildLabel('Last Name'),
                    _buildTextField(
                      hint: 'Enter your last name',
                      controller: _lastNameController,
                    ),
                    SizedBox(height: 16.h),

                    _buildLabel('Email'),
                    _buildTextField(
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),
                    SizedBox(height: 16.h),

                    _buildLabel('Password'),
                    _buildTextField(
                      hint: '*********',
                      obscureText: !_isPasswordVisible,
                      controller: _passwordController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildLabel('Confirm Password'),
                    _buildTextField(
                      hint: '*********',
                      obscureText: !_isConfirmPasswordVisible,
                      controller: _confirmPasswordController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      children: [
                        SizedBox(
                          height: 24.h,
                          width: 24.h,
                          child: Checkbox(
                            value: _agreedToTerms,
                            activeColor: secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _agreedToTerms = val ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: primaryText,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' & '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    Obx(
                      () => _signController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : Custombutton(
                              text: 'Sign up',
                              color: secondaryColor, // Orange color
                              onPressed: _handleSignUp,
                            ),
                    ),
                    SizedBox(height: 24.h),

                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: Colors
                                    .blue, // Or secondaryColor if preferred
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    () => const LoginScreen(userRole: 'Agent'),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: secondaryColor, width: 1.5.w),
        ),
      ),
    );
  }
}
