import 'package:app/comms/interface.dart';
import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BatteryMonitor extends StatefulWidget {
  const BatteryMonitor({Key? key}) : super(key: key);

  @override
  BatteryMonitorState createState() => BatteryMonitorState();
}

class BatteryMonitorState extends State<BatteryMonitor> {
  late int _percentage;
  final Interface _interface = Interface();

  @override
  void initState() {
    super.initState();
    _interface.sendBattery = () => setState(() {
          _percentage = _interface.batteryCharge;
          if (kDebugMode) {
            print("Setting new battery charge");
          }
        });
    _percentage = _interface.batteryCharge;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$_percentage% '),
        BatteryIndicator(
          batteryFromPhone: false,
          batteryLevel: _percentage,
          style: BatteryIndicatorStyle.values[1],
          showPercentNum: false,
          showPercentSlide: true,
          size: 18,
          colorful: true,
          ratio: 2,
        ),
      ],
    );
  }
}
