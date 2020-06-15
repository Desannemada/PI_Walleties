import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:walleties_mobile/models/account_model.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/fatura_info.dart';
import 'package:walleties_mobile/pages/HS_widgets/geral_card_info.dart';
import 'package:walleties_mobile/pages/HS_widgets/my_card.dart';

class AbaCartao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    // final amodel = Provider.of<AccountModel>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 15),
          MeuCartao(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                2,
                (index) => Row(
                  children: [
                    Text(
                      index == 0 ? "Agência" : "Conta",
                      style: TextStyle(
                        color: model.currentOption[2].withOpacity(0.5),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    InfoTexts(
                      text: index == 0
                          ? model.userCards[model.currentOption[0] - 1][5]
                          : model.userCards[model.currentOption[0] - 1][6],
                      hover: true,
                      size: 18,
                      weight: FontWeight.w600,
                      shadows: false,
                      color: model.currentOption[2],
                      type: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GeralCardInfo(),
          FaturaInfo(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class InfoTexts extends StatefulWidget {
  InfoTexts({
    @required this.shadows,
    @required this.text,
    @required this.size,
    @required this.hover,
    @required this.type,
    this.weight,
    this.color,
  });

  final bool shadows;
  final String text;
  final double size;
  final bool hover;
  final FontWeight weight;
  final Color color;
  final int type;

  @override
  _InfoTextsState createState() => _InfoTextsState();
}

class _InfoTextsState extends State<InfoTexts> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return InkWell(
      onTap: () {
        if (widget.type == 0) {
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
        }
      },
      child: Text(
        widget.text,
        style: TextStyle(
          color: (widget.type == 0 ? hovering : model.isTapped) || !widget.hover
              ? widget.color != null ? widget.color : Colors.white
              : Colors.transparent,
          shadows: (widget.type == 0 ? !hovering : !model.isTapped) &&
                      widget.hover ||
                  !widget.shadows
              ? null
              : [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
          fontSize: widget.size,
          fontWeight: widget.weight != null ? widget.weight : FontWeight.normal,
          backgroundColor:
              (widget.type == 0 ? hovering : model.isTapped) || !widget.hover
                  ? Colors.transparent
                  : widget.color,
        ),
      ),
    );
  }
}
