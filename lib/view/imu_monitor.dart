import 'package:app/comms/interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImuMonitor extends StatefulWidget {
  const ImuMonitor({Key? key}) : super(key: key);

  @override
  ImuMonitorState createState() => ImuMonitorState();
}

class ImuMonitorState extends State<ImuMonitor> {
  late List<double> _values;
  final Interface _interface = Interface();

  @override
  void initState() {
    super.initState();

    _interface.sendImuValues = () {
      setState(() {
        _values = _interface.imuValues;
      });
      if (kDebugMode) {
        print("Setting new IMU values");
      }
    };

    _values = _interface.imuValues;
  }

  @override
  Widget build(BuildContext context) {
    var s = _values.map((e) => e.toStringAsFixed(4)).toList();

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Mag:",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[0],
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[1],
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[2],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Gyr:",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[3],
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[4],
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[5],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                "Acc:",
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[6],
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[7],
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                s[8],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
