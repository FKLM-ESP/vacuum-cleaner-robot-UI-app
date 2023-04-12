import 'dart:ui';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:dart_extensions_methods/dart_extension_methods.dart' as ext;
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  List<Pair<int, int>> points;

  MyPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (size == const Size(0, 0)) {
      return;
    }

    var minX = 0, maxX = 0, minY = 0, maxY = 0;
    for (var c in points) {
      if (c.first < minX) {
        minX = c.first;
      }
      if (c.first > maxX) {
        maxX = c.first;
      }
      if (c.last < minY) {
        minY = c.last;
      }
      if (c.last > maxY) {
        maxY = c.last;
      }
    }

    var deltaX = maxX - minX;
    var deltaY = maxY - minY;

    var xScale = deltaX / size.width;
    var yScale = deltaY / size.height;

    double scale, xOffset, yOffset;

    if (xScale > yScale) {
      scale = xScale;
      xOffset = (-minX).toDouble();
      yOffset = -minY + (size.height * scale - deltaY) / 2;
    } else {
      scale = yScale;
      xOffset = -minX + (size.width * scale - deltaX) / 2;
      yOffset = (-minY).toDouble();
    }

    var newCords = points
        .map((e) =>
            Offset((e.first + xOffset) / scale, (e.last + yOffset) / scale))
        .toList();

    var startPaint = Paint()..color = Colors.green;
    var posPaint = Paint()..color = Colors.blue;
    var hitPaint = Paint()..color = Colors.red;
    const pointMode = PointMode.polygon;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, newCords, paint);
    newCords.forEachIndexed(
      (element, index) {
        if (index == 0) {
          canvas.drawCircle(newCords[0], 10, startPaint);
        } else if (index == newCords.length - 1) {
          canvas.drawCircle(newCords[index], 10, posPaint);
        } else {
          canvas.drawCircle(newCords[index], 10, hitPaint);
        }
      },
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
