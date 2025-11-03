import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/routes/routes.dart';

class MyCardScreen extends StatelessWidget {
  const MyCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
          child: _buildCreateCardWidget(context),
        ),
      ),
    );
  }

  Widget _buildCreateCardWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(Routes.chooseTemplate);
      },
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCardIcon(),
            Gap( AppDimensions.spacing16),
            Text(
              'Tap Here to Create Your Digital Business Card',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardIcon() {
    return SizedBox(
      width: 140.w,
      height: 100.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card outline - positioned to allow plus sign overlap
          Positioned(
            left: 10.w,
            top: 10.h,
            child: Container(
              width: 120.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 30.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Blue plus sign overlay overlapping bottom-left corner of card
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 32.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
