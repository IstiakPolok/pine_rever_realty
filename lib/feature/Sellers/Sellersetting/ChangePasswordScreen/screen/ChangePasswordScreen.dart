import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                'Enter your current password and\ncreate a new on',
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
                onPressed: () {
                  // Handle Update Logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password Updated Successfully!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
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
