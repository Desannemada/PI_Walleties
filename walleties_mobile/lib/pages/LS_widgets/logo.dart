import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/main_view_model.dart';

class Logo extends StatelessWidget {
  Logo(this.scale);
  final double scale;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/logo.png",
          scale: scale,
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
