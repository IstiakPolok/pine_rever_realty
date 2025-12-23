import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../../../core/const/app_colors.dart';
import '../../../../../core/models/selling_request_response.dart';
import '../../../../../core/network_caller/endpoints.dart';
import '../../../../../core/services_class/local_service/shared_preferences_helper.dart';

class SellingRequestListScreen extends StatefulWidget {
  const SellingRequestListScreen({super.key});

  @override
  State<SellingRequestListScreen> createState() =>
      _SellingRequestListScreenState();
}

class _SellingRequestListScreenState extends State<SellingRequestListScreen> {
  List<SellingRequest> _sellingRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSellingRequests();
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
      body: RefreshIndicator(
        onRefresh: fetchSellingRequests,
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: _sellingRequests.length,
          itemBuilder: (context, index) {
            final req = _sellingRequests[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildRequestCard(req),
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
        color: const Color(0xFFEEF6F4),
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
                backgroundColor: const Color(0xFFE67E22),
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
}
