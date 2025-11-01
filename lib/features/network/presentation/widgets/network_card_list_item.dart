import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/widgets/custom_image_holder.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NetworkCardListItem extends StatelessWidget {
  final NetworkCard card;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const NetworkCardListItem({
    super.key,
    required this.card,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    // Parse categories from comma-separated string or use single category
    final categories = card.category
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (categories.isEmpty && card.category.isNotEmpty) {
      categories.add(card.category);
    }

    // Format date
    String dateText = '';
    if (card.createdAt != null) {
      final date = card.createdAt!;
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      dateText = '${date.day} ${months[date.month - 1]}, ${date.year}';
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                offset: const Offset(0.2, 0.4),
                blurRadius: 30.0,
                spreadRadius: 0.0,
              ),
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Business Card Thumbnail
            CustomImageHolder(
                //imageUrl: card.imageUrl,
                isCircle: false,
                imageUrl:
                    'https://asset.gecdesigns.com/img/visiting-card-templates/bold-and-creative-business-card-template-for-entrepreneurs-1680966036989-cover.webp',
                height: 90.h,
                width: 90.w,
                errorWidget: const Icon(
                  Icons.contact_mail_sharp,
                  color: AppColors.iconColor,
                )),
            Gap(AppDimensions.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Category Tag (General)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card.name,
                          style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: AppColors.primary,
                        size: 18.w,
                      )
                    ],
                  ),
                  const Gap(2),
                  // Title
                  if (card.title.isNotEmpty)
                    Text(
                      card.title,
                      style: AppTextStyles.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Gap(2),
                  //Company
                  if (card.company.isNotEmpty)
                    Text(
                      card.company,
                      style: AppTextStyles.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const Gap(2),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 14.w,
                        color: AppColors.gray600,
                      ),
                      Gap(AppDimensions.spacing4),
                      Text(
                        'dateText',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gray600,
                          fontSize: 12.sp,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: EdgeInsets.only(left: AppDimensions.spacing8),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing8,
                          vertical: AppDimensions.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radius8),
                        ),
                        child: Text(
                          categories.first,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 11.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
