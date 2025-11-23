import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import '../theme/app_text_style.dart';
import 'card_info_tile.dart';

class DynamicPreviewCard extends StatelessWidget {
  final ScreenshotController screenshotController;
  final NetworkModel network;

  const DynamicPreviewCard(
      {super.key, required this.screenshotController, required this.network});

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
                right: 24.w, left: 16.w, top: 16.h, bottom: 16.h),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.headline3
                                .copyWith(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        if (network.company?.isNotEmpty ?? false) ...[
                          const Icon(
                            Icons.domain,
                            color: Colors.white,
                            size: 42,
                          ),
                        ],
                        Text(
                          network.company ?? '',
                          style: AppTextStyles.headline1
                              .copyWith(fontSize: 14, color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardInfoTile(icon: Icons.phone, info: network.phone ?? ''),
                    const Gap(2),
                    CardInfoTile(
                        icon: Icons.location_on_outlined,
                        info: network.address ?? ''),
                    const Gap(2),
                    CardInfoTile(icon: Icons.email, info: network.email ?? ''),
                    const Gap(2),
                    CardInfoTile(
                        icon: Icons.language_outlined,
                        info: network.website ?? ''),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
