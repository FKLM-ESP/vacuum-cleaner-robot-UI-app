import 'dart:io';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/foundation.dart';

class Interface {
  static const forward = 1;
  static const right = 2;
  static const backward = 3;
  static const left = 4;

  static const port = 9000;

  late void Function() sendPointsToMap;
  List<Pair<int, int>> points = [];

  late void Function() sendBattery;
  int batteryCharge = 0;

  Socket? socket;

  static final Interface _instance = Interface._internal();

  factory Interface() {
    return _instance;
  }

  Interface._internal() {
    ServerSocket.bind(InternetAddress.anyIPv4, port)
        .then((ServerSocket server) {
      server.listen((Socket client) {
        if (kDebugMode) {
          print("Set new connection socket");
        }
        socket = client;
        socket?.listen(handleMessage);
      }, onDone: () {
        socket = null;
        batteryCharge = 0;
        points = [];
        if (kDebugMode) {
          print("Connection closed by robot");
        }
      }, onError: (error) {
        socket = null;
        batteryCharge = 0;
        points = [];
        if (kDebugMode) {
          print("Connection closed by robot");
        }
      });
    });
  }

  void handleMessage(Uint8List message) {
    // message is composed of 1/2 Byte(s) representing the battery charge as an int
    // then a list of groups of 4 bytes, each representing one coordinate of a point
    // Thus message[0] is the battery charge. Then, message[1:5] is the x coordinate
    // of the starting point, message[5:9] is the y coordinate of the starting point
    // and so on.

    int nBytesBattery = 1;
    int nBytesCoordinate = 4;

    batteryCharge = message.buffer
        .asByteData()
        .getInt8(0); // change function when changing nBytesBattery

    sendBattery();

    List<int> newPointsSingle = [];

    for (int i = 0; i < message.length - 1; i += nBytesCoordinate) {
      newPointsSingle.add(message.buffer.asByteData().getInt32(
          nBytesBattery + i)); // change function when changing nBytesCoordinate
    }

    List<Pair<int, int>> newPointsPair = [];

    for (int i = 0; i < newPointsSingle.length; i += 2) {
      newPointsPair.add(Pair(newPointsSingle[i], newPointsSingle[i + 1]));
    }

    points = newPointsPair;

    sendPointsToMap();

    if (kDebugMode) {
      print("Received message:\n$batteryCharge\n$points");
    }
  }

  void sendMode(bool autoMode) {
    if (kDebugMode) {
      print("Sent autoMode $autoMode");
    }
    socket?.write("auto $autoMode");
  }

  void sendFan(bool fanMode) {
    if (kDebugMode) {
      print("Sent fanMode $fanMode");
    }
    socket?.write("fan $fanMode");
  }

  void sendMovement(int direction, bool start) {
    if (kDebugMode) {
      print("Sent movement $direction $start");
    }
    socket?.write("move $direction $start");
  }
}
