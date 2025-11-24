import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/const/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  // Colors

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // ClipPath(
                //   clipper: EditProfileHeaderClipper(),
                //   child: Container(
                //     height: 350.h,
                //     width: 1.sw,
                //     color: secondaryColor,
                //   ),
                // ),
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
                ClipPath(
                  clipper: EditProfileHeaderClipper(),
                  child: Container(
                    height: 240.h,
                    width: 1.sw,
                    color: primaryColor,
                  ),
                ),

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
                            'Edit Profile',
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

                // 4. Profile Picture with Camera Icon
                Positioned(
                  bottom: -60.h,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
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
                      Positioned(
                        bottom: 0.h,
                        right: 0.w,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D6A5F),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.white, width: 2.w),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 80.h), // Space for avatar
            // --- Form Fields ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  _buildLabeledTextField(
                    label: 'Full Name',
                    initialValue: 'Cody Fisher',
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Email',
                    initialValue: 'john.doe@example.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Phone Number',
                    initialValue: '(555) 123-4567',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Location',
                    initialValue: 'Springfield, IL',
                    icon: Icons.location_on_outlined,
                  ),

                  SizedBox(height: 40.h),

                  // --- Save Button ---
                  SizedBox(
                    width: 1.sw,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Save Logic
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile Updated!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.lora(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required String initialValue,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lora(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: primaryText,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(fontSize: 14.sp, color: primaryText),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primaryText, size: 22.sp),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: primaryColor, width: 1.5.w),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA), // Very light grey fill
          ),
        ),
      ],
    );
  }
}

// Custom Clipper for the Edit Profile Header (slightly simpler curve)
class EditProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);

    var controlPoint = Offset(size.width / 2, size.height + 20);
    var endPoint = Offset(size.width, size.height - 80);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
