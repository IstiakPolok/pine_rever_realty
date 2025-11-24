import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/const/app_colors.dart';
import '../../notification/screens/AgentNotificationScreen.dart';

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  int _selectedTab = 0; // 0: Pending, 1: Approved

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
                    SizedBox(height: 24.h),

                    // 2. Search Bar
                    _buildSearchBar(),
                    SizedBox(height: 24.h),

                    // 3. Stats Grid
                    _buildStatsGrid(),
                    SizedBox(height: 24.h),

                    // 4. Tab Switcher
                    _buildTabSwitcher(),
                    SizedBox(height: 24.h),

                    // 5. Property List
                    _buildPropertyList(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
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
                Get.to(AgentNotificationScreen());
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

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCEDE0), // Beige background
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search properties',
          hintStyle: GoogleFonts.lora(color: Colors.grey[600], fontSize: 14.sp),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.access_time,
                iconColor: secondaryColor,
                iconBgColor: const Color(0xFFFCEDE0),
                count: '12',
                label: 'Pending Review',
                countColor: secondaryColor,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildStatCard(
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF2D6A5F),
                iconBgColor: const Color(0xFFE0F2F1),
                count: '45',
                label: 'Approved',
                countColor: const Color(0xFF2D6A5F),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildStatCard(
          icon: Icons.home_outlined,
          iconColor: secondaryColor,
          iconBgColor: const Color(0xFFFCEDE0),
          count: '8',
          label: 'Sold This Month',
          countColor: secondaryColor,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String count,
    required String label,
    required Color countColor,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            count,
            style: GoogleFonts.lora(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: countColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.lora(fontSize: 14.sp, color: primaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              text: 'Pending (3)',
              isSelected: _selectedTab == 0,
              color: secondaryColor,
              icon: Icons.access_time,
              onTap: () => setState(() => _selectedTab = 0),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildTabButton(
              text: 'Approved (2)',
              isSelected: _selectedTab == 1,
              color: const Color(0xFF2D6A5F),
              icon: Icons.check_circle_outline,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String text,
    required bool isSelected,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
          border: isSelected ? null : Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: GoogleFonts.lora(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList() {
    if (_selectedTab == 0) {
      // Pending List
      return Column(
        children: [
          _buildPropertyCard(
            image:
                'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?fit=crop&w=800&q=80',
            title: 'Modern Family Home',
            address: '123 Maple Street, Springfield, IL',
            price: '\$450,000',
            details: '4 bed • 3 bath • 2500 sqft',
            agentName: 'By John Smith',
            time: '2 hours ago',
            status: 'Pending',
            statusColor: secondaryColor,
            showActions: true,
          ),
          SizedBox(height: 16.h),
          _buildPropertyCard(
            image:
                'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?fit=crop&w=800&q=80',
            title: 'Luxury Estate',
            address: '456 Oak Avenue, Springfield, IL',
            price: '\$750,000',
            details: '5 bed • 4 bath • 3800 sqft',
            agentName: 'By Sarah Johnson',
            time: '5 hours ago',
            status: 'Pending',
            statusColor: secondaryColor,
            showActions: true,
          ),
          SizedBox(height: 16.h),
          _buildPropertyCard(
            image:
                'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?fit=crop&w=800&q=80',
            title: 'Cozy Townhouse',
            address: '789 Pine Road, Springfield, IL',
            price: '\$320,000',
            details: '3 bed • 2 bath • 1800 sqft',
            agentName: 'By Mike Davis',
            time: '1 day ago',
            status: 'Pending',
            statusColor: secondaryColor,
            showActions: true,
          ),
        ],
      );
    } else {
      // Approved List
      return Column(
        children: [
          _buildPropertyCard(
            image:
                'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?fit=crop&w=800&q=80',
            title: 'Downtown Condo',
            address: '321 Main Street, Springfield, IL',
            price: '\$380,000',
            details: '2 bed • 2 bath • 1400 sqft',
            agentName: '',
            time: '3 days ago',
            status: 'Approved',
            statusColor: const Color(0xFF2D6A5F),
            showActions: false,
          ),
          SizedBox(height: 16.h),
          _buildPropertyCard(
            image:
                'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?fit=crop&w=800&q=80',
            title: 'Suburban Paradise',
            address: '654 Elm Drive, Springfield, IL',
            price: '\$520,000',
            details: '4 bed • 3 bath • 2800 sqft',
            agentName: '',
            time: '1 week ago',
            status: 'Approved',
            statusColor: const Color(0xFF2D6A5F),
            showActions: false,
          ),
        ],
      );
    }
  }

  Widget _buildPropertyCard({
    required String image,
    required String title,
    required String address,
    required String price,
    required String details,
    required String agentName,
    required String time,
    required String status,
    required Color statusColor,
    required bool showActions,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  image,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.lora(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  address,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 8.h),
                Text(
                  price,
                  style: GoogleFonts.lora(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D6A5F),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  details,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                if (agentName.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        agentName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        ' • $time',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  SizedBox(height: 8.h),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
                if (showActions) ...[
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(
                              color: Colors.red.withOpacity(0.2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            'Decline',
                            style: GoogleFonts.lora(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B4D3E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            'Approve',
                            style: GoogleFonts.lora(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
