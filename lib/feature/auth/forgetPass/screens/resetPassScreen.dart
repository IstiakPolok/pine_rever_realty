import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/feature/auth/login/screens/loginScreen.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/const/authTextfield.dart';
import '../../../../core/const/customButton.dart';
import '../../../../core/const/custombackbutton.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../controller/resetPassController.dart';

class resetPassScreen extends StatefulWidget {
  final String email;
  final String otp;
  const resetPassScreen({super.key, required this.email, required this.otp});

  @override
  State<resetPassScreen> createState() => _resetPassScreenState();
}

class _resetPassScreenState extends State<resetPassScreen> {
  final ResetPassController _controller = ResetPassController();

  @override
  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _controller.passwordController.addListener(() {
      _controller.validatePassword();
    });
    _controller.confirmPasswordController.addListener(() {
      _controller.validateConfirmPassword();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/signInbg.png', fit: BoxFit.fill),
          ),
          // Top left back button
          Positioned(top: 30.h, left: 8.w, child: custombackbuttom()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Reset Password',
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
                        "Create a new one",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lora(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          height: 0.8,
                        ),
                      ),
                    ),
                    SizedBox(height: 70.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildLabel('Password'),
                    ),
                    AuthTextField(
                      controller: _controller.passwordController,
                      hint: '**************',
                      obscureText: true,
                      enableVisibilityToggle: true,
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(height: 12.h),
                    _buildPasswordCondition(
                      'At least 8 characters',
                      _controller.hasMinLength,
                    ),
                    _buildPasswordCondition(
                      'Contains uppercase letter',
                      _controller.hasUpperCase,
                    ),
                    _buildPasswordCondition(
                      'Contains lowercase letter',
                      _controller.hasLowerCase,
                    ),
                    _buildPasswordCondition(
                      'Contains number',
                      _controller.hasNumber,
                    ),
                    _buildPasswordCondition(
                      'Contains special character',
                      _controller.hasSpecialChar,
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildLabel('Confirm Password'),
                    ),
                    AuthTextField(
                      controller: _controller.confirmPasswordController,
                      hint: '**************',
                      obscureText: true,
                      enableVisibilityToggle: true,
                    ),
                    if (_controller.confirmPasswordError != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        _controller.confirmPasswordError!,
                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                      ),
                    ],
                    SizedBox(height: 30.h),
                    IgnorePointer(
                      ignoring: !_controller.isValid,
                      child: Opacity(
                        opacity: _controller.isValid ? 1.0 : 0.5,
                        child: Custombutton(
                          text: 'Save Password',
                          onPressed: () async {
                            _controller.validatePassword();
                            _controller.validateConfirmPassword();
                            if (_controller.isValid) {
                              // Integrate reset password API
                              final newPassword =
                                  _controller.passwordController.text;
                              final newPassword2 =
                                  _controller.confirmPasswordController.text;
                              print(
                                '🔑 ResetPassScreen: Email: ${widget.email}, OTP: ${widget.otp}, New Password: $newPassword',
                              );
                              try {
                                final response = await http.post(
                                  Uri.parse(
                                    '${Urls.baseUrl}/common/reset-password/',
                                  ),
                                  headers: {'Content-Type': 'application/json'},
                                  body: jsonEncode({
                                    "email": widget.email,
                                    "otp": widget.otp,
                                    "new_password": newPassword,
                                    "new_password2": newPassword2,
                                  }),
                                );
                                print(
                                  '📊 ResetPassScreen: Response status: \\${response.statusCode}',
                                );
                                print(
                                  '📄 ResetPassScreen: Response body: \\${response.body}',
                                );
                                if (response.statusCode == 200) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'assets/image/passchange.jpg',
                                              width: 200.w,
                                              height: 200.w,
                                            ),
                                            Text(
                                              'Updated Successfully',
                                              style: GoogleFonts.lora(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: primaryText,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 12.h),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Custombutton(
                                                text: 'Go to Login',
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Get.offAll(LoginScreen());
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  String errorMsg =
                                      'Failed to reset password. Please try again.';
                                  try {
                                    final Map<String, dynamic> data =
                                        response.body.isNotEmpty
                                        ? jsonDecode(response.body)
                                        : {};
                                    if (data.containsKey('message')) {
                                      errorMsg = data['message'].toString();
                                    }
                                  } catch (e) {
                                    print(
                                      '❌ ResetPassScreen: Error parsing error response: $e',
                                    );
                                  }
                                  Get.snackbar('Error', errorMsg);
                                }
                              } catch (e) {
                                print('❌ ResetPassScreen: Exception: $e');
                                Get.snackbar(
                                  'Error',
                                  'An error occurred. Please try again.',
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildPasswordCondition(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            color: isMet ? Colors.green : Colors.red,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: isMet ? Colors.green : Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
