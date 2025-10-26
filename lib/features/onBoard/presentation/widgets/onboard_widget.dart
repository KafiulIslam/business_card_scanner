import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';

class OnboardWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OnboardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Graphic Area
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              border: Border.all(
                  color: AppColors.primaryLight.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: 100.w,
                color: AppColors.primary,
              ),
            ),
          ),
          Gap(AppDimensions.spacing32),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline2,
          ),
          Gap(AppDimensions.spacing16),
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
