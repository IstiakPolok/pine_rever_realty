import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  // Colors
  static const Color _redColor = Color(0xFFFF0000); // Bright red as per image
  static const Color _textDark = Color(0xFF212121);

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
          'Delete Account',
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

            // Warning Text
            Center(
              child: Text(
                'Deleting your account will permanently\nremove all your data and saved information.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  fontSize: 16,
                  color: _textDark,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 60),

            // Password Confirmation
            Text(
              'Please Enter Your Confirmation Password',
              style: GoogleFonts.lora(fontSize: 16, color: _textDark),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              style: GoogleFonts.poppins(fontSize: 14, color: _textDark),
              decoration: InputDecoration(
                hintText: '*************',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[500],
                  fontSize: 14,
                  letterSpacing: 2.0,
                ),
                prefixIcon: const Icon(
                  Icons.password,
                  size: 20,
                  color: Colors.grey,
                ), // Using password icon as generic placeholder
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                filled: false,
              ),
            ),

            const SizedBox(height: 40),

            // Delete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Show confirmation dialog or perform delete
                  _showFinalConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _redColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Delete',
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

  void _showFinalConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Final Confirmation',
          style: GoogleFonts.lora(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you absolutely sure? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              // Perform actual delete logic here
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signin',
                (route) => false,
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
