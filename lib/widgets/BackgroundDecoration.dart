import 'dart:math' as math;
import 'package:flutter/material.dart';

class CurvedBackgroundDecoration extends StatefulWidget {
  final double radius;
  final double strokeWidth;

  const CurvedBackgroundDecoration({
    super.key,
    this.radius = 205,
    this.strokeWidth = 2.5,
  });

  @override
  State<CurvedBackgroundDecoration> createState() =>
      _CurvedBackgroundDecorationState();
}

class _CurvedBackgroundDecorationState extends State<CurvedBackgroundDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), 
      vsync: this,
    )..repeat(); 

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear, // حركة ناعمة
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _CurvedBackgroundPainter(
            widget.radius,
            widget.strokeWidth,
            _animation.value,
          ),
        );
      },
    );
  }
}

class _CurvedBackgroundPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final double animationValue;

  _CurvedBackgroundPainter(this.radius, this.strokeWidth, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paintGray = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = strokeWidth * 1.2
      ..style = PaintingStyle.stroke;

    final paintRed = Paint()
      ..color = Colors.red
      ..strokeWidth = strokeWidth * 2
      ..style = PaintingStyle.stroke;

    final sweepFactor = (math.sin(animationValue) + 1) / 2;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2.5, -radius / 6),
        radius: radius * 1.2,
      ),
      math.pi / 4.4,
      (math.pi / 3.2) * sweepFactor,
      false,
      paintGray,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(-radius * 0.3, radius * 0.2),
        radius: radius * 1.2,
      ),
      -math.pi / 2,
      math.pi * sweepFactor,
      false,
      paintRed,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width + radius * 0.2, -radius * 0.2),
        radius: radius / 1.1,
      ),
      math.pi / 2,
      (math.pi / 2) * sweepFactor,
      false,
      paintRed,
    );
  }

  @override
  bool shouldRepaint(_CurvedBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
