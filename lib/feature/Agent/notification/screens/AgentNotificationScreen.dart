import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const/app_colors.dart';
import '../../SellingAgreement/screens/AgentSellingAgreementScreen.dart';
import '../../CMA/screens/AgentCMAScreen.dart';

class AgentNotificationScreen extends StatelessWidget {
  const AgentNotificationScreen({super.key});

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '4 unread message',
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0),
        //     child: Center(
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 12,
        //           vertical: 6,
        //         ),
        //         decoration: BoxDecoration(
        //           color: const Color(0xFFE0F2F1), // Light teal bg
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: Text(
        //           'Mark all read',
        //           style: TextStyle(
        //             fontSize: 12,
        //             fontWeight: FontWeight.w500,
        //             color: _textDark,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),

      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1), // Light teal bg
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildNotificationCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  Icons.description_outlined,
                  'Cody request for CMA',
                  'Seller is requesting you for CMA of of their property',
                  '5 hours ago',
                  isUnread: true,
                ),
                SizedBox(height: 16.h),
                _buildFullWidthButton(
                  'Give CMA',
                  primaryColor,
                  onPressed: () {
                    Get.to(() => const AgentCMAScreen());
                  },
                ),
              ],
            ),
          ),

          // 2. Showing Schedule
          _buildNotificationCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  Icons.calendar_today_outlined,
                  'Showing Schedule',
                  'Your property showing schedule has been set by the buyer',
                  '2 hours ago',
                  isUnread: true,
                ),
                SizedBox(height: 16.h),
                _buildPropertyCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?fit=crop&w=800&q=80',
                  title: 'Modern Family Home',
                  address: '123 Maple Street, Springfield',
                  dateTime: 'Nov 12, 2024 • 10:00 AM',
                  userName: 'Darly 12',
                  userTime: '4hours',
                ),
                SizedBox(height: 16.h),
                _buildDualActionButtons(onAccept: () {}, onDecline: () {}),
              ],
            ),
          ),

          // 3. Showing Scheduled
          _buildNotificationCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  Icons.calendar_today_outlined,
                  'Showing Scheduled',
                  'your property showing has scheduled successfully',
                  '1 day ago',
                ),
                SizedBox(height: 16.h),
                _buildPropertyCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?fit=crop&w=800&q=80',
                  title: 'Luxury Downtown Condo',
                  address: '321 Main Avenue, Downtown',
                  dateTime: 'Nov 13, 2024 • 10:00 AM',
                  userName: 'Cody Luber',
                  userTime: '4hours',
                ),
              ],
            ),
          ),

          // 4. Property Selling Request
          _buildNotificationCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  Icons.home_outlined,
                  'Property Selling Request',
                  '',
                  '',
                  isUnread: true,
                ),
                SizedBox(height: 12.h),
                _buildTextDetail('Esther Howard'),
                SizedBox(height: 4.h),
                _buildTextDetail('Modern Family Home', isBold: true),
                SizedBox(height: 12.h),
                Text(
                  'I am relocating to another city for work and want to sell the property soon.',
                  style: GoogleFonts.lora(
                    fontSize: 12.sp,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildTextDetail('Time: 11 Nov, 2025 - 15 Dec, 2025'),
                _buildTextDetail('Location: 123 Main Street, Springfield'),
                SizedBox(height: 12.h),
                _buildTextDetail('Asking Price: \$450,000', isBold: true),
                _buildTextDetail('Seller: Cody'),
                SizedBox(height: 16.h),
                _buildDualActionButtons(
                  onAccept: () {},
                  onDecline: () {},
                  acceptLabel: 'Approve',
                ),
              ],
            ),
          ),

          // 5. Cody accept the CMA
          _buildNotificationCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  Icons.description_outlined,
                  'Cody accept the CMA',
                  'Cody accept the CMA. Go for the next step',
                  '5 hours ago',
                ),
                SizedBox(height: 16.h),
                _buildFullWidthButton(
                  'Send Agreement',
                  primaryColor,
                  onPressed: () {
                    Get.to(() => const AgentSellingAgreementScreen());
                  },
                ),
              ],
            ),
          ),

          // 6. Cody accepted the selling agreement
          _buildNotificationCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(
                  Icons.description_outlined,
                  'Cody accepted the selling agreement',
                  'Cody accept the selling agreement. Go for the next step',
                  '5 hours ago',
                ),
                SizedBox(height: 16.h),
                _buildFullWidthButton(
                  'Chat with Seller',
                  primaryColor,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5), // Light beige/cream background
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE4B894), // Beige/tan border
          width: 1.5,
        ),
      ),
      child: child,
    );
  }

  Widget _buildHeader(
    IconData icon,
    String title,
    String description,
    String time, {
    bool isUnread = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.lora(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.lora(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
              if (time.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: GoogleFonts.lora(
                    fontSize: 11.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyCard({
    required String imageUrl,
    required String title,
    required String address,
    required String dateTime,
    required String userName,
    required String userTime,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  address,
                  style: GoogleFonts.lora(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 14.sp, color: Colors.grey[600]),
              SizedBox(width: 4.w),
              Text(
                dateTime,
                style: GoogleFonts.lora(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(width: 8.w),
              Text(
                userName,
                style: GoogleFonts.lora(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: primaryText,
                ),
              ),
              Text(
                ' • $userTime',
                style: GoogleFonts.lora(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextDetail(String text, {bool isBold = false}) {
    return Text(
      text,
      style: GoogleFonts.lora(
        fontSize: 12.sp,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        color: primaryText,
      ),
    );
  }

  Widget _buildFullWidthButton(
    String label,
    Color color, {
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.lora(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildDualActionButtons({
    required VoidCallback onAccept,
    required VoidCallback onDecline,
    String acceptLabel = 'Accept',
    String declineLabel = 'Decline',
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  acceptLabel,
                  style: GoogleFonts.lora(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: OutlinedButton(
            onPressed: onDecline,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.withOpacity(0.3)),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  declineLabel,
                  style: GoogleFonts.lora(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
