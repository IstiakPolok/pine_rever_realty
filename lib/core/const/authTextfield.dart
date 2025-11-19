import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';

/// Reusable auth text field used across auth screens.
///
/// - Uses ScreenUtil for responsive sizes.
/// - Default style matches current outline and focused border used in login screen.
class AuthTextField extends StatefulWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Show an eye icon to toggle obscureText. Only used when [obscureText] is true.
  final bool enableVisibilityToggle;
  final ValueChanged<String>? onChanged;
  final double borderRadius;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;

  const AuthTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.borderRadius = 12.0,
    this.fillColor = Colors.transparent,
    this.enabledBorderColor = Colors.grey,
    this.focusedBorderColor = secondaryColor,
    this.enableVisibilityToggle = false,
  });
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0.h),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscure,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: GoogleFonts.lora(color: Colors.grey[400], fontSize: 14.sp),
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.enableVisibilityToggle && widget.obscureText
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.suffixIcon != null) widget.suffixIcon!,
                    IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        size: 20.sp,
                      ),
                      color: secondaryColor,
                    ),
                  ],
                )
              : widget.suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: widget.enabledBorderColor!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            borderSide: BorderSide(
              color: widget.focusedBorderColor!,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
