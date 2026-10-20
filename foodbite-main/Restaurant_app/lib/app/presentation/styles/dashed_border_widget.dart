/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

import 'package:flutter/material.dart';

class InvoiceDividerDashedLine extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpace;
  final Color color;

  const InvoiceDividerDashedLine({
    super.key,
    this.height = 0.4,
    this.dashWidth = 3,
    this.dashSpace = 3,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _InvoiceDividerDashedLinePainter(
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        height: height,
        color: color,
      ),
    );
  }
}

class _InvoiceDividerDashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final double height;
  final Color color;

  _InvoiceDividerDashedLinePainter({
    required this.dashWidth,
    required this.dashSpace,
    required this.height,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = height;

    double startX = 0;
    final maxX = size.width;

    while (startX < maxX) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
