import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/custom_loader.dart';
import 'package:business_card_scanner/core/widgets/inputFields/empty_widget.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/image_to_text_cubit.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/image_to_text_state.dart';
import 'package:business_card_scanner/features/tools/presentation/widgets/image_to_text_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:business_card_scanner/core/routes/routes.dart';

class ImageToTextScreen extends StatefulWidget {
  const ImageToTextScreen({super.key});

  @override
  State<ImageToTextScreen> createState() => _ImageToTextScreenState();
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();
    _fetchImageToTextList();
  }

  void _fetchImageToTextList() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<ImageToTextCubit>().fetchImageToTextList(user.uid);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Close the FAB menu
      final state = _key.currentState;
      if (state != null && state.isOpen) {
        state.toggle();
      }

      final externalAppService = context.read<ExternalAppService>();
      final imageFile = await externalAppService.pickImage(source);

      if (imageFile != null && mounted) {
        // Navigate to ScanDocumentsScreen with the picked image
        await context.push(Routes.scanDocuments, extra: imageFile);
        // Refresh list when coming back
        // if (mounted) {
        //   _fetchImageToTextList();
        // }
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Error picking image: ${e.toString()}', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Scanner'),
        backgroundColor: AppColors.scaffoldBG,
      ),
      body: BlocBuilder<ImageToTextCubit, ImageToTextState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const CustomLoader();
          }

          if (state.error != null && state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.error}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  Gap(AppDimensions.spacing16),
                  ElevatedButton(
                    onPressed: _fetchImageToTextList,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.items.isEmpty) {
            return const EmptyWidget(
                icon: Icons.document_scanner_outlined,
                title: 'No scanned documents yet',
                subTitle: 'Tap the menu button to scan an image');
          }

          return RefreshIndicator(
            onRefresh: () async {
              _fetchImageToTextList();
            },
            color: AppColors.primary,
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing16),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.items.length,
                separatorBuilder: (context, index) =>
                    Gap(AppDimensions.spacing16),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ImageToTextListItem(
                    item: item,
                    onTap: () async {
                      await context.push(
                        Routes.imageToTextDetails,
                        extra: item,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.black.withOpacity(0.2),
          blur: 3,
        ),
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.camera_alt),
            onPressed: () {
              _pickImage(ImageSource.camera);
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.image),
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.file_present),
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
