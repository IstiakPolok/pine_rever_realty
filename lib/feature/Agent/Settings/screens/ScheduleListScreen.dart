import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';

import '../../../../core/network_caller/endpoints.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  late Future<List<Map<String, dynamic>>> _showingsFuture;

  @override
  void initState() {
    super.initState();
    _showingsFuture = _fetchShowings();
  }

  Future<List<Map<String, dynamic>>> _fetchShowings() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final url = Uri.parse('${Urls.baseUrl}/agent/showings/');
    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load showings');
    }
  }

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
          'Schedule List',
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
            Text(
              'Your Upcoming Showings',
              style: GoogleFonts.lora(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _showingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load showings'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No showings found'));
                  }
                  final showings = snapshot.data!;
                  return ListView.separated(
                    itemCount: showings.length,
                    separatorBuilder: (context, i) => SizedBox(height: 12.h),
                    itemBuilder: (context, i) {
                      final s = showings[i];
                      final property = s['property_listing'] ?? {};
                      final title = property['title'] ?? 'Property';
                      final address = property['address'] ?? '';
                      final date = s['requested_date'] ?? '';
                      final time = s['preferred_time'] ?? '';
                      final buyer = s['buyer'] ?? {};
                      final buyerName = buyer['full_name'] ?? '';
                      final notes = s['additional_notes'] ?? '';
                      return _buildShowingCard(
                        title,
                        address,
                        date,
                        time,
                        buyerName,
                        notes,
                        const Color(0xFFE3F2FD),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowingCard(
    String title,
    String address,
    String date,
    String time,
    String buyerName,
    String notes,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            address,
            style: GoogleFonts.lora(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.person, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 6.w),
              Text(
                'Buyer: $buyerName',
                style: GoogleFonts.lora(
                  fontSize: 13.sp,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          if (notes.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.note, size: 16.sp, color: Colors.grey[600]),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    notes,
                    style: GoogleFonts.lora(
                      fontSize: 13.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 6.w),
              Text(
                date,
                style: GoogleFonts.lora(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: 24.w),
              Icon(Icons.access_time, size: 16.sp, color: Colors.grey[600]),
              SizedBox(width: 6.w),
              Text(
                time,
                style: GoogleFonts.lora(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
