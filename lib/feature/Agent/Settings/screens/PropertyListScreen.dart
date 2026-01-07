import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import '../../Home/Controller/agent_home_controller.dart';
import '../../../../core/models/agent_listing_model.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We assume AgentHomeController is already initialized in AgentHomeScreen
    // but we use Get.find to access it.
    final AgentHomeController controller = Get.find<AgentHomeController>();

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
          'Property List',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.listings.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home_work_outlined,
                  size: 64.sp,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No listed properties found',
                  style: GoogleFonts.lora(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Listed Property',
                style: GoogleFonts.lora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 16.h),
              ...controller.listings.map(
                (listing) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildPropertyCard(listing),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPropertyCard(AgentListing listing) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          Container(
            width: 130.w,
            height: 150.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: listing.photoUrl != null
                  ? Image.network(
                      listing.photoUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: primaryColor.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              Icons.home,
                              size: 50.sp,
                              color: primaryColor.withOpacity(0.3),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: primaryColor.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 50.sp,
                          color: primaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
            ),
          ),
          // Property Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
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
                    style: GoogleFonts.lora(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '\$${listing.price.toStringAsFixed(0)}',
                    style: GoogleFonts.lora(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${listing.bedrooms} bed  •  ${listing.bathrooms.toInt()} bath  •  ${listing.squareFeet} sqft',
                    style: GoogleFonts.lora(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    listing.status.replaceAll('_', ' ').capitalizeFirst ?? '',
                    style: GoogleFonts.lora(
                      fontSize: 11.sp,
                      color: secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
