import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/popup_item.dart';
import 'package:business_card_scanner/features/tools/presentation/views/sign_document/widgets/draggable_resizable_signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sfpdf;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SignCanvasScreen extends StatefulWidget {
  final String documentTitle;
  final int currentPage;
  final int totalPages;
  final Widget? preview;
  final String? pdfFilePath;

  const SignCanvasScreen({
    super.key,
    this.documentTitle = 'Sign Document',
    this.currentPage = 1,
    this.totalPages = 1,
    this.preview,
    this.pdfFilePath,
  });

  @override
  State<SignCanvasScreen> createState() => _SignCanvasScreenState();
}

class _SignCanvasScreenState extends State<SignCanvasScreen> {
  Uint8List? _signatureImage;

  // Signature position and scale state
  Offset _signaturePosition = Offset.zero;
  double _signatureScale = 1.0;
  double _baseSignatureWidth = 0.0;
  double _signatureAspectRatio = 0.5;
  Size _pdfCanvasSize = Size.zero;
  bool _isSavingSignedPdf = false;
  late final PdfViewerController _pdfViewerController;
  int _currentPageNumber = 1;
  int _totalPageCount = 1;
  int _signaturePageNumber = 1;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _addSignature() async {
    // Show bottom sheet with signature options
    final option = await showModalBottomSheet<SignatureOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _SignatureOptionsSheet();
      },
    );

    if (option == null || !mounted) return;

    Uint8List? signatureBytes;

    switch (option) {
      case SignatureOption.draw:
        signatureBytes = await _showDrawSignatureSheet();
        break;
      case SignatureOption.scan:
        signatureBytes = await _pickSignatureFromCamera();
        break;
      case SignatureOption.import:
        signatureBytes = await _pickSignatureFromGallery();
        break;
    }

    if (signatureBytes != null && mounted) {
      final aspectRatio = await _getImageAspectRatio(signatureBytes);
      if (!mounted) return;
      setState(() {
        _signatureImage = signatureBytes;
        _signatureAspectRatio = aspectRatio;
        _signatureScale = 1.0;
        _baseSignatureWidth = 0.0; // Reset to recalculate initial position
        _signaturePosition =
            Offset.zero; // Will be set in onInitialized callback
        _signaturePageNumber = _currentPageNumber;
      });
      CustomSnack.success('Signature added', context);
    }
  }

  void _handlePageChanged(int pageNumber) {
    if (!mounted) return;
    if (_currentPageNumber != pageNumber) {
      setState(() {
        _currentPageNumber = pageNumber;
      });
    }
  }

  void _handleDocumentLoaded(int totalPages) {
    if (!mounted) return;
    setState(() {
      _totalPageCount = totalPages;
    });
  }

  Future<Uint8List?> _showDrawSignatureSheet() async {
    return await showModalBottomSheet<Uint8List>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _SignaturePadSheet();
      },
    );
  }

  Future<double> _getImageAspectRatio(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final ratio = image.width == 0
          ? 0.5
          : image.height.toDouble() / image.width.toDouble();
      image.dispose();
      return ratio.isFinite && ratio > 0 ? ratio : 0.5;
    } catch (_) {
      return 0.5;
    }
  }

  Future<Uint8List?> _pickSignatureFromCamera() async {
    try {
      final externalAppService = context.read<ExternalAppService>();
      final imageFile = await externalAppService.pickImage(ImageSource.camera);

      if (imageFile == null || !mounted) {
        return null;
      }

      return await imageFile.readAsBytes();
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to capture signature: $e', context);
      }
      return null;
    }
  }

  Future<Uint8List?> _pickSignatureFromGallery() async {
    try {
      final externalAppService = context.read<ExternalAppService>();
      final imageFile = await externalAppService.pickImage(ImageSource.gallery);

      if (imageFile == null || !mounted) {
        return null;
      }

      return await imageFile.readAsBytes();
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to import signature: $e', context);
      }
      return null;
    }
  }

  void _finishSigning() {
    Navigator.of(context).pop(_signatureImage);
  }

  Future<void> _onSignatureMenuSelected(_SignatureMenuAction action) async {
    switch (action) {
      case _SignatureMenuAction.save:
        await _saveSignedPdf();
        break;
      case _SignatureMenuAction.download:
        await _downloadSignedPdf();
        break;
    }
  }

  Future<Uint8List?> _generateSignedPdfBytes() async {
    if (widget.pdfFilePath == null) {
      CustomSnack.warning('No PDF file available to download.', context);
      return null;
    }
    if (_signatureImage == null) {
      CustomSnack.warning('Please add a signature before proceeding.', context);
      return null;
    }
    if (_pdfCanvasSize == Size.zero) {
      CustomSnack.warning(
        'Signature size information is missing. Please adjust the signature and try again.',
        context,
      );
      return null;
    }

    sfpdf.PdfDocument? document;
    try {
      final originalFile = File(widget.pdfFilePath!);
      if (!await originalFile.exists()) {
        CustomSnack.warning('Original PDF file not found.', context);
        return null;
      }

      final bytes = await originalFile.readAsBytes();
      document = sfpdf.PdfDocument(inputBytes: bytes);
      if (document.pages.count == 0) {
        CustomSnack.warning('PDF has no pages to sign.', context);
        return null;
      }

      final targetPageIndex =
          (_signaturePageNumber - 1).clamp(0, document.pages.count - 1);
      final page = document.pages[targetPageIndex];
      final pageSize = page.getClientSize();

      final previewWidth = _pdfCanvasSize.width;
      final previewHeight = _pdfCanvasSize.height;
      if (previewWidth == 0 || previewHeight == 0) {
        CustomSnack.warning('Unable to determine preview size.', context);
        return null;
      }

      final fallbackWidth = _pdfCanvasSize.width * 0.35;
      final baseWidth =
          _baseSignatureWidth > 0 ? _baseSignatureWidth : fallbackWidth;
      final signatureWidthPreview = baseWidth * _signatureScale;
      final signatureHeightPreview =
          signatureWidthPreview * _signatureAspectRatio;

      final scaleX = pageSize.width / previewWidth;
      final scaleY = pageSize.height / previewHeight;

      final pdfX = _signaturePosition.dx * scaleX;
      final pdfY = _signaturePosition.dy * scaleY;
      final pdfWidth = signatureWidthPreview * scaleX;
      final pdfHeight = signatureHeightPreview * scaleY;

      final pdfImage = sfpdf.PdfBitmap(_signatureImage!);
      page.graphics.drawImage(
        pdfImage,
        ui.Rect.fromLTWH(pdfX, pdfY, pdfWidth, pdfHeight),
      );

      final outputBytes = await document.save();
      return Uint8List.fromList(outputBytes);
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to prepare signed PDF: $e', context);
      }
      return null;
    } finally {
      document?.dispose();
    }
  }

  Future<void> _downloadSignedPdf() async {
    final outputBytes = await _generateSignedPdfBytes();
    if (outputBytes == null) {
      return;
    }

    try {
      final directory = await _resolveDownloadDirectory();
      final signedFile = File('${directory.path}/${_generateSignedFileName()}');
      await signedFile.writeAsBytes(outputBytes, flush: true);

      if (!mounted) return;
      CustomSnack.success(
        'Signed PDF downloaded to ${signedFile.path}',
        context,
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to download PDF: $e', context);
    }
  }

  Future<void> _saveSignedPdf() async {
    if (_isSavingSignedPdf) {
      CustomSnack.warning(
          'Please wait, saving is already in progress.', context);
      return;
    }

    final user = fb.FirebaseAuth.instance.currentUser;
    if (user == null) {
      CustomSnack.warning(
        'Please login to save your signed document.',
        context,
      );
      return;
    }

    setState(() {
      _isSavingSignedPdf = true;
    });

    File? tempSignedFile;

    try {
      // Generate PDF bytes
      final outputBytes = await _generateSignedPdfBytes();
      if (outputBytes == null) {
        // <== IMPORTANT: prevent infinite loading
        setState(() {
          _isSavingSignedPdf = false;
        });
        return;
      }

      // Prepare file
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempDir = await getTemporaryDirectory();
      tempSignedFile = File('${tempDir.path}/signed_$timestamp.pdf');
      await tempSignedFile.writeAsBytes(outputBytes, flush: true);

      // Upload to Firebase Storage (correct syntax!)
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('signed_docs')
          .child(user.uid)
          .child('signed_$timestamp.pdf');

      final uploadTask = storageRef.putFile(
        tempSignedFile,
        SettableMetadata(contentType: 'application/pdf'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save metadata in Firestore
      await FirebaseFirestore.instance.collection('signed_docs').add({
        'title': widget.documentTitle,
        'pdf_url': downloadUrl,
        'uid': user.uid,
        'created_at': Timestamp.now(),
      });

      if (mounted) {
        CustomSnack.success('Signed PDF saved successfully.', context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to save signed PDF: $e', context);
      }
    } finally {
      // delete temp file
      if (tempSignedFile != null && await tempSignedFile.exists()) {
        try {
          await tempSignedFile.delete();
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          _isSavingSignedPdf = false;
        });
      }
    }
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      final directories =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (directories != null && directories.isNotEmpty) {
        return directories.first;
      }
      final fallback = await getExternalStorageDirectory();
      if (fallback != null) {
        return fallback;
      }
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      final downloadsDirectory = await getDownloadsDirectory();
      if (downloadsDirectory != null) {
        return downloadsDirectory;
      }
    }

    return await getApplicationDocumentsDirectory();
  }

  String _generateSignedFileName() {
    final sanitized =
        widget.documentTitle.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_').trim();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${sanitized.isEmpty ? 'document' : sanitized}_signed_$timestamp.pdf';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.documentTitle,
          style: AppTextStyles.headline4.copyWith(color: AppColors.gray900),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
            child: Center(
              child: Text(
                '$_currentPageNumber/$_totalPageCount',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
            ),
          ),
          if (_signatureImage != null) ...[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _isSavingSignedPdf
                  ? SizedBox(
                      height: 32.h,
                      width: 32.w,
                      child: const CircularProgressIndicator())
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: PopupMenuButton<_SignatureMenuAction>(
                          onSelected: _onSignatureMenuSelected,
                          icon: const Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.black,
                            size: 14,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<_SignatureMenuAction>>[
                            const PopupMenuItem(
                              value: _SignatureMenuAction.save,
                              child: CustomPopupItem(
                                icon: Icons.save,
                                title: 'Save',
                              ),
                            ),
                            const PopupMenuItem(
                              value: _SignatureMenuAction.download,
                              child: CustomPopupItem(
                                icon: Icons.download_outlined,
                                title: 'Download',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
          ]
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: LayoutBuilder(
                  builder: (context, stackConstraints) {
                    final stackSize = Size(
                        stackConstraints.maxWidth, stackConstraints.maxHeight);
                    _pdfCanvasSize = stackSize;
                    return Stack(
                      children: [
                        // pdf preview
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radius24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radius20),
                            child: Container(
                              color: AppColors.surface,
                              child: widget.pdfFilePath != null
                                  ? _PdfPreview(
                                      pdfFilePath: widget.pdfFilePath!,
                                      controller: _pdfViewerController,
                                      onCurrentPageChanged: _handlePageChanged,
                                      onTotalPagesResolved:
                                          _handleDocumentLoaded,
                                    )
                                  : (widget.preview ??
                                      _DefaultDocumentPreview()),
                            ),
                          ),
                        ),
                        if (_signatureImage != null)
                          // signature
                          DraggableResizableSignature(
                            signatureBytes: _signatureImage!,
                            position: _signaturePosition,
                            scale: _signatureScale,
                            baseWidth: _baseSignatureWidth > 0
                                ? _baseSignatureWidth
                                : stackConstraints.maxWidth * 0.35,
                            imageAspectRatio: _signatureAspectRatio,
                            containerSize: stackSize,
                            onPositionChanged: (newPosition) {
                              setState(() {
                                _signaturePosition = newPosition;
                                _signaturePageNumber = _currentPageNumber;
                              });
                            },
                            onScaleChanged: (newScale) {
                              setState(() {
                                _signatureScale = newScale;
                                _signaturePageNumber = _currentPageNumber;
                              });
                            },
                            onInitialized: (width) {
                              setState(() {
                                if (_baseSignatureWidth == 0) {
                                  _baseSignatureWidth = width;
                                }
                                // Set initial position to bottom-right
                                if (_signaturePosition == Offset.zero) {
                                  final signatureHeight =
                                      width * _signatureAspectRatio;
                                  _signaturePosition = Offset(
                                    (stackConstraints.maxWidth -
                                            width -
                                            AppDimensions.spacing32)
                                        .clamp(0.0, double.infinity),
                                    (stackConstraints.maxHeight -
                                            signatureHeight -
                                            AppDimensions.spacing32)
                                        .clamp(0.0, double.infinity),
                                  );
                                }
                                _signaturePageNumber = _currentPageNumber;
                              });
                            },
                            onClear: () {
                              setState(() {
                                _signatureImage = null;
                                _signaturePosition = Offset.zero;
                                _signatureScale = 1.0;
                                _baseSignatureWidth = 0.0;
                                _signatureAspectRatio = 0.5;
                              });
                              // Show options to add new signature
                              _addSignature();
                            },
                            onConfirm: () {
                              CustomSnack.success(
                                  'Signature confirmed', context);
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.spacing20,
          0,
          AppDimensions.spacing20,
          AppDimensions.spacing24,
        ),
        child: SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius16),
              ),
            ),
            onPressed: _addSignature,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              _signatureImage == null ? 'Add Signature' : 'Replace Signature',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
      ),
    );
  }
}

enum SignatureOption {
  draw,
  scan,
  import,
}

enum _SignatureMenuAction { save, download }

class _SignatureOptionsSheet extends StatelessWidget {
  const _SignatureOptionsSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
            child: Text(
              'Add Signature',
              style: AppTextStyles.headline4.copyWith(color: AppColors.gray900),
            ),
          ),
          SizedBox(height: AppDimensions.spacing24),
          // Options
          _SignatureOptionTile(
            icon: Icons.edit_outlined,
            title: 'Draw signature',
            onTap: () => Navigator.of(context).pop(SignatureOption.draw),
          ),
          _SignatureOptionTile(
            icon: Icons.document_scanner_outlined,
            title: 'Scan signature',
            onTap: () => Navigator.of(context).pop(SignatureOption.scan),
          ),
          _SignatureOptionTile(
            icon: Icons.photo_library_outlined,
            title: 'Import from album',
            onTap: () => Navigator.of(context).pop(SignatureOption.import),
          ),
          SizedBox(height: AppDimensions.spacing24),
        ],
      ),
    );
  }
}

