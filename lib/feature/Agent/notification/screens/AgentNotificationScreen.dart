import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const/app_colors.dart';
import '../../SellingAgreement/screens/AgentSellingAgreementScreen.dart';
import '../controller/agent_notification_controller.dart';
import 'agent_documents_screen.dart';

class AgentNotificationScreen extends StatelessWidget {
  AgentNotificationScreen({super.key});

  final AgentNotificationController controller = Get.put(
    AgentNotificationController(),
  );

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
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${controller.unreadCount.value} unread message${controller.unreadCount.value != 1 ? 's' : ''}',
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Failed to load notifications',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchNotifications(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              Obx(
                () => controller.unreadCount.value > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () => controller.markAllAsRead(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'Mark all read',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              ...controller.notifications.map((notification) {
                return _buildNotificationFromData(notification);
              }).toList(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNotificationFromData(notification) {
    // Determine icon based on notification type
    IconData icon = Icons.notifications_outlined;
    switch (notification.notificationType) {
      case 'new_selling_request':
        icon = Icons.home_outlined;
        break;
      case 'document_uploaded':
      case 'document_updated':
        icon = Icons.description_outlined;
        break;
      case 'cma_ready':
        icon = Icons.description_outlined;
        break;
      case 'showing_scheduled':
        icon = Icons.calendar_today_outlined;
        break;
    }

    Widget content;

    // Build content based on notification type
    switch (notification.notificationType) {
      case 'new_selling_request':
        if (notification.sellingRequestId != null) {
          content = Obx(() {
            final detail =
                controller.sellingRequestDetails[notification.sellingRequestId];
            if (detail == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    icon,
                    notification.title,
                    notification.message,
                    notification.relativeTime,
                    isUnread: !notification.isRead,
                  ),
                  SizedBox(height: 16.h),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            }
            return _buildPropertyRequestCard(notification, detail);
          });
        } else {
          content = _buildHeader(
            icon,
            notification.title,
            notification.message,
            notification.relativeTime,
            isUnread: !notification.isRead,
          );
        }
        break;

      case 'cma_ready':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              icon,
              notification.title,
              notification.message,
              notification.relativeTime,
              isUnread: !notification.isRead,
            ),
            SizedBox(height: 16.h),
            _buildFullWidthButton(
              'Send Agreement',
              primaryColor,
              onPressed: () {
                controller.markAsRead(notification.id);
                if (notification.documentId != null) {
                  Get.to(
                    () => AgentSellingAgreementScreen(
                      propertyDocumentId: notification.documentId!,
                    ),
                  );
                } else {
                  Get.snackbar('Error', 'Property document id not available');
                }
              },
            ),
          ],
        );
        break;

