import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:pine_rever_realty/feature/Buyers/setting/DeleteAccount/screens/DeleteAccountScreen.dart';
import 'package:pine_rever_realty/feature/Buyers/setting/PrivacySecurity/screen/PrivacySecurityScreen.dart';
import 'package:pine_rever_realty/feature/Buyers/setting/TermsConditions/Screen/TermsConditionsScreen.dart';
import 'package:pine_rever_realty/core/services_class/auth_service.dart';
import 'package:pine_rever_realty/core/services_class/profile_service.dart';
import 'AgentProfileScreen.dart';
import 'AgreementListScreen.dart';
import 'ChangePasswordScreen.dart';
import 'PropertyListScreen.dart';
import 'ScheduleListScreen.dart';
import 'package:pine_rever_realty/feature/auth/login/model/login_response_model.dart';

class AgentSettingsScreen extends StatefulWidget {
  const AgentSettingsScreen({super.key});

  @override
  State<AgentSettingsScreen> createState() => _AgentSettingsScreenState();
}

class _AgentSettingsScreenState extends State<AgentSettingsScreen> {
  UserModel? _user;
  String _name = '...';
  String? _profileUrl;
  String _memberSince = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final user = await ProfileService.fetchAgentProfile();
    if (user != null) {
      setState(() {
        _user = user;
        _name = user.fullName.isNotEmpty ? user.fullName : user.username;
        _profileUrl = user.profilePicture;
        try {
          final created = DateTime.parse(user.createdAt);
          _memberSince =
              'Member since ${_monthName(created.month)} ${created.year}';
        } catch (_) {
          _memberSince = '';
        }
      });
    }
    setState(() => _isLoading = false);
  }

  String _monthName(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Settings',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  _isLoading
                      ? SizedBox(
                          width: 60.r,
                          height: 60.r,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : CircleAvatar(
                          radius: 30.r,
                          backgroundColor: primaryColor.withOpacity(0.1),
                          backgroundImage: _profileUrl != null
                              ? NetworkImage(_profileUrl!) as ImageProvider
                              : null,
                          child: _profileUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 35.sp,
                                  color: primaryColor,
                                )
                              : null,
                        ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoading ? 'Loading...' : _name,
                          style: GoogleFonts.lora(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryText,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _isLoading ? '' : _memberSince,
                          style: GoogleFonts.lora(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  AgentProfileScreen(user: _user),
                            ),
                          )
                          .then((v) {
                            if (v == true) _loadProfile();
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'View',
                      style: GoogleFonts.lora(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Settings Section
            Text(
              'Settings',
              style: GoogleFonts.lora(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            SizedBox(height: 16.h),

            // Settings Menu Items
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Schedule List',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ScheduleListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.note_alt_outlined,
                    title: 'Agreements List',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AgreementListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.apartment_outlined,
                    title: 'Property List',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PropertyListScreen(),
                        ),
                      );
                    },
                  ),

                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),

                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    onTap: () {
                      Get.to(() => const PrivacySecurityScreen());
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      Get.to(TermsConditionsScreen());
                    },
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.delete_outline,
                    title: 'Delete Profile',
                    onTap: () {
                      Get.to(DeleteAccountScreen());
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  _showLogoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8.w),
                    Text(
                      'Logout',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // The title matches the serif style
          title: Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          // The content matches the lighter sans-serif text
          content: Text(
            'You can log back in anytime',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          actions: [
            Row(
              children: [
                // Cancel Button (Outlined with dark/grey text)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                        color: Color(0xFF4A5568),
                      ), // Dark grey/blueish border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.lora(
                        color: const Color(0xFF4A5568), // Matching text color
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Logout Button (Solid Red)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Use AuthService to handle logout
                      await AuthService.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0000), // Bright Red
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Logout',
                      style: GoogleFonts.lora(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : primaryColor,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.lora(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? Colors.red : primaryText,
                ),
              ),
            ),
            if (!isDestructive)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(height: 1.h, color: Colors.grey[200]),
    );
  }
}
