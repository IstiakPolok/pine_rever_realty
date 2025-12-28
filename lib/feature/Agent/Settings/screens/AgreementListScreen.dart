import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network_caller/endpoints.dart';

class AgreementListScreen extends StatefulWidget {
  const AgreementListScreen({super.key});

  @override
  State<AgreementListScreen> createState() => _AgreementListScreenState();
}

class _AgreementListScreenState extends State<AgreementListScreen> {
  late Future<List<Map<String, dynamic>>> _agreementsFuture;

  @override
  void initState() {
    super.initState();
    _agreementsFuture = _fetchAgreements();
  }

  Future<List<Map<String, dynamic>>> _fetchAgreements() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final url = Uri.parse('${Urls.baseUrl}/agent/agreements/');
    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> agreements = data['agreements'] ?? [];
      return agreements.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load agreements');
    }
  }

  void _viewDocument(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open document')));
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
          'Agreements List',
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
              'Your Agreements',
              style: GoogleFonts.lora(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _agreementsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load agreements'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No agreements found'));
                  }
                  final agreements = snapshot.data!;
                  return ListView.separated(
                    itemCount: agreements.length,
                    separatorBuilder: (context, i) => SizedBox(height: 12.h),
                    itemBuilder: (context, i) {
                      final a = agreements[i];
                      final id = a['id']?.toString() ?? '';
                      final title = a['title'] ?? 'Agreement';
                      final status = a['agreement_status'] ?? '';
                      final fileUrl = a['selling_agreement_file'] ?? '';
                      final ext = a['selling_agreement_file_extension'] ?? '';
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ID: $id',
                                  style: GoogleFonts.lora(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: primaryText,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: GoogleFonts.lora(
                                    fontSize: 13.sp,
                                    color: status == 'accepted'
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              title,
                              style: GoogleFonts.lora(
                                fontSize: 15.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  color: primaryColor,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  ext.toUpperCase(),
                                  style: GoogleFonts.lora(fontSize: 13.sp),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: fileUrl.isNotEmpty
                                      ? () => _viewDocument(fileUrl)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 18.w,
                                      vertical: 10.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text('View'),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}
