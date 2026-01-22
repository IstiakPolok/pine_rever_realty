import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';

import '../../../welcome/view/onBoarding2.dart';

class roleSelect extends StatefulWidget {
  const roleSelect({super.key});

  @override
  State<roleSelect> createState() => _roleSelectState();
}

class _roleSelectState extends State<roleSelect> {
  // State to keep track of the selected user type
  String _selectedUserType = 'Buyer';

  // Constants for styling

  static const Color _lightGrey = Color(0xFFBDBDBD);
  static const Color _darkText = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black, // Fallback background color
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset('assets/image/onboardBG.jpg', fit: BoxFit.fill),

          // 2. Content Column
          Column(
            children: [
              // Top "Welcome" Section
              SizedBox(height: screenSize.height * 0.1), // Top padding
              _buildWelcomeSection(),

              // Spacer to push the bottom sheet down
              const Spacer(),

              // Bottom "How will you use?" Section
              _buildBottomSheet(screenSize),
            ],
          ),
        ],
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
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore properties and manage showings effortlessly',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the white bottom sheet container
  Widget _buildBottomSheet(Size screenSize) {
    return Container(
      // Height is roughly 60% of the screen
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take only needed space
        children: [
          // "How will you use?" Title
          Text(
            'How will you use?',
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _darkText,
            ),
          ),
          const SizedBox(height: 8),

          // "Choose the option..." Subtitle
          Text(
            'Choose the option that best describes you',

            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // User Type Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildUserTypeOption(
                icon: Icons.person_outline,
                label: 'Buyer',
                isSelected: _selectedUserType == 'Buyer',
                onTap: () {
                  setState(() {
                    _selectedUserType = 'Buyer';
                  });
                },
              ),
              _buildUserTypeOption(
                icon: Icons.store, // Using a similar icon
                label: 'Seller',
                isSelected: _selectedUserType == 'Seller',
                onTap: () {
                  setState(() {
                    _selectedUserType = 'Seller';
                  });
                },
              ),
              _buildUserTypeOption(
                icon: Icons.real_estate_agent_outlined, // Using a similar icon
                label: 'Agent',
                isSelected: _selectedUserType == 'Agent',
                onTap: () {
                  setState(() {
                    _selectedUserType = 'Agent';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 32),

          // "Continue" Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedUserType == 'Buyer') {
                  Get.to(() => const OnBoarding2(userRole: 'Buyer'));
                } else if (_selectedUserType == 'Seller') {
                  Get.to(() => const OnBoarding2(userRole: 'Seller'));
                  //Get.to(() => SellerBottomNavbar());
                } else if (_selectedUserType == 'Agent') {
                  // Replace with your Agent screen
                  Get.to(() => const OnBoarding2(userRole: 'Agent'));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // "Don't worry..." Footer Text
          Text(
            "Don't worry, you can switch anytime",
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Reusable widget for the 'Buyer', 'Seller', 'Agent' options
  Widget _buildUserTypeOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Determine colors based on selection state
    final Color color = isSelected ? secondaryColor : _lightGrey;
    final double borderWidth = isSelected ? 2.0 : 1.5;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Icon Container (Circle)
          Container(
            width: 90,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: isSelected
                    ? secondaryColor.withOpacity(0.5)
                    : Colors.transparent,
                width: borderWidth,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: borderWidth),
                      color: isSelected
                          ? secondaryColor.withOpacity(0.05)
                          : Colors.transparent,
                    ),
                    child: Icon(icon, size: 40, color: color),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Label Text
        ],
      ),
    );
  }
}
