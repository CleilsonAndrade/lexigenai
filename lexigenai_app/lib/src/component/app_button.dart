import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String title;
  Function() onPressed;

  AppButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: const Size(220, 45),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 27,
          ),
        ));
  }
}
