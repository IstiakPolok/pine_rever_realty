import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/const/app_colors.dart';

import '../../Notification/screen/NotificationScreen.dart';
import 'PropertiesRequestFormScreen.dart';

class SallerHomeScreen extends StatefulWidget {
  const SallerHomeScreen({super.key});

  @override
  State<SallerHomeScreen> createState() => _SallerHomeScreenState();
}

class _SallerHomeScreenState extends State<SallerHomeScreen> {
  // Mock Data for Selling Requests
  final List<Map<String, dynamic>> _sellingRequests = [
    {
      "name": "Esther Howard",
      "propertyTitle": "Modern Family Home",
      "description":
          "I am relocating to another city for work and want to sell the property quickly",
      "timeRange": "11 Nov, 2025 - 12 Dec, 2025",
      "email": "johndoe@example.com",
      "phone": "+1 (555) 234-7890",
      "askingPrice": "\$450,000",
      "agent": "Emily Rodriguez",
      "status": "Pending",
    },
    {
      "name": "Wade Warren",
      "propertyTitle": "Downtown Luxury Apartment",
      "description":
          "Looking to upgrade to a larger home and need to sell current property",
      "timeRange": "15 Nov, 2025 - 20 Dec, 2025",
      "email": "wade.warren@example.com",
      "phone": "+1 (555) 987-6543",
      "askingPrice": "\$625,000",
      "agent": "Michael Chen",
      "status": "Pending",
    },
  ];
  static const Color _cardBg = Color(0xFFEEF6F4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Initialize ScreenUtil
          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Top Bar
                    _buildTopBar(),
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Request list',
                          style: GoogleFonts.lora(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Request Cards List ---
                        ..._sellingRequests.map(
                          (request) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildRequestCard(request),
                          ),
                        ),

                        // --- Bottom Action Button ---
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(() => PropertiesRequestFormScreen());
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: Text(
                              'Add New Selling Request',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request['name'],
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            request['propertyTitle'],
            style: GoogleFonts.lora(fontSize: 16, color: primaryText),
          ),
          const SizedBox(height: 12),
          Text(
            request['description'],
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: primaryText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Details Block
          _buildDetailLine('Time: ', request['timeRange']),
          const SizedBox(height: 4),
          _buildDetailLine('Email: ', request['email']),
          const SizedBox(height: 4),
          _buildDetailLine('Phone Number: ', request['phone']),

          const SizedBox(height: 20),

          Text(
            'Asking Price: ${request['askingPrice']}',
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 13, color: greyText),
              children: [
                const TextSpan(text: 'Agent: '),
                TextSpan(
                  text: request['agent'],
                  style: GoogleFonts.poppins(color: primaryText),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Status Button
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: Text(
                request['status'],
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailLine(String label, String value) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(fontSize: 13, color: greyText),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(color: primaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fit=crop&w=100&q=80',
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: GoogleFonts.lora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'Find your dream home',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, size: 28.sp),
              onPressed: () {
                Get.to(sallerNotificationScreen());
              },
              color: primaryColor,
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
