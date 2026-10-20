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
import 'package:qr/qr.dart';

class QrCodeGenerator extends StatelessWidget {
  final String qrData;
  const QrCodeGenerator({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    final qrCode = QrCode(7, QrErrorCorrectLevel.L);
    qrCode.addData(qrData);
    final qrImage = QrImage(qrCode);
    return CustomPaint(
      size: const Size.square(200),
      painter: QrPainter(qrImage),
    );
  }
}

class QrPainter extends CustomPainter {
  final QrImage qr;

  QrPainter(this.qr);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final moduleCount = qr.moduleCount;
    final moduleSize = size.width / moduleCount;

    for (int x = 0; x < moduleCount; x++) {
      for (int y = 0; y < moduleCount; y++) {
        if (qr.isDark(y, x)) {
          final rect = Rect.fromLTWH(
            x * moduleSize,
            y * moduleSize,
            moduleSize,
            moduleSize,
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
