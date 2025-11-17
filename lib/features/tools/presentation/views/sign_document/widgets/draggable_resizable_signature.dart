import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class DraggableResizableSignature extends StatefulWidget {
  final Uint8List signatureBytes;
  final Offset position;
  final double scale;
  final double baseWidth;
  final Size containerSize;
  final ValueChanged<Offset> onPositionChanged;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<double> onInitialized;
  final VoidCallback? onClear;
  final VoidCallback? onConfirm;

  const DraggableResizableSignature({
    super.key,
    required this.signatureBytes,
    required this.position,
    required this.scale,
    required this.baseWidth,
    required this.containerSize,
    required this.onPositionChanged,
    required this.onScaleChanged,
    required this.onInitialized,
    this.onClear,
    this.onConfirm,
  });

  @override
  State<DraggableResizableSignature> createState() =>
      _DraggableResizableSignatureState();
}

class _DraggableResizableSignatureState
    extends State<DraggableResizableSignature> {
  Offset _currentPosition = Offset.zero;
  double _currentScale = 1.0;
  bool _isInitialized = false;
  bool _isLocked = false; // Track if signature is locked

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
  void didUpdateWidget(DraggableResizableSignature oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position) {
      _currentPosition = widget.position;
    }
    if (widget.scale != oldWidget.scale) {
      _currentScale = widget.scale;
    }
  }

  Offset _clampPosition(Offset position, double width, double height) {
    // Ensure signature doesn't go beyond PDF preview boundaries
    // Clamp width and height to container size first
    final clampedWidth = width.clamp(0.0, widget.containerSize.width);
    final clampedHeight = height.clamp(0.0, widget.containerSize.height);

    // Calculate maximum allowed position
    final maxX = widget.containerSize.width - clampedWidth;
    final maxY = widget.containerSize.height - clampedHeight;

    // Clamp position to ensure signature stays within bounds
    return Offset(
      position.dx.clamp(0.0, maxX.clamp(0.0, widget.containerSize.width)),
      position.dy.clamp(0.0, maxY.clamp(0.0, widget.containerSize.height)),
    );
  }

  double _clampScale(double scale) {
    // Calculate maximum scale based on PDF preview size
    // Signature should never exceed PDF preview dimensions
    final baseWidth = widget.baseWidth;
    if (baseWidth <= 0)
      return scale.clamp(0.3, 3.0); // Fallback if baseWidth not set

    final baseHeight = baseWidth * 0.5; // Approximate aspect ratio

    // Calculate max scale that fits within PDF preview area
    // Use the smaller constraint to ensure signature fits both width and height
    final maxScaleByWidth = widget.containerSize.width / baseWidth;
    final maxScaleByHeight = widget.containerSize.height / baseHeight;
    final maxScale = (maxScaleByWidth < maxScaleByHeight
        ? maxScaleByWidth
        : maxScaleByHeight);

    // Ensure max scale is at least 0.3 (30%) - this ensures signature can always be resized
    final clampedMaxScale = maxScale < 0.3 ? 0.3 : maxScale;

    // Clamp scale between 30% and the calculated maximum
    return scale.clamp(0.3, clampedMaxScale);
  }

  void _onScaleStart(ScaleStartDetails details) {
    // Don't allow gestures when locked
    if (_isLocked) return;

    // Store initial values when gesture starts
    _initialPosition = _currentPosition;
    _initialScale = _currentScale;
    _initialFocalPoint = details.localFocalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    // Don't allow gestures when locked
    if (_isLocked) return;

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

      // Ensure signature doesn't exceed canvas bounds after scaling
      final newPosition = _clampPosition(
        Offset(dx, dy),
        newWidth.clamp(0.0, widget.containerSize.width),
        newHeight.clamp(0.0, widget.containerSize.height),
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

      // Ensure signature doesn't exceed canvas bounds during dragging
      final clampedPosition = _clampPosition(
        newPosition,
        currentWidth.clamp(0.0, widget.containerSize.width),
        currentHeight.clamp(0.0, widget.containerSize.height),
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

    // Initialize position callback
    if (!_isInitialized && currentWidth > 0 && widget.baseWidth > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onInitialized(currentWidth);
          setState(() {
            _isInitialized = true;
          });
        }
      });
    }

    // Sync position from widget if it changed
    if (widget.position != _currentPosition && widget.position != Offset.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentPosition = widget.position;
            _initialPosition = widget.position;
          });
        }
      });
    }

    // Use widget position if current is zero, otherwise use current
    final displayPosition = _currentPosition == Offset.zero
        ? (widget.position != Offset.zero
            ? widget.position
            : const Offset(100, 100))
        : _currentPosition;

    return Positioned(
      left: displayPosition.dx,
      top: displayPosition.dy,
      child: Stack(
        children: [
          // Signature with conditional border
          GestureDetector(
            onDoubleTap: () {
              // Double-tap to unlock
              setState(() {
                _isLocked = false;
              });
            },
            child: Container(
              decoration: _isLocked
                  ? null
                  : BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
              child: GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onScaleEnd: _onScaleEnd,
                child: Transform.scale(
                  scale: _currentScale,
                  child: SizedBox(
                    width: widget.baseWidth,
                    child: Image.memory(
                      widget.signatureBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Control buttons - only show when not locked
          if (!_isLocked) ...[
            // Top-left: Increase size button
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Increase signature size by 5px
                  final currentWidth = widget.baseWidth * _currentScale;
                  final newWidth = currentWidth + 5.0;
                  final newScale = newWidth / widget.baseWidth;
                  final clampedScale = _clampScale(newScale);

                  // Calculate new dimensions
                  final finalWidth = widget.baseWidth * clampedScale;
                  final finalHeight = finalWidth * 0.5;

                  // Calculate old dimensions
                  final oldWidth = widget.baseWidth * _currentScale;
                  final oldHeight = oldWidth * 0.5;

                  // Adjust position to keep bottom-right corner fixed
                  final newPosition = Offset(
                    _currentPosition.dx + (oldWidth - finalWidth),
                    _currentPosition.dy + (oldHeight - finalHeight),
                  );

                  final clampedPosition = _clampPosition(
                    newPosition,
                    finalWidth,
                    finalHeight,
                  );

                  setState(() {
                    _currentScale = clampedScale;
                    _currentPosition = clampedPosition;
                  });

                  widget.onScaleChanged(clampedScale);
                  widget.onPositionChanged(clampedPosition);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4))),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
            // Top-right: Lock/Confirm button
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Lock the signature
                  setState(() {
                    _isLocked = true;
                  });
                  // Also call the onConfirm callback if provided
                  if (widget.onConfirm != null) {
                    widget.onConfirm!();
                  }
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomLeft: Radius.circular(4))),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
            // Bottom-right: Decrease size button
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Decrease signature size by 5px
                  final currentWidth = widget.baseWidth * _currentScale;
                  final newWidth = (currentWidth - 5.0).clamp(1.0, double.infinity);
                  final newScale = newWidth / widget.baseWidth;
                  final clampedScale = _clampScale(newScale);

                  // Calculate new dimensions
                  final finalWidth = widget.baseWidth * clampedScale;
                  final finalHeight = finalWidth * 0.5;

                  // Calculate old dimensions
                  final oldWidth = widget.baseWidth * _currentScale;
                  final oldHeight = oldWidth * 0.5;

                  // Adjust position to keep bottom-right corner fixed
                  final newPosition = Offset(
                    _currentPosition.dx + (oldWidth - finalWidth),
                    _currentPosition.dy + (oldHeight - finalHeight),
                  );

                  final clampedPosition = _clampPosition(
                    newPosition,
                    finalWidth,
                    finalHeight,
                  );

                  setState(() {
                    _currentScale = clampedScale;
                    _currentPosition = clampedPosition;
                  });

                  widget.onScaleChanged(clampedScale);
                  widget.onPositionChanged(clampedPosition);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                          topLeft: Radius.circular(4))),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
            // Bottom-left: Clear button
            Positioned(
              left: 0,
              bottom: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onClear,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          topRight: Radius.circular(4))),
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
