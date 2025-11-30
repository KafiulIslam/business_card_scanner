import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/card_info_tile.dart';

class CardTemplate extends StatelessWidget {
  final NetworkModel network;
  final VoidCallback onTap;

  const CardTemplate({super.key, required this.network, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                  CardInfoTile(icon: Icons.phone, info: network.phone ?? ""),
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
    );
  }
}
