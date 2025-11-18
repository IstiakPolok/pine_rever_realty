import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final SplashScreenController controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    //var screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          // Background image (fills the whole screen)
          Positioned.fill(
            child: Image.asset(
              'assets/image/splashBG.png', // replace with your background image path
              fit: BoxFit.fill,
            ),
          ),

          // Centered image
          Positioned(
            bottom: 200.h, // Distance from the bottom of the screen
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 40.w,
                height: 40.h,
                child: CircularProgressIndicator(
                  color: primaryColor, // 50% opacity
                  strokeWidth: 4.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
