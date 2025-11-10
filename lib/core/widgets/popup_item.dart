import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomPopupItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const CustomPopupItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icon, size: 18,), const Gap(8), Text(title)],
    );
  }
}
