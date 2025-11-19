import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import '../../PropertyDetailsScreen /screens/PropertyDetailsScreen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  // Combined Data for the List View
  final List<Map<String, dynamic>> _allProperties = [
    {
      "title": "Modern Family Home",
      "address": "123 Oak Street, Springfield",
      "price": "\$849,000",
      "beds": 4,
      "baths": 3,
      "sqft": "2,800",
      "agent": "Sarah Johnson",
      "image":
          "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fit=crop&w=800&q=80",
      "isFavorite": false,
    },
    {
      "title": "Luxury Downtown Condo",
      "address": "456 Main Avenue, Downtown",
      "price": "\$225,000",
      "beds": 4,
      "baths": 3,
      "sqft": "1,500",
      "agent": "Sarah Johnson",
      "image":
          "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fit=crop&w=800&q=80",
      "isFavorite": true,
    },
    {
      "title": "Charming Suburban House",
      "address": "789 Maple Drive, Westside",
      "price": "\$675,000",
      "beds": 3,
      "baths": 2,
      "sqft": "2,200",
      "agent": "Michael Chen",
      "image":
          "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fit=crop&w=800&q=80",
      "isFavorite": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // 1. Top Bar (Fixed at top)
                  _buildTopBar(),
                  SizedBox(height: 20.h),

                  // 2. Search Bar (Fixed at top)
                  _buildSearchBar(),
                  SizedBox(height: 20.h),

                  // 3. Scrollable Property List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _allProperties.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PropertyDetailsScreen(),
                              ),
                            );
                          },
                          child: _buildPropertyCard(_allProperties[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: const NetworkImage(
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
              onPressed: () {},
              color: primaryColor,
            ),
            Positioned(
              right: 12.w,
              top: 12.h,
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
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(
                0xFFFFF3E0,
              ).withOpacity(0.5), // Light orange bg
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search properties',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: primaryText),
            onPressed: () {
              _showFilterDialog(context); // Trigger the filter dialog
            },
          ),
        ),
      ],
    );
  }

  // --- FILTER DIALOG LOGIC ---

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.lora(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Price Range
                  _buildFilterLabel('Price Range'),
                  _buildFilterInput(hint: 'Price'),
                  const SizedBox(height: 16),

                  // Minimum Bedroom
                  _buildFilterLabel('Minimum Bedroom'),
                  _buildFilterDropdown(
                    hint: 'Any',
                    items: ['Any', '1', '2', '3', '4+'],
                  ),
                  const SizedBox(height: 16),

                  // Location
                  _buildFilterLabel('Location'),
                  _buildFilterDropdown(
                    hint: 'Your expected location',
                    items: [
                      'New York',
                      'Los Angeles',
                      'Chicago',
                      'Springfield',
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Add logic to clear filters
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Get.off(() => PropertyListScreen());

                            // Add logic to apply filters
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Apply Filters',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
    );
  }

  // Helper for the Filter Dialog Labels
  Widget _buildFilterLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.lora(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
      ),
    );
  }

  // Helper for Input Fields in Filter Dialog
  Widget _buildFilterInput({required String hint}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // Light grey from image
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // Helper for Dropdowns in Filter Dialog
  Widget _buildFilterDropdown({
    required String hint,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // Light grey from image
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: TextStyle(color: primaryText)),
            );
          }).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }

  // --- END FILTER DIALOG LOGIC ---

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  property['image'],
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // For Sale Tag
              Positioned(
                top: 16.h,
                left: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'For Sale',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Heart Icon
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    property['isFavorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: property['isFavorite'] ? Colors.red : Colors.grey,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property['title'],
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      property['address'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Stats Row
                Row(
                  children: [
                    _buildStat(Icons.bed_outlined, '${property['beds']} beds'),
                    const SizedBox(width: 16),
                    _buildStat(
                      Icons.bathtub_outlined,
                      '${property['baths']} baths',
                    ),
                    const SizedBox(width: 16),
                    _buildStat(Icons.square_foot, '${property['sqft']} sqft'),
                  ],
                ),
                const SizedBox(height: 16),

                // Price and Agent
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property['price'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blueColor,
                      ),
                    ),
                    Text(
                      'Agent: ${property['agent']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey[600]),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
