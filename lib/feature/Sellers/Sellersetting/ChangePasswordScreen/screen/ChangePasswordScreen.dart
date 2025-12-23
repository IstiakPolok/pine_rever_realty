import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/network_caller/endpoints.dart';
import '../../../../../core/services_class/local_service/shared_preferences_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Colors
  static const Color _primaryGreen = Color(0xFF0E4A3B);
  static const Color _textDark = Color(0xFF212121);

  // Controllers
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    final oldPass = _oldPassController.text.trim();
    final newPass = _newPassController.text.trim();
    final confirmPass = _confirmPassController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar('Error', 'New password and confirmation do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await http.post(
        Uri.parse(Urls.sellerChangePassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'old_password': oldPass,
          'new_password': newPass,
          'new_password2': confirmPass,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = jsonDecode(response.body);
        final message = body['message'] ?? 'Password changed successfully.';
        Get.snackbar('Success', message);
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        String errorMsg = 'Failed to change password: ${response.statusCode}';
        try {
          final body = jsonDecode(response.body);
          if (body is Map && body['message'] != null) {
            errorMsg = body['message'];
          } else if (body is Map && body['detail'] != null) {
            errorMsg = body['detail'];
          } else {
            errorMsg = response.body;
          }
        } catch (_) {
          errorMsg = response.body;
        }
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Change Password',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Instructional Text
            Center(
              child: Text(
                'Enter your current password and\ncreate a new one',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 16,
                  color: _textDark,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Old Password
            _buildPasswordField(
              label: 'Old password',
              controller: _oldPassController,
              hint: '*************',
            ),
            const SizedBox(height: 24),

            // New Password
            _buildPasswordField(
              label: 'New Password',
              controller: _newPassController,
              hint: '*************',
            ),
            const SizedBox(height: 24),

            // Confirm Password
            _buildPasswordField(
              label: 'Confirm Password',
              controller: _confirmPassController,
              hint: '*************',
            ),

            const SizedBox(height: 60),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Update Password',
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.lora(fontSize: 16, color: _textDark)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          style: GoogleFonts.poppins(fontSize: 14, color: _textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 14,
              letterSpacing: 2.0, // To make stars look spread out
            ),
            // Using a lock icon as a standard replacement for the password dots icon in the image
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 20,
              color: Colors.black54,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.black54,
              ), // Darker border as per image
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
            ),
            filled: false,
          ),
        ),
      ],
    );
  }
}
