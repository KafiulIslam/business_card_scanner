import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
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
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
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
          children: [
            // Business Card Thumbnail
            Container(
              width: 80.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(AppDimensions.radius12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: card.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius12),
                      child: Image.network(
                        card.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildCardPlaceholder(),
                      ),
                    )
                  : _buildCardPlaceholder(),
            ),
            Gap(AppDimensions.spacing12),

            // Card Information
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
                          style: AppTextStyles.headline4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (categories.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(left: AppDimensions.spacing8),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radius8),
                          ),
                          child: Text(
                            categories.first,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.secondary,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spacing4),
                  // Title
                  if (card.title.isNotEmpty)
                    Text(
                      card.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: AppDimensions.spacing8),
                  // Category Tags (Clients, Prospects, etc.)
                  if (categories.length > 1)
                    Wrap(
                      spacing: AppDimensions.spacing8,
                      runSpacing: AppDimensions.spacing4,
                      children: categories.skip(1).take(2).map((category) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing8,
                            vertical: AppDimensions.spacing4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radius8),
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.secondary,
                              fontSize: 11.sp,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: AppDimensions.spacing8),
                  // Date with Calendar Icon
                  if (dateText.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14.w,
                          color: AppColors.gray600,
                        ),
                        SizedBox(width: AppDimensions.spacing4),
                        Text(
                          dateText,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gray600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Gap(AppDimensions.spacing12),
            // More Options Icon
            IconButton(
              onPressed: onMoreTap,
              icon: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Center(
        child: Icon(
          Icons.business_center_outlined,
          color: AppColors.gray400,
          size: 32.w,
        ),
      ),
    );
  }
}