class _SignatureOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SignatureOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.gray900,
            ),
            SizedBox(width: AppDimensions.spacing16),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfPreview extends StatelessWidget {
  final String pdfFilePath;
  final PdfViewerController controller;
  final ValueChanged<int>? onCurrentPageChanged;
  final ValueChanged<int>? onTotalPagesResolved;

  const _PdfPreview({
    required this.pdfFilePath,
    required this.controller,
    this.onCurrentPageChanged,
    this.onTotalPagesResolved,
  });

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.file(
      File(pdfFilePath),
      controller: controller,
      enableDoubleTapZooming: true,
      enableTextSelection: false,
      canShowScrollHead: false,
      canShowScrollStatus: false,
      onPageChanged: (details) {
        onCurrentPageChanged?.call(details.newPageNumber);
      },
      onDocumentLoaded: (details) {
        onTotalPagesResolved?.call(details.document.pages.count);
      },
    );
  }
}

class _DefaultDocumentPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sample Document Title',
            style: AppTextStyles.headline3.copyWith(color: Colors.black),
          ),
          SizedBox(height: AppDimensions.spacing16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.spacing12),
                    child: Text(
                      'This is a sample paragraph demonstrating how the document preview will appear. Replace this with actual document content.',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.gray700),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePadSheet extends StatefulWidget {
  const _SignaturePadSheet();

  @override
  State<_SignaturePadSheet> createState() => _SignaturePadSheetState();
}

