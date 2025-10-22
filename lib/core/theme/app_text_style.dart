import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headlines
  static TextStyle get headline1 => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    height: 1.2,
  );

  static TextStyle get headline2 => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    height: 1.2,
  );

  static TextStyle get headline3 => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.3,
  );

  static TextStyle get headline4 => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.3,
  );

  // Body Text
  static TextStyle get bodyLarge => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.gray800,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.gray700,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.gray600,
    height: 1.4,
  );

  // Labels
  static TextStyle get labelLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.gray800,
    height: 1.4,
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.gray700,
    height: 1.4,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.gray600,
    height: 1.3,
  );

  // Buttons
  static TextStyle get buttonLarge => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle get buttonMedium => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.2,
  );

  // Captions
  static TextStyle get caption => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.gray500,
    height: 1.3,
  );

  static TextStyle get overline => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.gray500,
    height: 1.2,
    letterSpacing: 1.5,
  );
}