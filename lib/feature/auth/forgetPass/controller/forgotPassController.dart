import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network_caller/endpoints.dart';
import '../screens/otpVerificationScreen.dart';

class ForgotPassController extends GetxController {
  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> sendResetCode(BuildContext context) async {
    final email = emailController.text.trim();
    print('📧 ForgotPassController: Email entered: $email');
    if (email.isEmpty) {
      print('❌ ForgotPassController: Email is empty');
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    try {
      isLoading.value = true;
      print(
        '🌐 ForgotPassController: Sending POST to: ' +
            Urls.baseUrl +
            '/common/forgot-password/',
      );
      final response = await http.post(
        Uri.parse(Urls.baseUrl + '/common/forgot-password/'),
        headers: {'Content-Type': 'application/json'},
        body: '{"email": "$email"}',
      );
      print('📊 ForgotPassController: Response status: ${response.statusCode}');
      print('📄 ForgotPassController: Response body: ${response.body}');
      if (response.statusCode == 200) {
        print('✅ ForgotPassController: OTP sent successfully');
        Get.snackbar('Success', 'OTP sent to your email address.');
        Get.to(() => otpVerificationScreen(email: email));
      } else {
        print('❌ ForgotPassController: Failed to send OTP');
        String errorMsg = 'Failed to send OTP. Please try again.';
        try {
          Map<String, dynamic> data = {};
          if (response.body.isNotEmpty) {
            try {
              data = jsonDecode(response.body) as Map<String, dynamic>;
            } catch (_) {
              data = {};
            }
          }
          if (data.containsKey('email') &&
              data['email'] is List &&
              data['email'].isNotEmpty) {
            errorMsg = data['email'][0].toString();
          }
        } catch (e) {
          print('❌ ForgotPassController: Error parsing error response: $e');
        }
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      print('❌ ForgotPassController: Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
