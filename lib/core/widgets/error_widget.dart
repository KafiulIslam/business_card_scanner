import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_style.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;

  const CustomErrorWidget(
      {super.key, required this.errorTitle, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.w,
            color: AppColors.error,
          ),
          Gap(AppDimensions.spacing16),
          Text(
            errorTitle,
            style: AppTextStyles.headline4,
          ),
          Gap(AppDimensions.spacing8),
          Text(
            errorMessage,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
