import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../core/const/app_colors.dart';
import '../../../Sellers/Sellersetting/Profile/Screens/ProfileScreen.dart';
import '../../../chat/screen/ChatListScreen.dart';
import '../../Home/Screen/AgentHomeScreen.dart';
import '../../CreateListing/screens/AgentCreateListingScreen.dart';

// Placeholder for BottomNavbarController if not defined in your project
class AgentBottomNavbarController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class AgentBottomNavbar extends StatefulWidget {
  const AgentBottomNavbar({super.key});

  @override
  State<AgentBottomNavbar> createState() => _AgentBottomNavbarState();
}

class _AgentBottomNavbarState extends State<AgentBottomNavbar> {
  final AgentBottomNavbarController controller = Get.put(
    AgentBottomNavbarController(),
  );
  // Define the pages for each tab
  final List<Widget> pages = [
    AgentHomeScreen(),
    AgentCreateListingScreen(),
    ChatListScreen(),
    SellerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return pages[controller.currentIndex.value];
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            top: 16.h,
            bottom: 20.h,
          ),
          child: GNav(
            gap: 8.w,
            activeColor: primaryColor,
            iconSize: 24.sp,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.white,
            color: Colors.white,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.add, text: 'Add Property'),
              GButton(icon: Icons.message_outlined, text: 'Chat'),
              GButton(icon: Icons.settings_outlined, text: 'Settings'),
            ],
            selectedIndex: controller.currentIndex.value,
            onTabChange: (index) {
              controller.changeIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
