import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../Buyers/bottom_nav_bar/screen/bottom_nav_bar.dart';
import '../../Agent/bottom_nav_bar/screen/Agent_bottom_nav_bar.dart';
import '../../Sellers/bottom_nav_bar/screen/Seller_bottom_nav_bar.dart';
import '../../welcome/view/onBoarding.dart';

class SplashScreenController extends GetxController {
  void checkIsLogin() async {
    Timer(const Duration(seconds: 3), () async {
      print('🔍 Checking login status...');

      // Check if the token exists in shared preferences
      String? token = await SharedPreferencesHelper.getAccessToken();
      print(
        '🔑 Token: ${token != null && token.isNotEmpty ? "${token.substring(0, 20)}..." : "No token found"}',
      );

      // If token exists, the user is logged in
      if (token != null && token.isNotEmpty) {
        // Get the user role
        String? role = await SharedPreferencesHelper.getSelectedRole();
        print('👤 Saved Role from SharedPreferences: $role');

        // Navigate based on role
        if (role == 'Buyer' || role == null) {
          print('🏠 Navigating to Buyer Home Screen');
          Get.offAll(() => BottomNavbar());
        } else if (role == 'Seller') {
          print('🏠 Navigating to Seller Home Screen');
          Get.offAll(() => SellerBottomNavbar());
        } else if (role == 'Agent') {
          print('🏠 Navigating to Agent Home Screen');
          Get.offAll(() => AgentBottomNavbar());
        } else {
          // Default to buyer if role is unknown
          print('⚠️ Unknown role: $role, defaulting to Buyer Home Screen');
          Get.offAll(() => BottomNavbar());
        }
      } else {
        // Redirect to the Welcome Screen if no token is found
        print('🚪 No token found, navigating to OnBoarding');
        Get.offAll(() => OnBoarding());
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    checkIsLogin();
  }
}
