import 'dart:io';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'scan_result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  late final TextRecognizer _textRecognizer;
  bool _isBusy = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first);
      final controller =
          CameraController(back, ResolutionPreset.high, enableAudio: false);
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _cameraController = controller;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _scanOnce() async {
    final controller = _cameraController;
    if (controller == null || _isBusy) return;
    setState(() => _isBusy = true);
    try {
      final file = await controller.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      if (!mounted) return;
      final extracted = _extractFields(recognizedText.text);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(
            rawText: recognizedText.text,
            extracted: extracted,
            imageFile: File(file.path),
          ),
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) {
        if (mounted) setState(() => _isBusy = false);
        return;
      }
      final inputImage = InputImage.fromFilePath(xFile.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      if (!mounted) return;
      final extracted = _extractFields(recognizedText.text);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(
            rawText: recognizedText.text,
            extracted: extracted,
            imageFile: File(xFile.path),
          ),
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Map<String, String?> _extractFields(String text) {
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final fullText = lines.join(' ');

    final emailReg = RegExp(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}");
    final phoneReg = RegExp(
        r"(?:(?:\+?\d{1,3}[\s-]?)?(?:\(\d{2,4}\)[\s-]?)?|\b)\d{3,4}[\s-]?\d{3}[\s-]?\d{3,4}\b");
    final webReg =
        RegExp(r"\b(?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b");

    String? email = emailReg.firstMatch(fullText)?.group(0);
    String? phone = phoneReg.firstMatch(fullText)?.group(0);
    String? website = webReg.firstMatch(fullText)?.group(0);

    String? name;
    for (final l in lines) {
      if (email != null && l.contains(email)) continue;
      if (phone != null && l.contains(phone)) continue;
      if (website != null && l.contains(website)) continue;
      if (l.toLowerCase().contains('address') ||
          l.toLowerCase().contains('tel')) continue;
      if (l.length > 2) {
        name = l;
        break;
      }
    }

    return {
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (controller == null)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                  child: Text(_errorMessage!,
                      style: const TextStyle(color: Colors.white)))
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final previewSize = controller.value.previewSize;
                  if (previewSize == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Camera gives landscape preview size. For portrait, swap w/h
                  final previewW = previewSize.height;
                  final previewH = previewSize.width;

                  return FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: previewW,
                      height: previewH,
                      child: CameraPreview(controller),
                    ),
                  );
                },
              ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _CornersPainter(),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isBusy)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //scan image from gallery
                      InkWell(
                        onTap: _isBusy ? null : _pickFromGallery,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              'Image',
                              style: AppTextStyles.headline3
                                  .copyWith(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      Gap(AppDimensions.spacing40),
                      // scan image from camera
                      InkWell(
                        onTap: _isBusy || controller == null ? null : _scanOnce,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.black)),
                          ),
                        ),
                      ),
                      Gap(AppDimensions.spacing40),
                      // create card manually
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_card_rounded,
                            color: Colors.white,
                          ),
                          Text(
                            'Add Card',
                            style: AppTextStyles.headline3
                                .copyWith(color: Colors.white, fontSize: 14),
                          )
                        ],
                      ),
                    ],
                  )
                  // ElevatedButton(
                  //   onPressed: _isBusy || controller == null ? null : _scanOnce,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.white,
                  //     foregroundColor: Colors.black,
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 14, horizontal: 24),
                  //     shape: const StadiumBorder(),
                  //   ),
                  //   child: const Text('Scan Card'),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Desired business card aspect ratio (width : height)
    const double cardAspect = 1.6; // ~85.6 x 54 mm
    final double maxWidth = size.width * 0.86;
    final double maxHeight = size.height * 0.62;

    // Compute rect that fits within screen keeping card aspect
    double targetWidth = maxWidth;
    double targetHeight = targetWidth / cardAspect;
    if (targetHeight > maxHeight) {
      targetHeight = maxHeight;
      targetWidth = targetHeight * cardAspect;
    }
    final double left = (size.width - targetWidth) / 2;
    final double top = (size.height - targetHeight) / 2;
    final Rect rect = Rect.fromLTWH(left, top, targetWidth, targetHeight);

    // Dimmed outside area with cutout
    final Path screenPath = Path()..addRect(Offset.zero & size);
    final Path cutout = Path()..addRRect(RRect.fromRectXY(rect, 12, 12));
    final Paint scrimPaint = Paint()
      ..color = const Color(0xB3000000) // ~70% black
      ..style = PaintingStyle.fill;
    canvas.drawPath(
        Path.combine(PathOperation.difference, screenPath, cutout), scrimPaint);

    // Corner markers
    const double corner = 28;
    final Paint cornerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(
        rect.topLeft, rect.topLeft + const Offset(corner, 0), cornerPaint);
    canvas.drawLine(
        rect.topLeft, rect.topLeft + const Offset(0, corner), cornerPaint);
    canvas.drawLine(
        rect.topRight, rect.topRight + const Offset(-corner, 0), cornerPaint);
    canvas.drawLine(
        rect.topRight, rect.topRight + const Offset(0, corner), cornerPaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(corner, 0),
        cornerPaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(0, -corner),
        cornerPaint);
    canvas.drawLine(rect.bottomRight,
        rect.bottomRight + const Offset(-corner, 0), cornerPaint);
    canvas.drawLine(rect.bottomRight,
        rect.bottomRight + const Offset(0, -corner), cornerPaint);

    // Side helper labels
    // final TextStyle labelStyle = const TextStyle(
    //     color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500);
    // // Left side (vertical) "This side down"
    // _drawRotatedText(canvas, Offset(rect.left - 12, rect.center.dy), -90,
    //     'This side down', labelStyle,
    //     alignEnd: true);
    // // Right side (vertical) "This side up"
    // _drawRotatedText(canvas, Offset(rect.right + 12, rect.center.dy), 90,
    //     'This side up', labelStyle,
    //     alignEnd: false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _drawRotatedText(Canvas canvas, Offset center, double degrees,
      String text, TextStyle style,
      {bool alignEnd = false}) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(degrees * 3.1415926535 / 180);
    final TextPainter tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final Offset offset = Offset(alignEnd ? -tp.width : 0, -tp.height / 2);
    tp.paint(canvas, offset);
    canvas.restore();
  }
}
