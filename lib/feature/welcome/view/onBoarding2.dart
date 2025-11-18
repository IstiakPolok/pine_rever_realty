import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/app_colors.dart';
import '../../auth/login/screens/loginScreen.dart';

class OnBoarding2 extends StatefulWidget {
  const OnBoarding2({super.key});

  @override
  State<OnBoarding2> createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  // Constants for styling

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback background color
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/onboardBG.jpg', fit: BoxFit.fill),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 50),
              _buildAuthButton(
                text: 'Sign in',
                backgroundColor: secondaryColor,
                textColor: Colors.white,
                onPressed: () {
                  Get.to(() => const LoginScreen());
                },
              ),
              const SizedBox(height: 16),

              // NEW: "Or" Text
              Text(
                'Or',
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // NEW: "Sign up" Button
              _buildAuthButton(
                text: 'Sign up',
                backgroundColor: Colors.white,
                textColor: primaryText, // Dark text on white bg
                borderColor:
                    Colors.grey[400], // Light border to make it visible
                onPressed: () {
                  // Handle sign up press
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Very rounded corners
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1.0)
                : BorderSide.none,
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Builds the top "Welcome" text section
  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Log in to connect with sellers and agents',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
