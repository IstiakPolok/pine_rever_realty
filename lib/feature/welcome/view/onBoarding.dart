import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slide_to_act/slide_to_act.dart';

import '../../../core/const/app_colors.dart';
import '../../auth/roleSelect/screens/roleSelectScreen.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SlideActionState> key = GlobalKey();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/image/splashBG.png', fit: BoxFit.fill),
          ),

          // SlideAction with bouncy entry using TweenAnimationBuilder
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.elasticOut, // Bouncy effect
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 30.h,
                  ),
                  child: SlideAction(
                    key: key,
                    onSubmit: () {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Action Confirmed!')),
                      // );
                      key.currentState!.reset();
                      Get.offAll(() => const roleSelect());
                      return null;
                    },
                    height: 60.h,
                    borderRadius: 40.r,
                    elevation: 0,
                    innerColor: secondaryColor,
                    outerColor: secondaryColor.withOpacity(0.3),
                    sliderButtonIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 80.w),
                        Text(
                          'Self Love',
                          style: GoogleFonts.philosopher(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: secondaryColor,
                          ),
                        ),
                        SizedBox(width: 60.w),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: secondaryColor.withOpacity(0.2),
                          size: 30.sp,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: secondaryColor.withOpacity(0.5),
                          size: 32.sp,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: secondaryColor,
                          size: 35.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
