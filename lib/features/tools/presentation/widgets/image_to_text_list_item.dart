import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/widgets/custom_image_holder.dart';
import 'package:business_card_scanner/features/tools/domain/entities/image_to_text_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ImageToTextListItem extends StatelessWidget {
  final ImageToTextModel item;
  final VoidCallback? onTap;

  const ImageToTextListItem({
    super.key,
    required this.item,
    this.onTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
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
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String _getPreviewText(String? text) {
    if (text == null || text.isEmpty) return 'No text';
    if (text.length > 100) {
      return '${text.substring(0, 100)}...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.spacing12),
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
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Thumbnail
            CustomImageHolder(
              imageUrl: item.imageUrl ?? '',
              isCircle: false,
              height: 90.h,
              width: 100.w,
              errorWidget: const Icon(
                Icons.document_scanner_outlined,
                color: AppColors.iconColor,
              ),
              fitType: BoxFit.cover,
            ),
            Gap(AppDimensions.spacing8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Preview Text
                  Text(
                    _getPreviewText(item.scannedText),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(AppDimensions.spacing8),
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 14.w,
                        color: AppColors.gray600,
                      ),
                      Gap(AppDimensions.spacing4),
                      Text(
                        _formatDate(item.createdAt),
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
          ],
        ),
      ),
    );
  }
}

