import 'package:analyzer_plugin/utilities/pair.dart';

class Interface {
  static const forward = 1;
  static const right = 2;
  static const backward = 3;
  static const left = 4;

  static List<Pair<double, double>> getCoords() {
    return [
      Pair(0, 0),
      Pair(-100, 0),
      Pair(-100, -100),
      Pair(0, -100),
      Pair(-50, -50),
      Pair(-50, 0),
      Pair(0, -50),
      Pair(35, 35),
    ];
  }

  static void sendMode(bool autoMode) {
    print("Sent autoMode $autoMode");
    return;
  }

  static void sendFan(bool fanMode) {
    print("Sent fanMode $fanMode");
    return;
  }

  static void sendMovement(int direction, bool start) {
    print("Sent movement $direction $start");
    return;
  }
}
