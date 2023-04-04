import 'package:flutter/material.dart';

import '../comms/interface.dart';
import '../widgets/custom_button.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  ControlButtonsState createState() => ControlButtonsState();
}

class ControlButtonsState extends State<ControlButtons> {
  bool isAutoMode = true;
  bool isFanOn = true;

  Future<void> _toggleMode(value) async {
    // Send command only when value changes
    if (value != isAutoMode) {
      Interface.sendMode(value);
    }
    // store
    isAutoMode = value;
  }

  Future<void> _toggleFan(value) async {
    // Send command only when value changes
    if (value != isFanOn) {
      Interface.sendFan(value);
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
              Interface.sendMovement(Interface.left, true);
            },
            onTapUp: () {
              Interface.sendMovement(Interface.left, false);
            }),
        Column(
          children: [
            CustomButton(
                icon: "^",
                onTapDown: () {
                  Interface.sendMovement(Interface.forward, true);
                },
                onTapUp: () {
                  Interface.sendMovement(Interface.forward, false);
                }),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
                icon: "⌄",
                onTapDown: () {
                  Interface.sendMovement(Interface.backward, true);
                },
                onTapUp: () {
                  Interface.sendMovement(Interface.backward, false);
                }),
          ],
        ),
        CustomButton(
            icon: ">",
            onTapDown: () {
              Interface.sendMovement(Interface.right, true);
            },
            onTapUp: () {
              Interface.sendMovement(Interface.right, false);
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
