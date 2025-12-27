import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/feature/Sellers/ViewCMAReport/screen/ViewCMAReportScreen.dart';

import '../../../../core/const/app_colors.dart';
import '../../BrokerageRelationship/Screens/CMAbrokerageRelationshipScreen.dart';
import '../controller/notification_controller.dart';
import 'SellingAgreementScreen.dart';

class sallerNotificationScreen extends StatelessWidget {
  sallerNotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());
  static const Color _redBtn = Color(0xFFD32F2F);
  static const Color _cardBorder = Color(0xFFEEEEEE); // Light grey border

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
                style: GoogleFonts.lora(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${controller.unreadCount.value} unread message${controller.unreadCount.value != 1 ? 's' : ''}',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          Obx(
            () => controller.unreadCount.value > 0
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: InkWell(
                        onTap: () => controller.markAllAsRead(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1), // Light teal bg
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Mark all read',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
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
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationCard(notification) {
    // Determine action button and callback based on notification type
    Widget? actionWidget;
    bool hasDualActions = false;
    VoidCallback? onAccept;

    switch (notification.notificationType) {
      case 'approved':
        actionWidget = _buildFullWidthButton(
          label: notification.actionText ?? 'View CMA Report',
          icon: Icons.check,
          onPressed: () {
            controller.markAsRead(notification.id);
            Get.to(
              () => ViewCMAReportScreen(
                sellingRequestId:
                    notification.sellingRequestId ?? notification.id,
              ),
            );
          },
        );
        break;
      case 'declined':
        actionWidget = _buildFullWidthButton(
          label: 'Chat with Agent',
          icon: Icons.chat_outlined,
          onPressed: () {
            controller.markAsRead(notification.id);
            // Navigate to chat
            Get.snackbar('Chat', 'Opening chat with agent...');
          },
        );
        break;
      case 'agreement':
        hasDualActions = true;
        onAccept = () {
          controller.markAsRead(notification.id);
          // Prefer explicit agreement id; fall back to extracting from actionUrl/message
          final agreementId =
              notification.agreementId ??
              _extractAgreementId(
                notification.actionUrl ?? notification.message,
              );
          Get.to(() => SellingAgreementScreen(agreementId: agreementId));
        };
        break;
      case 'cma_ready':
        actionWidget = _buildFullWidthButton(
          label: notification.actionText ?? 'Open CMA',
          icon: Icons.remove_red_eye_outlined,
          onPressed: () {
            controller.markAsRead(notification.id);
            // Prefer explicit cma_id if present; fallback to extracting from actionUrl/message
            final cmaId =
                notification.cmaId ??
                _extractCmaId(notification.actionUrl ?? notification.message);
            Get.to(() => CMABrokerageRelationshipScreen(cmaId: cmaId));
          },
        );
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: !notification.isRead ? secondaryColor : _cardBorder,
          width: !notification.isRead ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Bubble
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: secondaryText,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.lora(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryText,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.relativeTime,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Custom Full Width Button
          if (actionWidget != null) ...[
            const SizedBox(height: 16),
            actionWidget,
          ],

          // Dual Actions (Accept/Decline)
          if (hasDualActions) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Accept',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.markAsRead(notification.id);
                      Get.snackbar('Declined', 'Agreement declined');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _redBtn,
                      side: const BorderSide(color: Color(0xFFFFEBEE)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Decline',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  int? _extractCmaId(String? text) {
    if (text == null) return null;
    final regex = RegExp(r'/seller/cma/(\d+)/?');
    final match = regex.firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    // Fallback: try to find any number in the text
    final fallback = RegExp(r'(\d+)').firstMatch(text);
    if (fallback != null) return int.tryParse(fallback.group(1)!);
    return null;
  }

  int? _extractAgreementId(String? text) {
    if (text == null) return null;
    final regex = RegExp(r'/seller/agreements/(\d+)/?');
    final match = regex.firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    // Fallback: try to find any number in the text
    final fallback = RegExp(r'(\d+)').firstMatch(text);
    if (fallback != null) return int.tryParse(fallback.group(1)!);
    return null;
  }

  Widget _buildFullWidthButton({
    required String label,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ), // Less rounded for full width
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
