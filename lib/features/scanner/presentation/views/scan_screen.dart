import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../cubit/scan_cubit.dart';
import '../cubit/scan_state.dart';
import 'scan_result_screen.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ScanView();
  }
}

class _ScanView extends StatefulWidget {
  const _ScanView({super.key});

  @override
  State<_ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<_ScanView> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize camera when screen opens
    context.read<ScanCubit>().initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Ensure camera/textRecognizer are released.
    context.read<ScanCubit>().disposeResources();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Forward lifecycle to cubit to handle camera properly
    context.read<ScanCubit>().handleLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCubit, ScanState>(
      listenWhen: (prev, curr) =>
      prev.errorMessage != curr.errorMessage || prev.result != curr.result,
      listener: (context, state) async {
        // Errors → SnackBar
        final msg = state.errorMessage;
        if (msg != null && msg.isNotEmpty) {
          CustomSnack.warning(msg, context);
          context.read<ScanCubit>().clearError();
        }

        // On result → open ScanResultScreen, then clear result
        final result = state.result;
        if (result != null) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ScanResultScreen(
                rawText: result.rawText,
                extracted: result.extracted,
                imageFile: result.imageFile,
              ),
            ),
          );
          if (context.mounted) {
            context.read<ScanCubit>().clearResult();
          }
        }
      },
      builder: (context, state) {
        final controller = state.cameraController;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                // Camera preview
                if (controller == null)
                  const Center(child: CircularProgressIndicator())
                else
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final previewSize = controller.value.previewSize;
                      if (previewSize == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // Camera gives landscape preview size; swap for portrait display.
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

                // Overlay with corners and dim background
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _CornersPainter()),
                  ),
                ),

                // Bottom controls
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isBusy)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Pick from gallery
                          InkWell(
                            onTap: state.isBusy
                                ? null
                                : context.read<ScanCubit>().scanFromGallery,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.image_outlined,
                                    color: Colors.white),
                                Text(
                                  'Image',
                                  style: AppTextStyles.headline3.copyWith(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Gap(AppDimensions.spacing40),

                          // Capture
                          InkWell(
                            onTap: state.isBusy || controller == null
                                ? null
                                : context.read<ScanCubit>().scanFromCamera,
                            child: _buildShutterButton(),
                          ),
                          Gap(AppDimensions.spacing40),

                          // Manual add (hook up your route)
                          InkWell(
                            onTap: () {
                              // TODO: Navigate to manual card entry screen
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_card_rounded,
                                    color: Colors.white),
                                Text(
                                  'Add Card',
                                  style: AppTextStyles.headline3.copyWith(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShutterButton(){
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white,
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }

}

/// Overlay painter: dims outside, shows a business-card aspect frame with bold corners.
class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Card aspect ratio (~85.6 x 54 mm)
    const double cardAspect = 1.6;
    final double maxWidth = size.width * 0.86;
    final double maxHeight = size.height * 0.62;

    double targetWidth = maxWidth;
    double targetHeight = targetWidth / cardAspect;
    if (targetHeight > maxHeight) {
      targetHeight = maxHeight;
      targetWidth = targetHeight * cardAspect;
    }
    final double left = (size.width - targetWidth) / 2;
    final double top = (size.height - targetHeight) / 2;
    final Rect rect = Rect.fromLTWH(left, top, targetWidth, targetHeight);

    // Dim outside area
    final Path screenPath = Path()..addRect(Offset.zero & size);
    final Path cutout = Path()..addRRect(RRect.fromRectXY(rect, 12, 12));
    final Paint scrimPaint = Paint()
      ..color = const Color(0xB3000000)
      ..style = PaintingStyle.fill;
    canvas.drawPath(
      Path.combine(PathOperation.difference, screenPath, cutout),
      scrimPaint,
    );

    // Bold white corners
    const double corner = 28;
    final Paint cornerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    // Top-left
    canvas.drawLine(
        rect.topLeft, rect.topLeft + const Offset(corner, 0), cornerPaint);
    canvas.drawLine(
        rect.topLeft, rect.topLeft + const Offset(0, corner), cornerPaint);
    // Top-right
    canvas.drawLine(
        rect.topRight, rect.topRight + const Offset(-corner, 0), cornerPaint);
    canvas.drawLine(
        rect.topRight, rect.topRight + const Offset(0, corner), cornerPaint);
    // Bottom-left
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(corner, 0),
        cornerPaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(0, -corner),
        cornerPaint);
    // Bottom-right
    canvas.drawLine(rect.bottomRight,
        rect.bottomRight + const Offset(-corner, 0), cornerPaint);
    canvas.drawLine(rect.bottomRight,
        rect.bottomRight + const Offset(0, -corner), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}