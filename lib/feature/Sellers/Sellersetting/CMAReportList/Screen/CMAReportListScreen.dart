import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/const/app_colors.dart';

class CMAReportListScreen extends StatelessWidget {
  const CMAReportListScreen({super.key});

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
          'CMA Report List',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 1, // Example item
        itemBuilder: (context, index) {
          return _buildReportCard();
        },
      ),
    );
  }

  Widget _buildReportCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F5), // Light greenish background
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modern Family Home',
            style: GoogleFonts.lora(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check your properties CMA report & Agreement',
            style: GoogleFonts.lora(
              fontSize: 14.sp,
              color: const Color(0xFF2D6A5F), // Dark teal text
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Sent by Agent: ',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: secondaryText,
                  ),
                ),
                TextSpan(
                  text: 'Emily Rodriguez',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Handle View Report
            },
            icon: Icon(
              Icons.remove_red_eye_outlined,
              size: 18.sp,
              color: Colors.white,
            ),
            label: Text(
              'View',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
