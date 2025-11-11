import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/buttons/primary_button.dart';
import 'package:business_card_scanner/core/widgets/custom_image_holder.dart';
import 'package:business_card_scanner/features/tools/domain/entities/image_to_text_model.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/image_to_text_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/widgets/popup_item.dart';

class ImageToTextDetailsScreen extends StatefulWidget {
  final ImageToTextModel item;

  const ImageToTextDetailsScreen({
    super.key,
    required this.item,
  });

  @override
  State<ImageToTextDetailsScreen> createState() =>
      _ImageToTextDetailsScreenState();
}

class _ImageToTextDetailsScreenState extends State<ImageToTextDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  late String _initialTitle;
  late String _initialText;
  bool _hasChanges = false;
  bool _isSubmitting = false;
  bool _isDeleting = false;

  String get _title =>
      _currentTitle.isNotEmpty ? _currentTitle : 'Untitled Document';

  String get _currentTitle => _titleController.text.trim();

  String get _text => _textController.text;

  void _copyText(BuildContext context) {
    if (_text.trim().isEmpty) {
      CustomSnack.warning('No text to copy', context);
      return;
    }
    context.read<ExternalAppService>().copyToClipboard(_text);
    CustomSnack.success('Text copied to clipboard', context);
  }

  Future<void> _shareText(BuildContext context) async {
    if (_text.trim().isEmpty) {
      CustomSnack.warning('No text to share', context);
      return;
    }
    try {
      await context.read<ExternalAppService>().shareContent(_text);
    } catch (e) {
      CustomSnack.warning('Failed to share: $e', context);
    }
  }

  Future<void> _exportText(BuildContext context) async {
    final text = _text;
    if (text.trim().isEmpty) {
      CustomSnack.warning('No text to export', context);
      return;
    }

    try {
      final service = context.read<ExternalAppService>();
      await service.exportTextToFile(
        text,
        fileName: _currentTitle.isNotEmpty
            ? _currentTitle.replaceAll(' ', '_')
            : 'scanned_text',
      );
      CustomSnack.success('Text exported successfully', context);
    } catch (e) {
      CustomSnack.warning('Failed to export: $e', context);
    }
  }

  Future<void> _onUpdatePressed() async {
    if (_isSubmitting) return;

    final documentId = widget.item.documentId;
    if (documentId == null || documentId.isEmpty) {
      CustomSnack.warning('Document reference not found', context);
      return;
    }

    final currentTitle = _currentTitle;
    if (currentTitle.isEmpty) {
      CustomSnack.warning('Please enter a title', context);
      return;
    }

    final rawText = _textController.text;
    if (rawText.trim().isEmpty) {
      CustomSnack.warning('Please enter scanned text', context);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnack.warning('Please login to update', context);
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<ImageToTextCubit>().updateImageToText(
            documentId: documentId,
            title: currentTitle,
            scannedText: rawText,
            uid: user.uid,
          );
      if (!mounted) return;
      CustomSnack.success('Document updated successfully', context);
      setState(() {
        _isSubmitting = false;
        _initialTitle = currentTitle;
        _initialText = rawText;
        _hasChanges = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
      CustomSnack.warning('Failed to update: $e', context);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    if (_isDeleting) return;

    final documentId = widget.item.documentId;
    if (documentId == null || documentId.isEmpty) {
      CustomSnack.warning('Document reference not found', context);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnack.warning('Please login to delete', context);
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await context.read<ImageToTextCubit>().deleteImageToText(
            documentId: documentId,
            uid: user.uid,
          );
      if (!mounted) return;
      await context.read<ImageToTextCubit>().fetchImageToTextList(user.uid);
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
      });
      CustomSnack.success('Document deleted successfully', context);
      context.push(Routes.imageToText);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
      });
      CustomSnack.warning('Failed to delete: $e', context);
    }
  }

  @override
  void initState() {
    super.initState();
    _initialTitle = widget.item.title?.trim() ?? '';
    _initialText = widget.item.scannedText ?? '';
    _titleController = TextEditingController(text: _initialTitle);
    _textController = TextEditingController(text: _initialText);
    _titleController.addListener(_handleFieldChange);
    _textController.addListener(_handleFieldChange);
  }

  @override
  void dispose() {
    _titleController.removeListener(_handleFieldChange);
    _textController.removeListener(_handleFieldChange);
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _handleFieldChange() {
    final hasChanges = _titleController.text.trim() != _initialTitle ||
        _textController.text != _initialText;
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton(
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem(
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _copyText(context);
                    });
                  },
                  child: const CustomPopupItem(icon: Icons.copy, title: 'Copy'),
                ),
                PopupMenuItem(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _shareText(context);
                      });
                    },
                    child: const CustomPopupItem(
                        icon: Icons.share_outlined, title: 'Share')),
                PopupMenuItem(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _exportText(context);
                      });
                    },
                    child: const CustomPopupItem(
                        icon: Icons.download_outlined, title: 'Export')),
                PopupMenuItem(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _confirmDelete(context);
                      });
                    },
                    child: const CustomPopupItem(
                        icon: Icons.delete_forever_outlined, title: 'Delete')),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.item.imageUrl != null &&
                widget.item.imageUrl!.isNotEmpty)
              _buildImagePreview(),
            _buildTitleField(),
            Text(
              'Scanned Text',
              style: AppTextStyles.headline4,
            ),
            Gap(AppDimensions.spacing12),
            TextField(
              controller: _textController,
              maxLines: null,
              minLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: EdgeInsets.all(AppDimensions.spacing16),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray900,
              ),
            ),
            Gap(AppDimensions.spacing16),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        CustomImageHolder(
          imageUrl: widget.item.imageUrl ?? '',
          height: 250.h,
          width: double.infinity,
          isCircle: false,
          fitType: BoxFit.cover,
          errorWidget: const Icon(
            Icons.document_scanner_outlined,
            size: 48,
            color: AppColors.iconColor,
          ),
        ),
        Gap(AppDimensions.spacing16),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: AppTextStyles.headline4,
        ),
        Gap(AppDimensions.spacing12),
        TextField(
          controller: _titleController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Enter document title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radius12),
              borderSide: const BorderSide(
                color: AppColors.primary,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: AppDimensions.spacing12,
            ),
          ),
        ),
        Gap(AppDimensions.spacing16),
      ],
    );
  }

  Widget _buildUpdateButton() {
    final hasDocumentId =
        widget.item.documentId != null && widget.item.documentId!.isNotEmpty;
    final isEnabled = hasDocumentId && _hasChanges && !_isSubmitting;

    return IgnorePointer(
      ignoring: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: PrimaryButton(
          onTap: _onUpdatePressed,
          buttonTitle: 'Update',
          isLoading: _isSubmitting,
        ),
      ),
    );
  }
}
