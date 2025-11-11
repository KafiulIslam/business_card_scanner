import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_text_style.dart';

class EmptyWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;

  const EmptyWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.w,
            color: AppColors.gray400,
          ),
          Gap(AppDimensions.spacing16),
          Text(
            title,
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.gray600,
            ),
          ),
          Gap(AppDimensions.spacing8),
          Text(
            subTitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
