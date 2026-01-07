import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/agent_agreement_model.dart';
import '../../Home/Controller/agent_home_controller.dart';

class AgreementListScreen extends StatelessWidget {
  AgreementListScreen({super.key});

  final AgentHomeController controller = Get.find<AgentHomeController>();

  @override
  Widget build(BuildContext context) {
    // Refresh agreements when screen opens
    controller.fetchAgreements();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Agreement List',
          style: GoogleFonts.lora(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isAgreementsLoading.value &&
            controller.agreements.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (controller.agreements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 80.sp,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No agreements found',
                  style: GoogleFonts.lora(
                    fontSize: 18.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAgreements(),
          color: primaryColor,
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.agreements.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final agreement = controller.agreements[index];
              return _buildAgreementCard(context, agreement);
            },
          ),
        );
      }),
    );
  }

  Widget _buildAgreementCard(BuildContext context, AgentAgreement agreement) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
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
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${agreement.id}',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                    _buildStatusChip(agreement.agreementStatus),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  Icons.person_outline,
                  'Seller: ${agreement.sellerName}',
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  Icons.location_on_outlined,
                  agreement.sellingRequestPropertyLocation,
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  Icons.attach_money,
                  'Asking Price: \$${agreement.sellingRequestAskingPrice}',
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  Icons.calendar_today_outlined,
                  'Date: ${agreement.createdAt.isNotEmpty ? agreement.createdAt.split('T')[0] : 'N/A'}',
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _viewDocument(agreement.sellingAgreementFile),
                        icon: const Icon(Icons.picture_as_pdf, size: 20),
                        label: const Text('View Agreement'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: const BorderSide(color: primaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
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

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'accepted':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.isNotEmpty
            ? status[0].toUpperCase() + status.substring(1).toLowerCase()
            : 'N/A',
        style: GoogleFonts.lora(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: Colors.grey[600]),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lora(fontSize: 14.sp, color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _viewDocument(String url) async {
    if (url.isEmpty) {
      Get.snackbar(
        'Error',
        'Document URL is not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open the document',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
