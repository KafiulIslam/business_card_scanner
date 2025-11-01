import 'package:business_card_scanner/core/theme/app_assets.dart';
import 'package:flutter/material.dart';

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset(AppAssets.logo),
    ],);
  }
}
