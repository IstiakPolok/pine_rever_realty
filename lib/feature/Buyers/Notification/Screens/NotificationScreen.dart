import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../ShowingAgreement/screen/ShowingAgreementScreen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Colors
  static const Color _textDark = Color(0xFF212121);
  static const Color _textGrey = Color(0xFF616161);
  static const Color _greenBtn = Color(0xFF2D6A5F);
  static const Color _redBtn = Color(0xFFD32F2F);
  static const Color _orangeDot = Color(0xFFE8772E);
  static const Color _cardBorder = Color(0xFFEEEEEE);
  static const Color _highlightBorder = Color(0xFFE8772E);
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
            Text(
              '4 unread message',
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16.0),
        //     child: Center(
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 12,
        //           vertical: 6,
        //         ),
        //         decoration: BoxDecoration(
        //           color: const Color(0xFFE0F2F1), // Light teal bg
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         child: Text(
        //           'Mark all read',
        //           style: TextStyle(
        //             fontSize: 12,
        //             fontWeight: FontWeight.w500,
        //             color: _textDark,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
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
                  ],
                ),
                _buildNotificationCard(
                  icon: Icons.notifications_outlined,
                  title: 'Showing Confirmed',
                  description:
                      'Your agreement is ready for digital signature for showing.',
                  time: '5 hours ago',
                  isUnread: true,
                  hasActions: true,
                  isHighlighted: true,
                ),

                // Showing Updated
                _buildNotificationCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Showing Updated',
                  description:
                      'Your showing details have been updated by your agent.',
                  time: '2 hours ago',
                  isUnread: true,
                  isHighlighted: true,
                  contentWidget: Text(
                    'Your showing time & date has been changed. Check your schedule list for updates.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: _textGrey,
                      height: 1.4,
                    ),
                  ),
                ),

                // Showing Declined
                _buildNotificationCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Showing Declined',
                  description:
                      'Your appointment scheduled has been declined by the agent. We apologize for the inconvenience and will contact you soon to arrange a new time.',
                  time: '2 hours ago',
                  isUnread: true,
                  isHighlighted: true,
                  contentWidget: _buildPropertyContent(
                    image:
                        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fit=crop&w=200&q=80',
                    title: 'Luxury Downtown Condo',
                    address: '456 Main Avenue, Downtown',
                    dateTime: 'Nov 15, 2025  10:00 AM',
                    agentName: 'Michael Chen',
                  ),
                ),

                _buildNotificationCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Showing Scheduled Successful',
                  description: 'Your showing has been scheduled successfully',
                  time: '2 hours ago',
                  isUnread: true,
                  isHighlighted: true,
                  contentWidget: _buildPropertyContent(
                    image:
                        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fit=crop&w=200&q=80',
                    title: 'Luxury Downtown Condo',
                    address: '456 Main Avenue, Downtown',
                    dateTime: 'Nov 15, 2025  10:00 AM',
                    agentName: 'Michael Chen',
                  ),
                ),

                _buildNotificationCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Showing Schedule',
                  description:
                      'Your property showing schedule has been Set by the agent',
                  time: '2 hours ago',
                  isUnread: true,
                  isHighlighted: true,
                  contentWidget: _buildPropertyContent(
                    image:
                        "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?fit=crop&w=800&q=80",
                    title: 'Modern Family Home',
                    address: '123 Oak Street, Springfield',
                    dateTime: 'Nov 15, 2025  3:00 PM',
                    agentName: 'Sarah Johnson',
                  ),
                  hasActions: true,
                ),

                // 4. New Property Match (Simple)
                _buildNotificationCard(
                  icon: Icons.notifications_outlined,
                  title: 'New Property Match',
                  description: '3 new properties match your search criteria',
                  time: '2 days ago',
                  isUnread: false,
                  isHighlighted: false,
                ),
              ],
            ),
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
    Widget? contentWidget,
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
                      // Only navigate for 'Showing Schedule' title
                      if (title == 'Showing Schedule') {
                        Get.to(() => const ShowingAgreementScreen());
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
                          'Accept',
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
