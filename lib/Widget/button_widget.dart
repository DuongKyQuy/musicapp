import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  const ButtonWidget({super.key, required this.text, required this.onClick});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor:  Colors.white,
          side: const BorderSide(color: Colors.white, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.black,
             ),
        ));
  }
}
