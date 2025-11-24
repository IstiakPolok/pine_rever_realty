import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pine_rever_realty/feature/Sellers/home/screens/SallerHomeScreen.dart';

import '../../../../core/const/app_colors.dart';
import '../../../chat/screen/ChatListScreen.dart';
import '../../AddSellingRequest/screens/AddSellingRequestScreen.dart';
import '../../Sellersetting/Profile/Screens/ProfileScreen.dart';

// Placeholder for BottomNavbarController if not defined in your project
class SellerBottomNavbarController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class SellerBottomNavbar extends StatefulWidget {
  const SellerBottomNavbar({super.key});

  @override
  State<SellerBottomNavbar> createState() => _SellerBottomNavbarState();
}

class _SellerBottomNavbarState extends State<SellerBottomNavbar> {
  final SellerBottomNavbarController controller = Get.put(
    SellerBottomNavbarController(),
  );
  // Define the pages for each tab
  final List<Widget> pages = [
    // Center(
    //   child: Text('Home Screen', style: TextStyle(fontSize: 24.sp)),
    // ),
    SallerHomeScreen(),
    AddSellingRequestScreen(),
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
              GButton(icon: Icons.add, text: 'Add Request'),
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
