import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../comms/interface.dart';
import '../utils/my_painter.dart';

class MapView extends StatefulWidget {
  final Interface interface;

  const MapView({Key? key, required this.interface}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late List<Pair<double, double>> _points;

  @override
  initState() {
    super.initState();
    _points = widget.interface.points;
  }

  @override
  Widget build(BuildContext context) {
    widget.interface.sendPointsToMap = () => setState(() {
          _points = widget.interface.points;
          if (kDebugMode) {
            print("setting new state");
          }
        });

    var myPainter = CustomPaint(
      painter: MyPainter(_points),
    );

    return myPainter;
  }
}
