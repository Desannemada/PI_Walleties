import 'package:flutter/material.dart';
import 'package:walleties_mobile/colors/colors.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/logo.png",
          scale: 8,
        ),
        SizedBox(width: 20),
        Text(
          "Walleties",
          style: TextStyle(
            color: darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        )
      ],
    );
  }
}
