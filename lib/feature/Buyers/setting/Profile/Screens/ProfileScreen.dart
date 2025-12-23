import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/feature/Buyers/setting/buyerAgreementScreen.dart';
import 'package:pine_rever_realty/feature/auth/roleSelect/screens/roleSelectScreen.dart';

import '../../ mortgage_Pre-approval_letter/screen/ Mortgage_pre-approval_letter.dart';
import '../../../../../core/const/app_colors.dart';
import '../../../../../core/services_class/auth_service.dart';
import '../../AgreementList/Screen/AgreementListScreen.dart';
import '../../ChangePasswordScreen/screen/ChangePasswordScreen.dart';
import '../../DeleteAccount/screens/DeleteAccountScreen.dart';
import '../../EditProfile/Screen/editProfileScreen.dart';
import '../../PrivacySecurity/screen/PrivacySecurityScreen.dart';
import '../../TermsConditions/Screen/TermsConditionsScreen.dart';
import '../../screens/ScheduleListScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _redColor = Color(0xFFE53935);
  static const Color _bgGrey = Color(0xFFF9F9F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -100.h,
                  right: -50.w,
                  child: Container(
                    width: 350.w,
                    height: 350.h,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // 1. Background Curve
                ClipPath(
                  clipper: HeaderCurveClipper(),
                  child: Container(
                    height: 240.h,
                    width: 1.sw,
                    color: primaryColor,
                  ),
                ),

                // 2. Orange Accent Circle (Top Right)

                // 3. AppBar Content (Back Arrow & Title)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Profile',
                            style: GoogleFonts.lora(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 4. Profile Image
                Positioned(
                  bottom:
                      -60.h, // Half the height of the image roughly to overlap
                  child: Container(
                    padding: EdgeInsets.all(4.r), // White border thickness
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1566492031773-4f4e44671857?fit=crop&w=400&q=80',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 70.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cody Fisher',
                          style: GoogleFonts.lora(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Member since Oct 2025',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.to(EditProfileScreen());
                      },
                      icon: Icon(Icons.edit, size: 14.sp, color: Colors.white),
                      label: Text(
                        'Edit',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        minimumSize: Size.zero, // Shrink wrap
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // --- Contact Information ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: _bgGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildContactRow(
                      Icons.email_outlined,
                      'john.doe@example.com',
                    ),
                    SizedBox(height: 12.h),
                    _buildContactRow(Icons.phone_outlined, '(555) 123-4567'),
                    SizedBox(height: 12.h),
                    _buildContactRow(
                      Icons.location_on_outlined,
                      'Springfield, IL',
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // --- Settings Section ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: GoogleFonts.lora(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: _bgGrey,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.calendar_today_outlined,
                          title: 'Schedule List',
                          onTap: () {
                            Get.to(ScheduleListScreen());
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.handshake_outlined,
                          title: 'Agreement List',
                          onTap: () {
                            Get.to(AgreementListScreen());
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.verified_user_outlined,
                          title: 'mortgage pre-approval letter',
                          onTap: () {
                            Get.to(EditMortgageLetterScreen());
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.assignment_outlined,
                          title: 'Buyer Agreement',
                          onTap: () {
                            Get.to(buyerAgreementScreen());
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.password,
                          title: 'Change Password',
                          onTap: () {
                            Get.to(ChangePasswordScreen());
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.lock_outline,
                          title: 'Privacy & Security',
                          onTap: () {
                            Get.to(PrivacySecurityScreen());
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () {
                            Get.to(TermsConditionsScreen());
                          },
                        ),
                        _buildSettingItem(
                          icon: Icons.delete_outline,
                          title: 'Delete Profile',
                          textColor: _redColor,
                          iconColor: _redColor,
                          onTap: () {
                            Get.to(DeleteAccountScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // --- Logout Button ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: OutlinedButton.icon(
                onPressed: () {
                  // Handle Logout
                  _showLogoutDialog(context);
                },
                icon: Icon(Icons.logout, size: 20.sp),
                label: Text(
                  'Logout',
                  style: GoogleFonts.lora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _redColor,
                  side: const BorderSide(color: _redColor),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  minimumSize: Size(1.sw, 50.h),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: secondaryText),
        SizedBox(width: 12.w),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 14.sp, color: primaryText),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // The title matches the serif style
          title: Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          // The content matches the lighter sans-serif text
          content: Text(
            'You can log back in anytime',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          actions: [
            Row(
              children: [
                // Cancel Button (Outlined with dark/grey text)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                        color: Color(0xFF4A5568),
                      ), // Dark grey/blueish border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.lora(
                        color: const Color(0xFF4A5568), // Matching text color
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Logout Button (Solid Red)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(roleSelect());
                      AuthService.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000), // Bright Red
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Logout',
                      style: GoogleFonts.lora(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color:
            iconColor ??
            const Color(0xFF2D6A5F), // Using a teal-ish green for icons
        size: 22.sp,
      ),
      title: Text(
        title,
        style: GoogleFonts.lora(
          fontSize: 15.sp,
          color: textColor ?? primaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      dense: true,
    );
  }
}

// --- Custom Clipper for Header ---
class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
      0,
      size.height - 50,
    ); // Start at bottom-left (minus curve height)

    // Create a quadratic bezier curve
    var firstControlPoint = Offset(
      size.width / 2,
      size.height + 30,
    ); // Pull down in the middle
    var firstEndPoint = Offset(
      size.width,
      size.height - 80,
    ); // End at bottom-right (higher than left)

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.lineTo(size.width, 0); // Go to top-right
    path.lineTo(0, 0); // Go to top-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
