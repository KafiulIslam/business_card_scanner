import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headlines

  static TextStyle get headline1 => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.2,
      ));

  static TextStyle get headline2 => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        height: 1.2,
      ));

  static TextStyle get headline3 => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.3,
      ));

  static TextStyle get headline4 => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.3,
      ));

  // Body Text
  static TextStyle get bodyLarge => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.gray800,
        height: 1.5,
      ));

  static TextStyle get bodyMedium => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.gray700,
        height: 1.5,
      ));

  static TextStyle get bodySmall => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.gray600,
        height: 1.4,
      ));

  // Labels
  static TextStyle get labelLarge => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.gray800,
        height: 1.4,
      ));

  static TextStyle get labelMedium => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.gray700,
        height: 1.4,
      ));

  static TextStyle get labelSmall => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.gray600,
        height: 1.3,
      ));

  // Buttons
  static TextStyle get buttonLarge => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      ));

  static TextStyle get buttonMedium => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      ));

  static TextStyle get buttonSmall => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        height: 1.2,
      ));

  // Captions
  static TextStyle get caption => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.gray500,
        height: 1.3,
      ));

  static TextStyle get overline => GoogleFonts.montserrat(
          textStyle: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.gray500,
        height: 1.2,
        letterSpacing: 1.5,
      ));

  // hinttext
  static TextStyle get hintText => GoogleFonts.montserrat(
      textStyle: TextStyle(
        fontSize: 14.sp,
        color: AppColors.iconColor,
        height: 1.2,
        letterSpacing: 1.5,
      ));
}
