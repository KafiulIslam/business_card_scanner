import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  // Signature position and scale state
  Offset _signaturePosition = Offset.zero;
  double _signatureScale = 1.0;
  double _baseSignatureWidth = 0.0;

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
      setState(() {
        _signatureImage = signatureBytes;
        // Reset position and scale when new signature is added
        _signaturePosition = Offset.zero;
        _signatureScale = 1.0;
        _baseSignatureWidth = 0.0; // Reset to recalculate initial position
      });
      CustomSnack.success('Signature added', context);
    }
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
                      _DraggableResizableSignature(
                        signatureBytes: _signatureImage!,
                        position: _signaturePosition,
                        scale: _signatureScale,
                        baseWidth: _baseSignatureWidth > 0
                            ? _baseSignatureWidth
                            : constraints.maxWidth * 0.35,
                        containerSize: Size(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                        onPositionChanged: (newPosition) {
                          setState(() {
                            _signaturePosition = newPosition;
                          });
                        },
                        onScaleChanged: (newScale) {
                          setState(() {
                            _signatureScale = newScale;
                          });
                        },
                        onInitialized: (width) {
                          if (_baseSignatureWidth == 0) {
                            setState(() {
                              _baseSignatureWidth = width;
                              // Set initial position to bottom-right if not set
                              if (_signaturePosition == Offset.zero) {
                                _signaturePosition = Offset(
                                  constraints.maxWidth -
                                      width -
                                      AppDimensions.spacing32,
                                  constraints.maxHeight -
                                      (width * 0.5) -
                                      AppDimensions.spacing32,
                                );
                              }
                            });
                          }
                        },
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
            icon: Icons.camera_alt_outlined,
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
              size: 24,
              color: AppColors.gray900,
            ),
            SizedBox(width: AppDimensions.spacing16),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.gray900,
                fontWeight: FontWeight.w500,
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

class _DraggableResizableSignature extends StatefulWidget {
  final Uint8List signatureBytes;
  final Offset position;
  final double scale;
  final double baseWidth;
  final Size containerSize;
  final ValueChanged<Offset> onPositionChanged;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<double> onInitialized;

  const _DraggableResizableSignature({
    required this.signatureBytes,
    required this.position,
    required this.scale,
    required this.baseWidth,
    required this.containerSize,
    required this.onPositionChanged,
    required this.onScaleChanged,
    required this.onInitialized,
  });

  @override
  State<_DraggableResizableSignature> createState() =>
      _DraggableResizableSignatureState();
}

class _DraggableResizableSignatureState
    extends State<_DraggableResizableSignature> {
  Offset _currentPosition = Offset.zero;
  double _currentScale = 1.0;
  bool _isInitialized = false;

  // Store initial values for scale gesture
  Offset _initialPosition = Offset.zero;
  double _initialScale = 1.0;
  Offset _initialFocalPoint = Offset.zero;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
    _currentScale = widget.scale;
  }

  @override
  void didUpdateWidget(_DraggableResizableSignature oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position) {
      _currentPosition = widget.position;
    }
    if (widget.scale != oldWidget.scale) {
      _currentScale = widget.scale;
    }
  }

  Offset _clampPosition(Offset position, double width, double height) {
    final maxX = widget.containerSize.width - width;
    final maxY = widget.containerSize.height - height;

    return Offset(
      position.dx.clamp(0.0, maxX),
      position.dy.clamp(0.0, maxY),
    );
  }

  double _clampScale(double scale) {
    return scale.clamp(0.3, 3.0); // Min 30%, Max 300%
  }

  void _onScaleStart(ScaleStartDetails details) {
    // Store initial values when gesture starts
    _initialPosition = _currentPosition;
    _initialScale = _currentScale;
    _initialFocalPoint = details.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // Handle both panning (when scale is close to 1.0) and scaling
    final scaleDelta = details.scale;
    final isScaling =
        (scaleDelta - 1.0).abs() > 0.01; // Threshold for scaling vs panning

    if (isScaling) {
      // Scaling gesture - adjust both scale and position
      final newScale = _initialScale * scaleDelta;
      final clampedScale = _clampScale(newScale);

      final scaleFactor = clampedScale / _initialScale;
      final focalPoint = details.localFocalPoint;

      final newWidth = widget.baseWidth * clampedScale;
      final newHeight = newWidth * 0.5;

      // Calculate new position to keep focal point fixed during scaling
      final dx =
          focalPoint.dx - (focalPoint.dx - _initialPosition.dx) * scaleFactor;
      final dy =
          focalPoint.dy - (focalPoint.dy - _initialPosition.dy) * scaleFactor;

      final newPosition = _clampPosition(
        Offset(dx, dy),
        newWidth,
        newHeight,
      );

      setState(() {
        _currentScale = clampedScale;
        _currentPosition = newPosition;
      });

      widget.onScaleChanged(clampedScale);
      widget.onPositionChanged(newPosition);
    } else {
      // Panning gesture - only update position
      final delta = details.localFocalPoint - _initialFocalPoint;
      final newPosition = _initialPosition + delta;

      final currentWidth = widget.baseWidth * _currentScale;
      final currentHeight = currentWidth * 0.5;

      final clampedPosition = _clampPosition(
        newPosition,
        currentWidth,
        currentHeight,
      );

      setState(() {
        _currentPosition = clampedPosition;
      });

      widget.onPositionChanged(clampedPosition);
    }
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // Reset initial values
    _initialPosition = _currentPosition;
    _initialScale = _currentScale;
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = widget.baseWidth * _currentScale;

    if (!_isInitialized && currentWidth > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onInitialized(currentWidth);
          setState(() {
            _isInitialized = true;
          });
        }
      });
    }

    return Positioned(
      left: _currentPosition.dx,
      top: _currentPosition.dy,
      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        child: Transform.scale(
          scale: _currentScale,
          child: Container(
            width: widget.baseWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.memory(
              widget.signatureBytes,
              fit: BoxFit.contain,
            ),
          ),
        ),
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
