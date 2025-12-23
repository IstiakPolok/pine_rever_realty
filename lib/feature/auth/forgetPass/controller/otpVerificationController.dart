import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network_caller/endpoints.dart';
import '../screens/resetPassScreen.dart';

class OtpVerificationController extends GetxController {
  final otpController = TextEditingController();
  String? email;
  var isLoading = false.obs;

  void setEmail(String value) {
    email = value;
    print('📧 OtpVerificationController: Email set to $email');
  }

  Future<void> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();
    print('🔢 OtpVerificationController: OTP entered: $otp');
    if (email == null || email!.isEmpty) {
      print('❌ OtpVerificationController: Email is missing');
      Get.snackbar('Error', 'Email is missing. Please restart the process.');
      return;
    }
    if (otp.isEmpty) {
      print('❌ OtpVerificationController: OTP is empty');
      Get.snackbar('Error', 'Please enter the OTP code.');
      return;
    }
    try {
      isLoading.value = true;
      print(
        '🌐 OtpVerificationController: Sending POST to: ' +
            Urls.baseUrl +
            '/common/verify-otp/',
      );
      final response = await http.post(
        Uri.parse(Urls.baseUrl + '/common/verify-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      print(
        '📊 OtpVerificationController: Response status: ${response.statusCode}',
      );
      print('📄 OtpVerificationController: Response body: ${response.body}');
      if (response.statusCode == 200) {
        print('✅ OtpVerificationController: OTP verified successfully');
        Get.snackbar(
          'Success',
          'OTP verified. You can now reset your password.',
        );
        Get.to(() => resetPassScreen(email: email!, otp: otp));
      } else {
        String errorMsg = 'Failed to verify OTP. Please try again.';
        try {
          final Map<String, dynamic> data = response.body.isNotEmpty
              ? jsonDecode(response.body)
              : {};
          if (data.containsKey('message')) {
            errorMsg = data['message'].toString();
          }
        } catch (e) {
          print(
            '❌ OtpVerificationController: Error parsing error response: $e',
          );
        }
        print('❌ OtpVerificationController: $errorMsg');
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      print('❌ OtpVerificationController: Exception: $e');
      Get.snackbar('Error', 'An error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
