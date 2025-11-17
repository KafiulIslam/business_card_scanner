import 'package:business_card_scanner/core/routes/app_router.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/features/menu/presentation/widgets/menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/routes.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight.withOpacity(0.2),
                    border: Border.all(color: AppColors.primary)),
              ),
              const Gap(8),
              Text(
                'Email',
                style: AppTextStyles.headline3
                    .copyWith(fontSize: 16, color: Colors.black),
              ),
              Gap(AppDimensions.spacing32),
              // privacy
              MenuTile(
                  onTap: () => context.push(Routes.privacyPolicy),
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy'),
              Gap(AppDimensions.spacing16),
              // Terms
              const MenuTile(icon: Icons.rule, title: 'Terms of Services'),
              Gap(AppDimensions.spacing16),
              // Share us
              const MenuTile(icon: Icons.share_outlined, title: 'Share Us'),
              Gap(AppDimensions.spacing16),
              // Rate us
              const MenuTile(icon: Icons.star, title: 'Rate Us'),
              Gap(AppDimensions.spacing16),
              // Logout
              const MenuTile(
                icon: Icons.logout_outlined,
                title: 'Logout',
                iconColor: Colors.red,
              ),
              Gap(AppDimensions.spacing16),
              // Delete
              const MenuTile(
                icon: Icons.delete_forever_outlined,
                title: 'Delete',
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
