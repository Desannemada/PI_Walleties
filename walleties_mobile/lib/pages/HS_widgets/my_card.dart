import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/main_view_model.dart';

class MeuCartao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                lightGreen,
                model.currentOption[2],
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        model.currentOption[1].toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: CardTexts(
                              index: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CardTexts(
                              index: 2,
                              name: "VALIDO ATÉ",
                            ),
                            SizedBox(width: 30),
                            CardTexts(
                              index: 3,
                              name: "CVV",
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        CardTexts(
                          index: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardTexts extends StatefulWidget {
  final index;
  final name;
  CardTexts({@required this.index, this.name});

  @override
  _CardTextsState createState() => _CardTextsState();
}

class _CardTextsState extends State<CardTexts> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.index == 2 || widget.index == 3
            ? Padding(
                padding: EdgeInsets.only(right: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        InkWell(
          onTap: () {
            setState(() {
              hovering = !hovering;
            });
            if (hovering) {
              Timer(Duration(seconds: 10), () {
                setState(() {
                  hovering = false;
                });
              });
            }
          },
          child: Text(
            model.userCards[model.currentOption[0] - 1][widget.index]
                .replaceAll("-", " "),
            style: TextStyle(
              color: hovering ? Colors.white : Colors.transparent,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
              shadows: !hovering
                  ? null
                  : [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
              backgroundColor:
                  hovering ? Colors.transparent : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
