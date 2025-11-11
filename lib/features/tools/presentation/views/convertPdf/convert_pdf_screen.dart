import 'dart:io';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/buttons/primary_button.dart';
import 'package:business_card_scanner/core/widgets/custom_loader.dart';
import 'package:business_card_scanner/core/widgets/inputFields/empty_widget.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/convert_pdf_cubit.dart';
import 'package:business_card_scanner/features/tools/presentation/cubit/convert_pdf_state.dart';
import 'package:business_card_scanner/features/tools/presentation/widgets/pdf_document_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

class ConvertPdfScreen extends StatefulWidget {
  const ConvertPdfScreen({super.key});

  @override
  State<ConvertPdfScreen> createState() => _ConvertPdfScreenState();
}

class _ConvertPdfScreenState extends State<ConvertPdfScreen> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();
    _fetchPdfDocuments();
  }

  void _fetchPdfDocuments() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<ConvertPdfCubit>().fetchPdfDocuments(user.uid);
    }
  }

  Future<void> _handleImageSource(ImageSource source) async {
    _closeFabIfOpen();
    try {
      final externalAppService = context.read<ExternalAppService>();
      final imageFile = await externalAppService.pickImage(source);
      if (imageFile == null || !mounted) return;

      final pdfFile = await _createPdfFromImage(imageFile);
      await _showSaveBottomSheet(pdfFile,
          suggestedTitle: p.basenameWithoutExtension(imageFile.path));
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to process image: $e', context);
    }
  }

  Future<void> _handleFileSelection() async {
    _closeFabIfOpen();
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result == null || result.files.single.path == null) {
        return;
      }
      final pickedPath = result.files.single.path!;
      final extension = result.files.single.extension?.toLowerCase() ?? '';

      File pdfFile;
      if (_isSupportedImageExtension(extension)) {
        pdfFile = await _createPdfFromImage(File(pickedPath));
      } else if (extension == 'pdf') {
        pdfFile = await _copyToTemp(File(pickedPath));
      } else {
        if (!mounted) return;
        CustomSnack.warning(
            'Unsupported file type. Please select an image or PDF file.',
            context);
        return;
      }

      if (!mounted) return;
      await _showSaveBottomSheet(pdfFile,
          suggestedTitle: result.files.single.name.replaceAll('.pdf', ''));
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to pick file: $e', context);
    }
  }

  bool _isSupportedImageExtension(String extension) {
    const supported = ['jpg', 'jpeg', 'png', 'heic', 'webp'];
    return supported.contains(extension);
  }

  Future<File> _createPdfFromImage(File imageFile) async {
    final pdf = pw.Document();
    final imageBytes = await imageFile.readAsBytes();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(child: pw.Image(image)),
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final filePath = p.join(
        tempDir.path, 'pdf_${DateTime
        .now()
        .millisecondsSinceEpoch}.pdf');
    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(await pdf.save());
    return pdfFile;
  }

  Future<File> _copyToTemp(File file) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = p.join(
        tempDir.path, 'pdf_${DateTime
        .now()
        .millisecondsSinceEpoch}.pdf');
    final pdfFile = await file.copy(filePath);
    return pdfFile;
  }

  void _closeFabIfOpen() {
    final state = _key.currentState;
    if (state != null && state.isOpen) {
      state.toggle();
    }
  }

  Future<void> _showSaveBottomSheet(File pdfFile,
      {String? suggestedTitle}) async {
    final controller =
    TextEditingController(text: suggestedTitle ?? 'PDF Document');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
            MediaQuery
                .of(ctx)
                .viewInsets
                .bottom + AppDimensions.spacing24,
            left: AppDimensions.spacing20,
            right: AppDimensions.spacing20,
            top: AppDimensions.spacing24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Save PDF',
                style:
                AppTextStyles.headline3.copyWith(color: AppColors.gray900),
              ),
              Gap(AppDimensions.spacing16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
              Gap(AppDimensions.spacing16),
              PrimaryButton(onTap: () async {
                final title = controller.text.trim();
                if (title.isEmpty) {
                  CustomSnack.warning('Please enter a title', context);
                  return;
                }
                Navigator.of(ctx).pop();
                await _savePdf(pdfFile, title);
              }, buttonTitle: 'Save'),

            ],
          ),
        );
      },
    );
  }

  Future<void> _savePdf(File pdfFile, String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnack.warning('Please login to upload PDF', context);
      return;
    }

    final overlayNavigator = Navigator.of(context, rootNavigator: true);
    overlayNavigator.push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.2),
        pageBuilder: (_, __, ___) =>
        const Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      await context.read<ConvertPdfCubit>().uploadPdf(
        pdfFile: pdfFile,
        title: title,
        uid: user.uid,
      );
      if (!mounted) return;
      overlayNavigator.pop();
      CustomSnack.success('PDF saved successfully', context);
      _fetchPdfDocuments();
    } catch (e) {
      if (!mounted) return;
      overlayNavigator.pop();
      CustomSnack.warning('Failed to save PDF: $e', context);
    } finally {
      if (await pdfFile.exists()) {
        await pdfFile.delete();
      }
    }
  }

  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      CustomSnack.warning('Could not open PDF', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert PDF'),
        backgroundColor: AppColors.scaffoldBG,
      ),
      body: BlocBuilder<ConvertPdfCubit, ConvertPdfState>(
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
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  Gap(AppDimensions.spacing16),
                  ElevatedButton(
                    onPressed: _fetchPdfDocuments,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.items.isEmpty) {
            return const EmptyWidget(
              icon: Icons.picture_as_pdf_outlined,
              title: 'No PDFs yet',
              subTitle: 'Tap the + button to create a PDF',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _fetchPdfDocuments();
            },
            color: AppColors.primary,
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacing16),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: state.items.length,
                separatorBuilder: (_, __) => Gap(AppDimensions.spacing16),
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return PdfDocumentListItem(
                    item: item,
                    onTap: () => _openPdf(item.fileUrl),
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
            onPressed: () => _handleImageSource(ImageSource.camera),
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.image),
            onPressed: () => _handleImageSource(ImageSource.gallery),
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.file_present),
            onPressed: _handleFileSelection,
          ),
        ],
      ),
    );
  }
}
