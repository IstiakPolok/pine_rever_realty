import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/const/app_colors.dart';
import '../model/cma_report_model.dart';
import '../service/cma_report_service.dart';

class CMAReportListScreen extends StatefulWidget {
  const CMAReportListScreen({super.key});

  @override
  State<CMAReportListScreen> createState() => _CMAReportListScreenState();
}

class _CMAReportListScreenState extends State<CMAReportListScreen> {
  late Future<CMAReportListResponse?> _futureReports;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    setState(() {
      _futureReports = CMAReportService().fetchCMAReports();
    });
  }

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
        title: Text(
          'CMA Report List',
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
      body: FutureBuilder<CMAReportListResponse?>(
        future: _futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load reports'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.results.isEmpty) {
            return Center(child: Text('No reports found'));
          }
          final reports = snapshot.data!.results;
          return RefreshIndicator(
            onRefresh: () async => _loadReports(),
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return _buildReportCard(reports[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildReportCard(CMAReport report) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report.title.isNotEmpty ? report.title : 'CMA Report',
                  style: GoogleFonts.lora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'ID: ${report.id}',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: secondaryText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            report.sellingRequestPropertyLocation.isNotEmpty
                ? report.sellingRequestPropertyLocation
                : 'Check your properties CMA report & Agreement',
            style: GoogleFonts.lora(
              fontSize: 14.sp,
              color: const Color(0xFF2D6A5F),
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Sent by Agent: ',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: secondaryText,
                  ),
                ),
                TextSpan(
                  text: report.sellingRequestContactName,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement view/download logic for report.fileUrl or report.files
            },
            icon: Icon(
              Icons.remove_red_eye_outlined,
              size: 18.sp,
              color: Colors.white,
            ),
            label: Text(
              'View',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
