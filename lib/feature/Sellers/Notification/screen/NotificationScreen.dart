import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/feature/Sellers/ViewCMAReport/screen/ViewCMAReportScreen.dart';

import '../../../../core/const/app_colors.dart';
import '../../BrokerageRelationship/Screens/CMAbrokerageRelationshipScreen.dart';
import 'SellingAgreementScreen.dart';

class sallerNotificationScreen extends StatelessWidget {
  const sallerNotificationScreen({super.key});

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
        title: Column(
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
              '4 unread message',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
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
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Selling Request Approved
          _buildNotificationCard(
            icon: Icons.notifications_outlined,
            title: 'Selling Request Approved',
            description:
                'Your property request has been accepted for review. Upload your property images or supporting documents so we can prepare your CMA report',
            time: '5 hours ago',
            isUnread: true,
            isHighlighted: true,
            customAction: _buildFullWidthButton(
              label: 'View CMA Report',
              icon: Icons.check,
              onPressed: () {
                Get.to(ViewCMAReportScreen());
              },
            ),
          ),

          // 2. Selling Request Declined
          _buildNotificationCard(
            icon: Icons.notifications_outlined,
            title: 'Selling Request Declined',
            description:
                'Your property selling request has been declined by the agent. We will reach out to you shortly to discuss next steps or you can contact via chat.',
            time: '5 hours ago',
            isUnread: true,
            isHighlighted: true,
            customAction: _buildFullWidthButton(
              label: 'Chat with Agent',
              // No icon for this one based on image, or add chat icon
              onPressed: () {
                // Navigate to chat
                Navigator.pushNamed(context, '/chat_detail');
              },
            ),
          ),

          // 3. Accept Selling Agreement
          _buildNotificationCard(
            icon: Icons.notifications_outlined,
            title: 'Accept Selling Agreement',
            description:
                'By accepting selling agreement go for the further process.',
            time: '5 hours ago',
            isUnread: true,
            isHighlighted: true,
            hasDualActions: true, // Show Accept/Decline buttons
            onAccept: () {
              Get.to(() => const SellingAgreementScreen());
            },
          ),

          // 4. CMA Report
          _buildNotificationCard(
            icon: Icons.notifications_outlined,
            title: 'CMA Report',
            description:
                'Your CMA report is ready. Your agent has completed the valuation of your Property',
            time: '5 hours ago',
            isUnread: true,
            isHighlighted: true,
            customAction: _buildFullWidthButton(
              label: 'Open CMA',
              icon: Icons.remove_red_eye_outlined,
              onPressed: () {
                Get.to(CMABrokerageRelationshipScreen());
              },
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
    bool hasDualActions = false,
    bool isHighlighted = false,
    Widget? customAction, // For single full-width buttons
    VoidCallback? onAccept,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? secondaryColor : _cardBorder,
          width: isHighlighted ? 1.5 : 1.0,
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
                  icon,
                  color: secondaryText,
                  size: 20,
                ), // Grey icon as per image
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
                            title,
                            style: GoogleFonts.lora(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryText,
                            ),
                          ),
                        ),
                        if (isUnread)
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
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: secondaryText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
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
          if (customAction != null) ...[
            const SizedBox(height: 16),
            customAction,
          ],

          // Dual Actions (Accept/Decline)
          if (hasDualActions) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept ?? () {},
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
                        const Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ), // Signature icon
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
                    onPressed: () {},
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
