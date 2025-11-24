import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/const/app_colors.dart';

class SellingRequestListScreen extends StatelessWidget {
  const SellingRequestListScreen({super.key});

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
          'Selling Request List',
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
          return _buildRequestCard();
        },
      ),
    );
  }

  Widget _buildRequestCard() {
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
            'Esther Howard',
            style: GoogleFonts.lora(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D6A5F), // Dark teal text
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Modern Family Home',
            style: GoogleFonts.poppins(fontSize: 14.sp, color: primaryText),
          ),
          SizedBox(height: 8.h),
          Text(
            'I am relocating to another city for work and want to sell the property quickly',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: secondaryText,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('Time:', '11 Nov, 2025 - 12 Dec, 2025'),
          _buildInfoRow('Email:', 'johndoe@example.com'),
          _buildInfoRow('Phone Number:', '+1 (555) 234-7890'),
          SizedBox(height: 12.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Asking Price: ',
                  style: GoogleFonts.lora(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D6A5F),
                  ),
                ),
                TextSpan(
                  text: '\$450,000',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Agent: ',
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Pending',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: GoogleFonts.poppins(fontSize: 12.sp, color: secondaryText),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 12.sp, color: secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
