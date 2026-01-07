import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../controller/buyer_notification_controller.dart';
import '../../ShowingAgreement/screen/ShowingAgreementScreen.dart';
import '../../../../core/models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final BuyerNotificationController _controller = Get.put(
    BuyerNotificationController(),
  );

  // Colors
  static const Color _textDark = Color(0xFF212121);
  static const Color _textGrey = Color(0xFF616161);
  static const Color _greenBtn = Color(0xFF2D6A5F);
  static const Color _redBtn = Color(0xFFD32F2F);
  static const Color _orangeDot = Color(0xFFE8772E);
  static const Color _cardBorder = Color(0xFFEEEEEE);
  static const Color _highlightBorder = Color(0xFFE8772E);

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      DateTime dt = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat('MMM dd, yyyy  hh:mm a').format(dt);
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _getTimeAgo(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    try {
      DateTime dt = DateTime.parse(dateTimeStr).toLocal();
      Duration diff = DateTime.now().difference(dt);
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes} mins ago';
      return 'just now';
    } catch (e) {
      return '';
    }
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
          onPressed: () => Get.back(),
        ),
        title: Column(
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
            Obx(
              () => Text(
                '${_controller.unreadCount.value} unread message',
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: _greenBtn),
                );
              }

              if (_controller.errorMessage.isNotEmpty) {
                return Center(child: Text(_controller.errorMessage.value));
              }

              if (_controller.notifications.isEmpty) {
                return const Center(child: Text('No notifications found'));
              }

              return RefreshIndicator(
                onRefresh: () => _controller.fetchNotifications(),
                color: _greenBtn,
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _controller.notifications.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: () {
                                // Add logic to mark all read if needed
                              },
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
                                    color: _textDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    final notification = _controller.notifications[index - 1];
                    IconData icon = Icons.notifications_outlined;
                    if (notification.notificationType == 'showing_accepted' ||
                        notification.notificationType == 'showing_scheduled' ||
                        notification.notificationType == 'showing_declined') {
                      icon = Icons.calendar_today_outlined;
                    }

                    return _buildNotificationCard(
                      notification: notification,
                      icon: icon,
                      title: notification.title ?? 'New Notification',
                      description: notification.message ?? '',
                      time: _getTimeAgo(notification.createdAt),
                      isUnread: !(notification.isRead),
                      hasActions:
                          notification.actionText != null &&
                          notification.title != 'Showing Request Declined' &&
                          notification.title !=
                              'Agreement Signed Successfully ✓',
                      isHighlighted: !(notification.isRead),
                      actionText: notification.actionText,
                      contentWidget: notification.propertyTitle != null
                          ? _buildPropertyContent(
                              image:
                                  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fit=crop&w=200&q=80', // No image in notification results, using fallback
                              title: notification.propertyTitle!,
                              address:
                                  '', // No address in results, would be nice to have
                              dateTime: _formatDateTime(notification.createdAt),
                              agentName: notification.agentName ?? 'Agent',
                            )
                          : null,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    bool isUnread = false,
    bool hasActions = false,
    bool isHighlighted = false,
    String? actionText,
    Widget? contentWidget,
    NotificationItem? notification,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isHighlighted ? _highlightBorder : _cardBorder,
          width: isHighlighted ? 1.5.w : 1.0.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
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
                child: Icon(icon, color: _greenBtn, size: 20.r),
              ),
              SizedBox(width: 12.w),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: _orangeDot,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: _textGrey,
                        height: 1.4.h,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (contentWidget != null) ...[SizedBox(height: 16.h), contentWidget],

          if (hasActions) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (title == 'Showing Schedule' ||
                          actionText == 'Sign Agreement') {
                        Get.to(
                          () => ShowingAgreementScreen(
                            notification: notification,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _greenBtn,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasActions)
                          Icon(
                            Icons.check,
                            size: 18.sp,
                          ), // Add icon only if needed
                        SizedBox(width: 8.w),
                        Text(
                          actionText ?? 'Accept',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (title == 'Showing Schedule') {
                        showDialog(
                          context: Get.context!,
                          barrierDismissible: true,
                          builder: (context) {
                            double imgSize = 220.w;
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 24.h,
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 16.h,
                                  right: 16.w,
                                  left: 16.w,
                                  bottom: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: imgSize,
                                      height: imgSize,
                                      child: Image.asset(
                                        'assets/image/notready.png',
                                        width: imgSize,
                                        height: imgSize,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _redBtn,
                      side: const BorderSide(
                        color: Color(0xFFFFEBEE),
                      ), // Very light red border
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Decline',
                          style: TextStyle(fontWeight: FontWeight.w500),
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

  Widget _buildPropertyContent({
    required String image,
    required String title,
    required String address,
    required String dateTime,
    required String agentName,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  image,
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          dateTime,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: Colors.grey),
          SizedBox(height: 8.h),
          Row(
            children: [
              CircleAvatar(
                radius: 10.r,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fit=crop&w=100&q=80',
                ),
              ),
              SizedBox(width: 8.w),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 11.sp, color: _textDark),
                  children: [
                    TextSpan(
                      text: agentName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: ' • Agent',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
