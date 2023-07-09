import 'package:app/comms/interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConnectionIndicator extends StatefulWidget {
  const ConnectionIndicator({Key? key}) : super(key: key);

  @override
  ConnectionIndicatorState createState() => ConnectionIndicatorState();
}

class ConnectionIndicatorState extends State<ConnectionIndicator> {
  late bool connected;
  final Interface _interface = Interface();

  @override
  void initState() {
    super.initState();

    _interface.sendConnectionStatus = () {
      setState(() {
        connected = _interface.isConnected;
      });
      if (kDebugMode) {
        print("Setting new connection status");
      }
    };

    connected = _interface.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text((connected) ? '🟢' : '🔴'),
      ],
    );
  }
}
