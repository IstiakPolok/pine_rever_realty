import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../../core/const/app_colors.dart';
import '../../home/screens/HomeScreen .dart';

// Placeholder for BottomNavbarController if not defined in your project
class BottomNavbarController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final BottomNavbarController controller = Get.put(BottomNavbarController());

  // Define the pages for each tab
  final List<Widget> pages = [
    // Center(
    //   child: Text('Home Screen', style: TextStyle(fontSize: 24.sp)),
    // ),
    HomeScreen(),
    Center(
      child: Text('Likes Screen', style: TextStyle(fontSize: 24.sp)),
    ),
    Center(
      child: Text('Search Screen', style: TextStyle(fontSize: 24.sp)),
    ),
    Center(
      child: Text('Profile Screen', style: TextStyle(fontSize: 24.sp)),
    ),
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.white,
            color: Colors.white,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.favorite_border, text: 'Likes'),
              GButton(icon: Icons.search, text: 'Search'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
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
