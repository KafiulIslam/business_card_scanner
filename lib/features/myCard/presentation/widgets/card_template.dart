import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/utils/assets_path.dart';

class CardTemplate extends StatelessWidget {
  final NetworkModel network;

  const CardTemplate({super.key, required this.network});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(network.imageUrl ?? ''), fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      network.name ?? '',
                      style: AppTextStyles.headline1
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      network.title ?? '',
                      style: AppTextStyles.headline3
                          .copyWith(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    const Icon(
                      Icons.domain,
                      color: Colors.white,
                      size: 42,
                    ),
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
                _cardInfoTile(Icons.phone, network.phone ?? ""),
                const Gap(2),
                _cardInfoTile(
                    Icons.location_on_outlined, network.address ?? ''),
                const Gap(2),
                _cardInfoTile(Icons.email, network.email ?? ''),
                const Gap(2),
                _cardInfoTile(Icons.language_outlined, network.website ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardInfoTile(IconData icon, String info) {
    return Row(
      children: [
        if (info.isNotEmpty) ...[
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ],
        const Gap(8),
        Text(
          info,
          style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
        )
      ],
    );
  }
}
