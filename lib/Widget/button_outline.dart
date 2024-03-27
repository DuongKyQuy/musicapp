import 'package:flutter/material.dart';

class ButtonOutlineWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  const ButtonOutlineWidget({super.key, required this.text, required this.onClick});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.black,
          // side: BorderSide(color: Colors.white, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white,
              fontWeight: FontWeight.bold),
        ));
  }
}
