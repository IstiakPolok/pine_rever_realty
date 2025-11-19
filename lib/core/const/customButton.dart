import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';

class Custombutton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final Color color;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;

  const Custombutton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 45.0,
    this.borderRadius = 30.0,
    this.color = secondaryColor,
    this.borderColor,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor ?? Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.0)
                : BorderSide.none,
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style:
              textStyle ??
              GoogleFonts.lora(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.white,
              ),
        ),
      ),
    );
  }
}