      case 'document_updated':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              icon,
              notification.title,
              notification.message,
              notification.relativeTime,
              isUnread: !notification.isRead,
            ),
            SizedBox(height: 16.h),
            _buildFullWidthButton(
              'Chat with Seller',
              primaryColor,
              onPressed: () {
                controller.markAsRead(notification.id);
                Get.snackbar('Chat', 'Opening chat with seller...');
              },
            ),
          ],
        );
        break;

      case 'document_uploaded':
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              icon,
              notification.title,
              notification.message,
              notification.relativeTime,
              isUnread: !notification.isRead,
            ),
            SizedBox(height: 16.h),
            _buildFullWidthButton(
              notification.actionText ?? 'View Document',
              primaryColor,
              onPressed: () {
                controller.markAsRead(notification.id);
                // If action is "View Documents", open the documents viewer; otherwise just show message
                final action = (notification.actionText ?? '').toLowerCase();
                if (action.contains('view') &&
                    notification.sellingRequestId != null) {
                  Get.to(
                    () => AgentDocumentsScreen(
                      sellingRequestId: notification.sellingRequestId!,
                    ),
                  );
                } else if (notification.documentId != null) {
                  // Open document detail or show message
                  Get.snackbar(
                    'Document',
                    'Open document id=${notification.documentId}',
                  );
                } else {
                  Get.snackbar('Document', 'Opening document...');
                }
              },
            ),
          ],
        );
        break;

      default:
        content = _buildHeader(
          icon,
          notification.title,
          notification.message,
          notification.relativeTime,
          isUnread: !notification.isRead,
        );
    }

    return _buildNotificationCard(child: content);
  }

  Widget _buildNotificationCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5), // Light beige/cream background
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE4B894), // Beige/tan border
          width: 1.5,
        ),
      ),
      child: child,
    );
  }

  Widget _buildHeader(
    IconData icon,
    String title,
    String description,
    String time, {
    bool isUnread = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.lora(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.lora(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
              if (time.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: GoogleFonts.lora(
                    fontSize: 11.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyRequestCard(notification, detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Property Selling Request',
              style: GoogleFonts.lora(fontSize: 14.sp, color: primaryText),
            ),
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE67E22), // Orange dot
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          detail.sellerName,
          style: GoogleFonts.lora(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E5C55), // Greenish text
          ),
        ),
        Text(
          notification.propertyTitle ?? 'Modern Family Home',
          style: GoogleFonts.lora(
            fontSize: 14.sp,
            color: primaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          detail.sellingReason,
          style: GoogleFonts.lora(
            fontSize: 13.sp,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
        SizedBox(height: 12.h),
        _buildDetailRow('Time', '${detail.startDate} - ${detail.endDate}'),
        _buildDetailRow('Email', detail.sellerEmail),
        _buildDetailRow('Phone Number', detail.sellerPhone ?? 'N/A'),
        SizedBox(height: 12.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Asking Price: ',
                style: GoogleFonts.lora(
                  fontSize: 16.sp,
                  color: const Color(0xFF2E5C55),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: '\$${detail.askingPrice}',
                style: GoogleFonts.lora(
                  fontSize: 16.sp,
                  color: const Color(0xFF2E5C55),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Seller: ${detail.sellerName.split(' ').first}',
          style: GoogleFonts.lora(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 16.h),
        // Show spinner while updating; show buttons only when pending; otherwise show status label
        if (notification.sellingRequestId != null &&
            controller.updatingRequests[notification.sellingRequestId!] ==
                true) ...[
          Center(
            child: SizedBox(
              height: 24.h,
              width: 24.h,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ] else if ((notification.sellingRequestStatus ??
                    detail.status ??
                    'pending')
                .toLowerCase() ==
            'pending') ...[
          _buildDualActionButtons(
            onAccept: () {
              controller.markAsRead(notification.id);
              controller.updateSellingRequestStatus(
                sellingRequestId: notification.sellingRequestId!,
                status: 'accepted',
              );
            },
            onDecline: () {
              controller.markAsRead(notification.id);
              controller.updateSellingRequestStatus(
                sellingRequestId: notification.sellingRequestId!,
                status: 'rejected',
              );
            },
            acceptLabel: 'Approve',
          ),
        ] else ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color:
                    (notification.sellingRequestStatus ??
                                detail.status ??
                                'pending')
                            .toLowerCase() ==
                        'accepted'
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                ((notification.sellingRequestStatus ?? detail.status) ?? '')
                    .toString()
                    .toUpperCase(),
                style: GoogleFonts.lora(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      (notification.sellingRequestStatus ??
                                  detail.status ??
                                  'pending')
                              .toLowerCase() ==
                          'accepted'
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFD32F2F),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.lora(fontSize: 13.sp, color: Colors.grey[600]),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lora(fontSize: 13.sp, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthButton(
    String label,
    Color color, {
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.lora(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildDualActionButtons({
    required VoidCallback onAccept,
    required VoidCallback onDecline,
    String acceptLabel = 'Accept',
    String declineLabel = 'Decline',
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  acceptLabel,
                  style: GoogleFonts.lora(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: OutlinedButton(
            onPressed: onDecline,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.withOpacity(0.3)),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  declineLabel,
                  style: GoogleFonts.lora(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
