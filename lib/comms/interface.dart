import 'dart:io';

import 'package:analyzer_plugin/utilities/pair.dart';
import 'package:flutter/foundation.dart';

class Interface {
  static const stateStop = 0x00; // 0000 0000
  static const stateForward = 0x01; // 0000 0001
  static const stateBackward = 0x02; // 0000 0010
  static const stateLeft = 0x04; // 0000 0100
  static const stateRight = 0x08; // 0000 1000
  static const autoOn = 0x30; // 0011 0000
  static const autoOff = 0x20; // 0010 0000
  static const fanOn = 0xC0; // 1100 0000
  static const fanOff = 0x80; // 1000 0000
  static const testMode = 0xFF; // 1111 1111

  static const port = 9000;

  void Function() sendPointsToMap = () {};
  List<Pair<int, int>> points = [];

  void Function() sendBattery = () {};
  int batteryCharge = 0;

  void Function() sendImuValues = () {};
  List<double> imuValues = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  void Function() sendlogStrings = () {};
  List<String> logStrings = [];

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
        imuValues = [0, 0, 0, 0, 0, 0, 0, 0, 0];
        if (kDebugMode) {
          print("Connection closed by robot");
        }
      }, onError: (error) {
        socket = null;
        batteryCharge = 0;
        points = [];
        imuValues = [0, 0, 0, 0, 0, 0, 0, 0, 0];
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
    int nBytesImu = 4;

    var msgByteData = message.buffer.asByteData();

    switch (String.fromCharCode(message[0])) {
      case 'b':
        {
          if (message.lengthInBytes != 1 + nBytesBattery) {
            return;
          }

          // change conversion function when changing nBytesBattery
          batteryCharge = msgByteData.getInt8(1);
          sendBattery();
        }
        break;

      case 'i':
        {
          if (message.lengthInBytes != (1 + nBytesImu * 9)) {
            return;
          }

          if (kDebugMode) {
            print(message);
          }

          List<double> newImuValues = [];

          for (int i = 1; i < message.length - 1; i += nBytesImu) {
            // change conversion function when changing nBytesCoordinate
            newImuValues.add((msgByteData.getInt32(i)) / 10000);
          }

          imuValues = newImuValues;
          sendImuValues();

          if (kDebugMode) {
            print(imuValues);
          }
        }
        break;

      case 'c':
        {
          if ((message.lengthInBytes - 1) % (2 * nBytesCoordinate) != 0) {
            return;
          }
          if (kDebugMode) {
            print(message);
          }

          List<int> newPointsSingle = [];

          for (int i = 1; i < message.length - 1; i += nBytesCoordinate) {
            // change conversion function when changing nBytesCoordinate
            newPointsSingle.add(msgByteData.getInt32(i));
          }

          List<Pair<int, int>> newPointsPairs = [];

          for (int i = 0; i < newPointsSingle.length; i += 2) {
            newPointsPairs
                .add(Pair(newPointsSingle[i], -newPointsSingle[i + 1]));
          }

          points = newPointsPairs;

          sendPointsToMap();
        }

        break;

      case 'l':
        var timeString =
            DateTime.now().toIso8601String().split("T")[1].split(".")[0];
        logStrings
            .add("$timeString - ${String.fromCharCodes(message).substring(1)}");

        sendlogStrings();

        break;
    }
  }

  void sendMode(bool autoMode) {
    var message = Uint8List(1);
    var bytedata = ByteData.view(message.buffer);

    if (autoMode) {
      bytedata.setUint8(0, autoOn);
    } else {
      bytedata.setUint8(0, autoOff);
    }

    if (kDebugMode) {
      print("Sent autoMode $autoMode");
    }
    socket?.add(message);
  }

  void sendFan(bool fanMode) {
    var message = Uint8List(1);
    var bytedata = ByteData.view(message.buffer);

    if (fanMode) {
      bytedata.setUint8(0, fanOn);
    } else {
      bytedata.setUint8(0, fanOff);
    }

    if (kDebugMode) {
      print("Sent fanMode $fanMode");
    }
    socket?.add(message);
  }

  void sendMovement(int direction, bool start) {
    var message = Uint8List(1);
    var bytedata = ByteData.view(message.buffer);

    if (!start) {
      bytedata.setUint8(0, stateStop);
    } else {
      bytedata.setUint8(0, direction);
    }
    if (kDebugMode) {
      print("Sent movement $direction $start");
    }
    socket?.add(message);
  }

  void sendTestRoutine() {
    var message = Uint8List(1);
    var bytedata = ByteData.view(message.buffer);

    bytedata.setUint8(0, testMode);

    if (kDebugMode) {
      print("Initiated test routine");
    }
    socket?.add(message);
  }
}
