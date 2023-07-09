import 'package:flutter/material.dart';

import '../comms/interface.dart';
import '../widgets/custom_button.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({Key? key}) : super(key: key);

  @override
  ControlPanelState createState() => ControlPanelState();
}

class ControlPanelState extends State<ControlPanel> {
  bool isAutoMode = false;
  bool isFanOn = false;

  final Interface _interface = Interface();

  Future<void> _toggleMode(value) async {
    // Send command only when value changes
    if (value != isAutoMode) {
      _interface.sendMode(value);
    }
    // store
    isAutoMode = value;
  }

  Future<void> _toggleFan(value) async {
    // Send command only when value changes
    if (value != isFanOn) {
      _interface.sendFan(value);
    }
    // store
    isFanOn = value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          icon: "<",
          onTapDown: () {
            _interface.sendMovement(Interface.stateLeft, true);
          },
          onTapUp: () {
            _interface.sendMovement(Interface.stateLeft, false);
          },
        ),
        Column(
          children: [
            CustomButton(
              icon: "^",
              onTapDown: () {
                _interface.sendMovement(Interface.stateForward, true);
              },
              onTapUp: () {
                _interface.sendMovement(Interface.stateForward, false);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              icon: "⌄",
              onTapDown: () {
                _interface.sendMovement(Interface.stateBackward, true);
              },
              onTapUp: () {
                _interface.sendMovement(Interface.stateBackward, false);
              },
            ),
          ],
        ),
        CustomButton(
          icon: ">",
          onTapDown: () {
            _interface.sendMovement(Interface.stateRight, true);
          },
          onTapUp: () {
            _interface.sendMovement(Interface.stateRight, false);
          },
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Text("Automatic\nmode", textAlign: TextAlign.center),
                Switch(
                  value: isAutoMode,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    setState(() {
                      _toggleMode(value);
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Text("Fan"),
                Switch(
                  value: isFanOn,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    setState(() {
                      _toggleFan(value);
                    });
                  },
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
