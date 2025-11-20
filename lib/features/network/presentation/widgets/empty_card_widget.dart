import 'package:business_card_scanner/core/theme/app_assets.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetsPath.empty,
            width: 200.w,
          ),
          Gap(AppDimensions.spacing16),
          Text('You\'re almost there..',
              style: AppTextStyles.headline3
                  .copyWith(fontSize: 18.sp, color: Colors.black)),
          Gap(AppDimensions.spacing8),
          Text('Scan a business card to save details and grow your network.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontSize: 14.sp, color: Colors.black)),
        ],
      ),
    );
  }
}
