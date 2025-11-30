import 'dart:io';
import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/popup_item.dart';
import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/myCard/presentation/cubit/my_card_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/network_source_type.dart';
import '../../../../core/widgets/dynamic_preview_card.dart';
import '../../../network/domain/entities/network_model.dart';

class MyCardListItem extends StatefulWidget {
  final MyCardModel card;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const MyCardListItem({
    super.key,
    required this.card,
    this.onTap,
    this.onMoreTap,
  });

  @override
  State<MyCardListItem> createState() => _MyCardListItemState();
}

class _MyCardListItemState extends State<MyCardListItem> {
  // Screenshot controller for capturing the card preview widget
  final ScreenshotController _screenshotController = ScreenshotController();

  /// Captures the card preview widget as an image file and shares it
  Future<void> _shareCardScreenshot() async {
    try {
      // Wait for widget to be fully rendered before capturing
      await Future.delayed(const Duration(milliseconds: 100));
      await WidgetsBinding.instance.endOfFrame;

      // Capture the card preview widget as an image
      final imageBytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 200),
        pixelRatio: 2.0,
      );

      if (imageBytes == null || imageBytes.isEmpty) {
        if (mounted) {
          CustomSnack.warning(
              'Failed to capture card image. Please try again.', context);
        }
        return;
      }

      // Create temporary file
      final tempDir = Directory.systemTemp;
      if (!await tempDir.exists()) {
        await tempDir.create(recursive: true);
      }

      final imageFile = File(
        '${tempDir.path}/my_card_${widget.card.name ?? 'card'}_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await imageFile.writeAsBytes(imageBytes);

      // Verify file was created and has content
      if (!await imageFile.exists() || await imageFile.length() == 0) {
        if (mounted) {
          CustomSnack.warning(
              'Failed to create image file. Please try again.', context);
        }
        return;
      }

      // Share the image file
      final xFile = XFile(imageFile.path);
      await Share.shareXFiles(
        [xFile],
        text: widget.card.name != null
            ? '${widget.card.name}\'s Business Card'
            : 'Business Card',
      );

      // Clean up temporary file after a delay
      Future.delayed(const Duration(seconds: 5), () async {
        try {
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        } catch (_) {
          // Ignore cleanup errors
        }
      });
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to share card: ${e.toString()}', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.h,
      width: double.infinity,
      child: Stack(
        children: [
          DynamicPreviewCard(
              screenshotController: _screenshotController,
              network: NetworkModel(
                  imageUrl: widget.card.imageUrl,
                  name: widget.card.name,
                  title: widget.card.title,
                  company: widget.card.company,
                  companyLogo: widget.card.logoUrl,
                  phone: widget.card.phone,
                  address: widget.card.address,
                  email: widget.card.email,
                  website: widget.card.website,
                  sourceType: NetworkSourceType.manual)),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 12.0),
              child: PopupMenuButton(
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 24,
                ),
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  PopupMenuItem(
                      onTap: () => Future.microtask(() {
                        context.push(Routes.editMyCard,
                            extra: widget.card);
                      }),
                      child: const CustomPopupItem(
                          icon: Icons.edit_note_outlined, title: 'Edit')),
                  PopupMenuItem(
                      onTap: () {
                        Future.microtask(() {
                          _shareCardScreenshot();
                        });
                      },
                      child: const CustomPopupItem(
                          icon: Icons.share, title: 'Share')),
                  PopupMenuItem(
                    onTap: () {
                      Future.microtask(() {
                        _showDeleteConfirmationDialog(context);
                      });
                    },
                    child: const CustomPopupItem(
                        icon: Icons.delete_forever_outlined,
                        title: 'Delete'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Card'),
          content: const Text(
              'Are you sure you want to delete this card? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (widget.card.cardId != null &&
                    widget.card.cardId!.isNotEmpty) {
                  context.read<MyCardCubit>().deleteMyCard(widget.card.cardId!);
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
