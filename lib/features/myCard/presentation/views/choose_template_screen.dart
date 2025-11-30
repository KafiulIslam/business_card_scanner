import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/assets_path.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/network_source_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/my_card_model.dart';
import '../widgets/card_template.dart';

class ChooseTemplateScreen extends StatefulWidget {
  final bool isEditing;
  final MyCardModel card;

  const ChooseTemplateScreen(
      {super.key, required this.isEditing, required this.card});

  @override
  State<ChooseTemplateScreen> createState() => _ChooseTemplateScreenState();
}

class _ChooseTemplateScreenState extends State<ChooseTemplateScreen> {
  @override
  void initState() {
    super.initState();
    // Show dialog if editing
    if (widget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showChangeDesignDialog();
      });
    }
  }

  Future<void> _showChangeDesignDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Change Design?',
            style: AppTextStyles.headline4.copyWith(
              color: AppColors.gray900,
            ),
          ),
          content: Text(
            'Would you like to change the design?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.gray700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to EditMyCardScreen with card

                context.push(
                  Routes.editMyCard,
                  extra: {
                    'imageUrl': widget.card.imageUrl,
                    'card': widget.card
                  },
                );
              },
              child: Text(
                'Skip',
                style:
                    AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
                    website: 'cardigo.com',
                    sourceType: NetworkSourceType.manual),
                onTap: () {
                  if (widget.isEditing) {
                    context.push(
                      Routes.editMyCard,
                      extra: {'imageUrl': image, 'card': widget.card},
                    );
                  } else {
                    context.push(
                      Routes.editTemplate,
                      extra: image,
                    );
                  }
                },
              );
            },
            separatorBuilder: (_, index) => Gap(AppDimensions.spacing12),
            itemCount: templateList.length),
      ),
    );
  }
}
