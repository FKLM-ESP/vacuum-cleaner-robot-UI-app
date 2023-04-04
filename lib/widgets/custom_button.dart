import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onTapDown;
  final void Function() onTapUp;
  final String icon;

  const CustomButton(
      {Key? key,
      required this.onTapDown,
      required this.onTapUp,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        onTapDown();
      },
      onTapUp: (details) {
        onTapUp();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            icon,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
