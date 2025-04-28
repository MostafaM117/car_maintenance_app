import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CustomPopup extends StatefulWidget {
  final String title;
  final String message;
  final Duration duration;
  final VoidCallback? onComplete;

  const CustomPopup({
    Key? key,
    required this.title,
    required this.message,
    this.duration = const Duration(seconds: 2),
    this.onComplete,
  }) : super(key: key);

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _zoomController,
      curve: Curves.easeInOutCubic,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );

    _zoomController.forward();
    _fadeController.forward();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    Future.delayed(widget.duration, () {
      Navigator.of(context).pop();
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildPopupContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupContent() {
    return Container(
      width: 320,
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryText,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ..._buildOrbitingCircles(8, 100),
          Container(
            height: 200,
            width: 200,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrbitingCircles(int count, double radius) {
    return List.generate(count, (index) {
      final angle = 2 * pi * index / count;

      return AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          final rotationAngle = angle + _rotationController.value * 2 * pi;

          return Transform.translate(
            offset: Offset(
              radius * cos(rotationAngle),
              radius * sin(rotationAngle),
            ),
            child:
                index % 2 == 0 ? _buildFilledCircle() : _buildOutlinedCircle(),
          );
        },
      );
    });
  }

  Widget _buildFilledCircle() {
    return Container(
      width: 16,
      height: 16,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildOutlinedCircle() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryText, width: 2),
        color: Colors.transparent,
      ),
    );
  }
}
