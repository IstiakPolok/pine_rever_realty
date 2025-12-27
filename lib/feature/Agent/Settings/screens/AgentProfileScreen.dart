import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'EditProfileScreen.dart';
import 'dart:convert';

import 'package:pine_rever_realty/feature/auth/login/model/login_response_model.dart';

class AgentProfileScreen extends StatelessWidget {
  final UserModel? user;

  const AgentProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    backgroundImage: user?.profilePicture != null
                        ? NetworkImage(user!.profilePicture!) as ImageProvider
                        : null,
                    child: user?.profilePicture == null
                        ? Icon(Icons.person, size: 60.sp, color: primaryColor)
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    user?.fullName.isNotEmpty == true
                        ? user!.fullName
                        : (user?.username ?? 'Agent'),
                    style: GoogleFonts.lora(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user?.username ?? 'Residential Properties',
                    style: GoogleFonts.lora(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if ((user?.phoneNumber ?? '').isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, size: 16.sp, color: Colors.grey[600]),
                        SizedBox(width: 4.w),
                        Text(
                          user!.phoneNumber,
                          style: GoogleFonts.lora(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge(
                        user?.licenseNumber != null
                            ? 'License: ${user!.licenseNumber}'
                            : 'License: N/A',
                        const Color(0xFFE0F2F1),
                      ),
                      SizedBox(width: 8.w),
                      _buildBadge(
                        // Map API enum to user-friendly label
                        (() {
                          const availabilityLabels = {
                            'full-time': 'Full-time',
                            'part-time': 'Part-time',
                            'project-based': 'Project-based',
                          };
                          final av = user?.availability;
                          if (av != null &&
                              availabilityLabels.containsKey(av)) {
                            return availabilityLabels[av]!;
                          }
                          return 'Member';
                        })(),
                        const Color(0xFFFFF3E0),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: primaryColor, size: 20.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'Verified Pro',
                        style: GoogleFonts.lora(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(user: user),
                              ),
                            )
                            .then((v) {
                              if (v == true) Navigator.of(context).pop(true);
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.lora(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Overview Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Overview',
                    style: GoogleFonts.lora(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Contact Information
            _buildSection(
              'Contact Information',
              Column(
                children: [
                  _buildContactItem(
                    Icons.phone,
                    user?.phoneNumber ?? '(555) 123-4567',
                  ),
                  SizedBox(height: 12.h),
                  _buildContactItem(
                    Icons.email,
                    user?.email ?? 'not-provided@example.com',
                  ),
                ],
              ),
            ),

            // About
            _buildSection(
              'About',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experienced real estate agent specializing in residential properties with over 10 years in the Springfield market. Dedicated to helping families find their perfect home.',
                    style: GoogleFonts.lora(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildInfoChip('English', const Color(0xFFE0F2F1)),
                      _buildInfoChip(
                        'License: ${user?.licenseNumber ?? 'N/A'}',
                        Colors.grey[200]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Service Areas
            _buildSection(
              'Service Areas',
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildAreaChip('Springfield'),
                  _buildAreaChip('Downtown'),
                  _buildAreaChip('Suburban Areas'),
                ],
              ),
            ),

            // Property Types
            _buildSection(
              'Property Types',
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildTypeChip('Single Family'),
                  _buildTypeChip('Condos'),
                  _buildTypeChip('Townhouses'),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Raw profile JSON (for debugging / display)
            // if (user != null)
            //   _buildSection(
            //     'Raw profile data',
            //     SelectableText(
            //       const JsonEncoder.withIndent('  ').convert(user!.toJson()),
            //       style: GoogleFonts.lora(
            //         fontSize: 12.sp,
            //         color: Colors.grey[800],
            //       ),
            //     ),
            //   ),
            // SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.lora(fontSize: 12.sp, color: primaryText),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: primaryColor),
        SizedBox(width: 12.w),
        Text(
          text,
          style: GoogleFonts.lora(fontSize: 14.sp, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String text, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.lora(fontSize: 12.sp, color: primaryText),
      ),
    );
  }

  Widget _buildAreaChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.lora(fontSize: 13.sp, color: primaryText),
      ),
    );
  }

  Widget _buildTypeChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.lora(fontSize: 13.sp, color: primaryText),
      ),
    );
  }
}
