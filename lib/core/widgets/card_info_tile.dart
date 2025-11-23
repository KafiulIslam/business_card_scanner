import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import '../theme/app_text_style.dart';

class CardInfoTile extends StatelessWidget {
  final IconData icon;
  final String info;

  const CardInfoTile({super.key, required this.icon, required this.info});

  @override
  Widget build(BuildContext context) {
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
        Expanded(
          child: Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }
}
