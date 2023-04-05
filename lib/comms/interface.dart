import 'dart:async';
import 'dart:math';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/foundation.dart';

class Interface {
  static const forward = 1;
  static const right = 2;
  static const backward = 3;
  static const left = 4;

  late void Function() sendPointsToMap;
  List<Pair<double, double>> points = [];
  Timer? timer;

  static final Interface _instance = Interface._internal();

  factory Interface() {
    return _instance;
  }

  Interface._internal() {
    // Remove and initialize sockets and listeners
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      points = await getCoords();
      sendPointsToMap();
      if (kDebugMode) {
        print("Updated points on map");
      }
    });
  }

  Future<List<Pair<double, double>>> getCoords() async {
    var rng = Random();
    return List<Pair<double, double>>.generate(
        10, (i) => Pair(rng.nextDouble() * 50, rng.nextDouble() * 50));
  }

  void sendMode(bool autoMode) {
    if (kDebugMode) {
      print("Sent autoMode $autoMode");
    }
    return;
  }

  void sendFan(bool fanMode) {
    if (kDebugMode) {
      print("Sent fanMode $fanMode");
    }
    return;
  }

  void sendMovement(int direction, bool start) {
    if (kDebugMode) {
      print("Sent movement $direction $start");
    }
    return;
  }
}
