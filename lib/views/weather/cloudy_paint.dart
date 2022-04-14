import 'package:flutter/material.dart';

class Cloud {
  double dx;
  double dy;

  Cloud(this.dx, this.dy);
}

class CloudyPainter extends CustomPainter {
  List<Cloud> cloudy;

  double maskAlpha;

  CloudyPainter(this.cloudy, this.maskAlpha);

  Paint cloudPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.white38;

  Paint sunPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xE6E8CF2D);

  Paint maskPaint = Paint()..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    sunPaint.color = Color.fromARGB((230 * maskAlpha).toInt(), 232, 207, 45);

    cloudPaint.color = Color.fromARGB((98 * maskAlpha).toInt(), 255, 255, 255);

    canvas.drawCircle(
        Offset(
            width - 60 - cloudy.elementAt(0).dx, 120 + cloudy.elementAt(0).dy),
        100,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 2 - cloudy.elementAt(1).dx, 20 - cloudy.elementAt(1).dy),
        170,
        cloudPaint);

    canvas.drawCircle(Offset(width / 5 * 3, 140), 50, sunPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 + cloudy.elementAt(2).dx,
            -20 - cloudy.elementAt(2).dy),
        170,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 3.6 - 10 + cloudy.elementAt(3).dx,
            -50 + cloudy.elementAt(3).dy),
        170,
        cloudPaint);

    canvas.drawCircle(
        Offset(10 + cloudy.elementAt(4).dx, -30 + cloudy.elementAt(4).dy),
        180,
        cloudPaint);

    canvas.drawCircle(
        Offset(35 - cloudy.elementAt(5).dx, -110 + cloudy.elementAt(5).dy),
        160,
        cloudPaint);

    canvas.drawCircle(
        Offset(width / 5 * 1.5 + cloudy.elementAt(6).dx,
            -40 - cloudy.elementAt(6).dy),
        210,
        cloudPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
