import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../../../core/const/app_colors.dart';
import '../../../../../core/models/selling_request_response.dart';
import '../../../../../core/models/profile_response.dart';
import '../../../../../core/services_class/local_service/shared_preferences_helper.dart';

import '../../../../core/network_caller/endpoints.dart';
import '../../Notification/screen/NotificationScreen.dart';
import 'PropertiesRequestFormScreen.dart';

class SallerHomeScreen extends StatefulWidget {
  const SallerHomeScreen({super.key});

  @override
  State<SallerHomeScreen> createState() => _SallerHomeScreenState();
}

class _SallerHomeScreenState extends State<SallerHomeScreen> {
  List<SellingRequest> _sellingRequests = [];
  bool isLoading = true;

  // Seller profile
  ProfileResponse? _profile;
  bool _isProfileLoading = true;

  static const Color _cardBg = Color(0xFFEEF6F4);

  @override
  void initState() {
    super.initState();
    fetchSellingRequests();
    fetchProfile();
  }

  Future<void> fetchSellingRequests() async {
    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Error', 'No access token found');
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.sellerSellingRequestslist),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sellingResponse = SellingRequestsResponse.fromJson(data);
        setState(() {
          _sellingRequests = sellingResponse.results;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Error', 'Failed to load selling requests');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> fetchProfile() async {
    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        setState(() {
          _isProfileLoading = false;
        });
        Get.snackbar('Error', 'No access token found');
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.sellerProfile),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _profile = ProfileResponse.fromJson(data);
          _isProfileLoading = false;
        });
      } else {
        setState(() {
          _isProfileLoading = false;
        });
        Get.snackbar('Error', 'Failed to load profile');
      }
    } catch (e) {
      setState(() {
        _isProfileLoading = false;
      });
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: fetchSellingRequests,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Initialize ScreenUtil
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
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
                      SizedBox(height: 20.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Request list',
                            style: TextStyle(
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
                              onPressed: () async {
                                await Get.to(
                                  () => PropertiesRequestFormScreen(),
                                );
                                fetchSellingRequests();
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: Text(
                                'Add New Selling Request',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
      ),
    );
  }

  Widget _buildRequestCard(SellingRequest request) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seller Name
          Text(
            request.contactName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),

          // Selling Reason (Description)
          Text(
            request.sellingReason,
            style: TextStyle(
              fontSize: 14,
              color: primaryText.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Details
          _buildDetailLine(
            'Time: ',
            '${DateFormat('dd MMM, yyyy').format(DateTime.parse(request.startDate))} - ${DateFormat('dd MMM, yyyy').format(DateTime.parse(request.endDate))}',
          ),
          const SizedBox(height: 4),
          _buildDetailLine('Email: ', request.contactEmail),
          const SizedBox(height: 4),
          _buildDetailLine(
            'Phone Number: ',
            request.contactPhone ?? 'Not provided',
          ),
          const SizedBox(height: 20),

          // Asking Price
          Text(
            'Asking Price: \$${request.askingPrice}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),

          // Agent
          if (request.agentName != null && request.agentName!.isNotEmpty)
            Text(
              'Agent: ${request.agentName}',
              style: TextStyle(
                fontSize: 14,
                color: greyText,
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 24),

          // Status Button
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFFE67E22,
                ), // Orange color from image
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                request.status.substring(0, 1).toUpperCase() +
                    request.status.substring(1).toLowerCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
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
        style: TextStyle(fontSize: 13, color: greyText),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: value,
            style: TextStyle(color: primaryText),
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
            _isProfileLoading
                ? SizedBox(
                    width: 48,
                    height: 48,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : CircleAvatar(
                    radius: 24,
                    backgroundImage: _profile?.profileImage != null
                        ? NetworkImage(_profile!.profileImage!)
                        : const NetworkImage(
                                'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8=',
                              )
                              as ImageProvider,
                  ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isProfileLoading
                      ? 'Hello'
                      : (_profile != null &&
                                ('${_profile!.firstName ?? ''} ${_profile!.lastName ?? ''}'
                                    .trim()
                                    .isNotEmpty)
                            ? '${_profile!.firstName ?? ''} ${_profile!.lastName ?? ''}'
                            : (_profile?.username ?? 'Hello')),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'Sell your property easily',
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
