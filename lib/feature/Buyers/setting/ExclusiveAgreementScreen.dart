import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';

class ExclusiveAgreementScreen extends StatelessWidget {
  const ExclusiveAgreementScreen({super.key});

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
          'Buyer Agreement',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Agreement',
                    style: GoogleFonts.lora(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'You have not uploaded an exclusive agreement yet. Please upload a signed copy of your agreement to proceed.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Upload Section
            Text(
              'Upload Agreement',
              style: GoogleFonts.lora(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            SizedBox(height: 16.h),

            // Upload Button Container
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: InkWell(
                onTap: () {
                  // TODO: Implement file picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File picker not implemented yet'),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48.sp,
                      color: primaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Tap to upload PDF',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Max file size: 5MB',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
