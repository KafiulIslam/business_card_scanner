import 'dart:io';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/widgets/custom_loader.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/image_to_text_cubit.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/image_to_text_state.dart';
import 'package:business_card_scanner/features/tools/presentation/widgets/image_to_text_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final _imagePicker = ImagePicker();

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

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        final imageFile = File(pickedFile.path);
        // Navigate to ScanDocumentsScreen with the picked image
        await context.push(Routes.scanDocuments, extra: imageFile);
        // Refresh list when coming back
        if (mounted) {
          _fetchImageToTextList();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.document_scanner_outlined,
                    size: 64.w,
                    color: AppColors.gray400,
                  ),
                  Gap(AppDimensions.spacing16),
                  Text(
                    'No scanned documents yet',
                    style: AppTextStyles.headline4.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  Gap(AppDimensions.spacing8),
                  Text(
                    'Tap the + button to scan an image',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ),
            );
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
                    onTap: () => context.push(
                      Routes.imageToTextDetails,
                      extra: item,
                    ),
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

