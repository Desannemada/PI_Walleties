import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';

class MeuCartao extends StatelessWidget {
  final option;

  MeuCartao({@required this.option});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                lightGreen,
                option[2],
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
                        option[1].toUpperCase(),
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
                            child: CardTexts(index: 1, option: option),
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CardTexts(
                              index: 2,
                              name: "VALIDO ATÉ",
                              option: option,
                            ),
                            SizedBox(width: 30),
                            CardTexts(
                              index: 3,
                              name: "CVV",
                              option: option,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        CardTexts(index: 0, option: option),
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
  final option;
  CardTexts({@required this.index, this.name, @required this.option});

  @override
  _CardTextsState createState() => _CardTextsState();
}

class _CardTextsState extends State<CardTexts> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

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
                      fontSize: 8,
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
          onHover: (hover) {
            if (hover) {
              setState(() {
                hovering = true;
              });
            } else {
              setState(() {
                hovering = false;
              });
            }
          },
          onTap: () {},
          child: Text(
            fmodel.userCards[widget.option[0] - 1][widget.index]
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
