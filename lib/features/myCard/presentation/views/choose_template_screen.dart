import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/utils/assets_path.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../widgets/card_template.dart';

class ChooseTemplateScreen extends StatelessWidget {
  const ChooseTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> templateList = [
      AssetsPath.manualCardBg,
      AssetsPath.temp2,
      AssetsPath.temp7,
      AssetsPath.temp3,
      AssetsPath.temp4,
      AssetsPath.temp5,
      AssetsPath.temp6,
      AssetsPath.temp8,
      AssetsPath.temp9,
      AssetsPath.temp10,
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Template'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
            itemBuilder: (_, index) {
              final String image = templateList[index];
              return CardTemplate(
                network: NetworkModel(
                    imageUrl: image,
                    name: 'John Doe',
                    title: 'CEO & Founder',
                    company: 'Cardigo',
                    phone: '+123456789',
                    address: 'Bogura, Rajshahi, Bangladesh',
                    email: 'cardigo@gmail.com',
                    website: 'cardigo.com'),
              );
            },
            separatorBuilder: (_, index) => Gap(AppDimensions.spacing12),
            itemCount: templateList.length),
      ),
    );
  }
}
