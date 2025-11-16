import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _totalPages = widget.totalPages;
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    setState(() {
      _totalPages = details.document.pages.count;
    });
  }

  Future<void> _addSignature() async {
    final signature = await showModalBottomSheet<Uint8List>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const _SignaturePadSheet();
      },
    );

    if (signature != null && mounted) {
      setState(() {
        _signatureImage = signature;
      });
      CustomSnack.success('Signature added', context);
    }
  }

  void _finishSigning() {
    Navigator.of(context).pop(_signatureImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBG,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          widget.documentTitle,
          style: AppTextStyles.headline4.copyWith(color: AppColors.gray900),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing8),
            child: Center(
              child: Text(
                '${widget.currentPage}/$_totalPages',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray700,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.secondary),
            onPressed: _finishSigning,
          ),
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
                child: Stack(
                  children: [
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
                      // padding: EdgeInsets.all(AppDimensions.spacing24),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius20),
                        child: Container(
                          color: AppColors.surface,
                          child: widget.pdfFilePath != null
                              ? _PdfPreview(
                                  pdfFilePath: widget.pdfFilePath!,
                                  onDocumentLoaded: _onDocumentLoaded,
                                )
                              : (widget.preview ?? _DefaultDocumentPreview()),
                        ),
                      ),
                    ),
                    if (_signatureImage != null)
                      Positioned(
                        bottom: AppDimensions.spacing32,
                        right: AppDimensions.spacing32,
                        child: Image.memory(
                          _signatureImage!,
                          width: constraints.maxWidth * 0.35,
                          fit: BoxFit.contain,
                        ),
                      ),
                  ],
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
              backgroundColor: AppColors.secondary,
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

class _PdfPreview extends StatelessWidget {
  final String pdfFilePath;
  final Function(PdfDocumentLoadedDetails)? onDocumentLoaded;

  const _PdfPreview({
    required this.pdfFilePath,
    this.onDocumentLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.file(
      File(pdfFilePath),
      onDocumentLoaded: onDocumentLoaded,
      enableDoubleTapZooming: true,
      enableTextSelection: false,
      canShowScrollHead: false,
      canShowScrollStatus: false,
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
          RepaintBoundary(
            key: _signatureKey,
            child: Container(
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
                  backgroundColor: AppColors.secondary,
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
