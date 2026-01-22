import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/const/app_colors.dart';
import '../../../../core/models/agent_listing_model.dart';
import '../../notification/screens/AgentNotificationScreen.dart';
import '../Controller/agent_home_controller.dart';

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  final AgentHomeController _controller = Get.put(AgentHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            // Initialize ScreenUtil
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 50.h,
                  ),
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

                      // 4. Property List
                      _buildPropertyList(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage: _controller.user.value?.profilePicture != null
                  ? NetworkImage(_controller.user.value!.profilePicture!)
                        as ImageProvider
                  : null,
              child: _controller.user.value?.profilePicture == null
                  ? Icon(Icons.person, size: 35.sp, color: primaryColor)
                  : null,
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      _controller.user.value?.fullName.isNotEmpty == true
                          ? ' ${_controller.user.value!.fullName}'
                          : ' ${_controller.user.value?.username ?? 'Agent'}',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                  ],
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
    final stats = _controller.stats.value;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.access_time,
                iconColor: secondaryColor,
                iconBgColor: const Color(0xFFFCEDE0),
                count: stats.pendingCount.toString(),
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
                count: stats.acceptedCount.toString(),
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
          count: stats.totalRequests.toString(),
          label: 'Total Requests',
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

  Widget _buildPropertyList() {
    final listings = _controller.listings;
    if (listings.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Icon(
              Icons.home_work_outlined,
              size: 64.sp,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16.h),
            Text(
              'No properties found',
              style: GoogleFonts.lora(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: listings
          .map(
            (listing) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildPropertyCard(listing),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPropertyCard(AgentListing listing) {
    Color statusColor = listing.status == 'for_sale'
        ? blueColor
        : secondaryColor;

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
                child: listing.photoUrl != null
                    ? Image.network(
                        listing.photoUrl!,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180.h,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey[400],
                          ),
                        ),
                      )
                    : Container(
                        height: 180.h,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Icon(Icons.image, color: Colors.grey[400]),
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
                    listing.status.replaceAll('_', ' ').capitalizeFirst ?? '',
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
                Text(
                  listing.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  listing.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$${listing.price.toStringAsFixed(0)}',
                  style: GoogleFonts.lora(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D6A5F),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.king_bed_outlined,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${listing.bedrooms} bed',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.bathroom_outlined,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${listing.bathrooms.toInt()} bath',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.square_foot_outlined,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${listing.squareFeet} sqft',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
