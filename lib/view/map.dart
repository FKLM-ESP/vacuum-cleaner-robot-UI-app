import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../comms/interface.dart';
import '../utils/my_painter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late List<Pair<int, int>> _points;
  final Interface _interface = Interface();

  @override
  initState() {
    super.initState();
    _interface.sendPointsToMap = () => setState(() {
          _points = _interface.points;
          if (kDebugMode) {
            print("Setting new state");
          }
        });
    _points = _interface.points;
  }

  @override
  Widget build(BuildContext context) {
    var myPainter = CustomPaint(
      painter: MyPainter(_points),
    );

    return myPainter;
  }
}