class _SignaturePadSheetState extends State<_SignaturePadSheet> {
  final GlobalKey _signatureKey = GlobalKey();
  final List<Offset?> _points = [];

  void _addPoint(Offset point) {
    setState(() {
      _points.add(point);
    });
  }

  void _endStroke() {
    setState(() {
      _points.add(null);
    });
  }

  void _clear() {
    setState(() {
      _points.clear();
    });
  }

  Future<void> _saveSignature() async {
    if (_points.isEmpty) {
      CustomSnack.warning('Please draw your signature', context);
      return;
    }

    final boundary = _signatureKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) {
      Navigator.of(context).pop();
      return;
    }
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();
    if (!mounted) return;
    Navigator.of(context).pop(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spacing24,
        AppDimensions.spacing24,
        AppDimensions.spacing24,
        AppDimensions.spacing24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Draw Signature',
            style: AppTextStyles.headline4.copyWith(color: AppColors.gray900),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spacing16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppDimensions.radius16),
              border: Border.all(color: AppColors.gray300),
            ),
            child: GestureDetector(
              onPanStart: (details) => _addPoint(details.localPosition),
              onPanUpdate: (details) => _addPoint(details.localPosition),
              onPanEnd: (_) => _endStroke(),
              child: RepaintBoundary(
                key: _signatureKey,
                child: CustomPaint(
                  painter: _SignaturePainter(points: _points),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _clear,
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _saveSignature,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  _SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
