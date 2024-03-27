import 'package:flutter/material.dart';

class backButton extends StatelessWidget {
  final VoidCallback onClick;

  const backButton({super.key, required this.onClick});
  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: AlignmentDirectional.topStart,
      child: IconButton(
        onPressed: onClick ,
        icon: const Icon(Icons.arrow_back_ios_new_outlined,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}