import 'package:flutter/material.dart';

import '../comms/interface.dart';
import '../widgets/custom_button.dart';

class ControlPanel extends StatefulWidget {
  final Interface interface;

  const ControlPanel({Key? key, required this.interface}) : super(key: key);

  @override
  ControlPanelState createState() => ControlPanelState();
}

class ControlPanelState extends State<ControlPanel> {
  bool isAutoMode = true;
  bool isFanOn = true;

  Future<void> _toggleMode(value) async {
    // Send command only when value changes
    if (value != isAutoMode) {
      widget.interface.sendMode(value);
    }
    // store
    isAutoMode = value;
  }

  Future<void> _toggleFan(value) async {
    // Send command only when value changes
    if (value != isFanOn) {
      widget.interface.sendFan(value);
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
              widget.interface.sendMovement(Interface.left, true);
            },
            onTapUp: () {
              widget.interface.sendMovement(Interface.left, false);
            }),
        Column(
          children: [
            CustomButton(
                icon: "^",
                onTapDown: () {
                  widget.interface.sendMovement(Interface.forward, true);
                },
                onTapUp: () {
                  widget.interface.sendMovement(Interface.forward, false);
                }),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
                icon: "⌄",
                onTapDown: () {
                  widget.interface.sendMovement(Interface.backward, true);
                },
                onTapUp: () {
                  widget.interface.sendMovement(Interface.backward, false);
                }),
          ],
        ),
        CustomButton(
            icon: ">",
            onTapDown: () {
              widget.interface.sendMovement(Interface.right, true);
            },
            onTapUp: () {
              widget.interface.sendMovement(Interface.right, false);
            }),
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
