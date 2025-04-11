import 'package:flutter/material.dart';

class CurvedBackgroundDecoration extends StatelessWidget {
  final double radius;
  final double strokeWidth;

  const CurvedBackgroundDecoration({
    Key? key,
    this.radius = 150,
    this.strokeWidth = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _CurvedBackgroundPainter(radius, strokeWidth),
    );
  }
}

class _CurvedBackgroundPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;

  _CurvedBackgroundPainter(this.radius, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paintGray = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final paintRed = Paint()
      ..color = Colors.red
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(60, 0), radius: radius),
      0,
      3.16,
      false,
      paintGray,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width, 0), radius: radius),
      0,
      3.14,
      false,
      paintRed,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
