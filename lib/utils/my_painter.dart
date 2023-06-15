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

    var deltaX = (maxX - minX) * 1.1;
    var deltaY = (maxY - minY) * 1.1;

    var allPositiveCoords = points
        .map((e) =>
            Pair<double, double>((e.first - minX) / 1.0, (e.last - minY) / 1.0))
        .toList();

    var xScale = deltaX / size.width;
    var yScale = deltaY / size.height;

    double scale;

    if (xScale > yScale) {
      scale = xScale;
    } else {
      scale = yScale;
    }

    var newCoords = allPositiveCoords
        .map((e) => Offset(e.first / scale + 10, e.last / scale + 10))
        .toList();

    var startPaint = Paint()..color = Colors.green;
    var posPaint = Paint()..color = Colors.blue;
    var hitPaint = Paint()..color = Colors.red;
    const pointMode = PointMode.polygon;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, newCoords, paint);
    newCoords.forEachIndexed(
      (element, index) {
        if (index == 0) {
          canvas.drawCircle(newCoords[0], 10, startPaint);
        } else if (index == newCoords.length - 1) {
          canvas.drawCircle(newCoords[index], 10, posPaint);
        } else {
          canvas.drawCircle(newCoords[index], 10, hitPaint);
        }
      },
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
