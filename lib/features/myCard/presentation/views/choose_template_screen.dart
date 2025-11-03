import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../widgets/card_template.dart';

class ChooseTemplateScreen extends StatelessWidget {
  const ChooseTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Template'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
            itemBuilder: (_, index) => const CardTemplate(),
            separatorBuilder: (_, index) => Gap(AppDimensions.spacing12),
            itemCount: 5),
      ),
    );
  }
}
