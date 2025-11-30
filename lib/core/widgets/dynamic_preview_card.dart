import 'dart:io';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import 'card_info_tile.dart';

class DynamicPreviewCard extends StatelessWidget {
  final ScreenshotController screenshotController;
  final NetworkModel network;
  final bool? isEditable;
  final File? imagePath;

  const DynamicPreviewCard(
      {super.key,
      required this.screenshotController,
      required this.network,
      this.isEditable = false,
      this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          height: 220.h,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage(network.imageUrl ?? ''),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: EdgeInsets.only(
                right: 16.w, left: 16.w, top: 16.h, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            network.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headline1
                                .copyWith(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            network.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headline3
                                .copyWith(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Column(
                        children: [
                          if (imagePath != null ||
                              (network.company?.isNotEmpty ?? false)) ...[
                            if (isEditable ?? true) ...[
                              if (imagePath == null) ...[
                                const Icon(
                                  Icons.domain,
                                  color: Colors.white,
                                  size: 36,
                                )
                              ] else ...[
                                SizedBox(
                                  height: 36.h,
                                  width: 36.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      imagePath!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              ]
                            ] else ...[
                              _buildCompanyLogoHolder(network.companyLogo ?? '')
                            ],
                          ],
                          Text(
                            network.company ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headline1
                                .copyWith(fontSize: 14, color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardInfoTile(icon: Icons.phone, info: network.phone ?? ''),
                    const Gap(2),
                    CardInfoTile(icon: Icons.email, info: network.email ?? ''),
                    const Gap(2),
                    CardInfoTile(
                        icon: Icons.language_outlined,
                        info: network.website ?? ''),
                    const Gap(2),
                    CardInfoTile(
                        icon: Icons.location_on_outlined,
                        info: network.address ?? ''),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLogoHolder(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => const Padding(
        padding: EdgeInsets.all(4.0),
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.domain,
        color: Colors.white,
        size: 36,
      ),
    );
  }
}
