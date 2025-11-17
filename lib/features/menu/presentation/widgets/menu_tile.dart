import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_style.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color iconColor;

  const MenuTile(
      {super.key,
      required this.icon,
      required this.title,
      this.onTap,
      this.iconColor = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
        padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing12,
            vertical: AppDimensions.spacing12),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            Gap(AppDimensions.spacing16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.gray800,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.gray700,
              size: AppDimensions.icon24,
            ),
          ],
        ),
      ),
    );
  }
}
