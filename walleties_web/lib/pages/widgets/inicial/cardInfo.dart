import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/widgets/inicial/cardInfo/ChooseInfoFatura.dart';
import 'package:walleties/pages/widgets/inicial/cardInfo/CreditoDebitoInfo.dart';
import 'package:walleties/pages/widgets/inicial/cardInfo/MeuCartao.dart';

class CardInfo extends StatelessWidget {
  final int type;

  CardInfo({this.type});

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);

    String getPath(int i, int index) {
      double result = 0;
      if (index == 0) {
        result = double.parse(
            fmodel.userCards[i][8].replaceAll('.', '').replaceAll(',', '.'));
      } else if (index == 1) {
        for (var compra in fmodel.faturaCredito) {
          if (compra['name_bank'] == fmodel.userCards[i][4]) {
            result = result +
                double.parse(
                    compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
          }
        }
      } else if (index == 2) {
        result = double.parse(fmodel.userCards[i][9]
                .replaceAll('.', '')
                .replaceAll(',', '.')) -
            (double.parse(fmodel.userCards[i][9]
                    .replaceAll('.', '')
                    .replaceAll(',', '.')) -
                double.parse(fmodel.userCards[i][8]
                    .replaceAll('.', '')
                    .replaceAll(',', '.')));
      }
      return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
          .format(result);
    }

    List<Shadow> shadows = [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black,
        offset: Offset(2.0, 2.0),
      ),
    ];

    return Container(
      height: MediaQuery.of(context).size.height - (type != 2 ? 70 : 120),
      color: Colors.white.withOpacity(0.3),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width -
                (type != 2 ? model.isDrawerOpen ? 250 : 0 : 0) -
                (type != 0 ? 0 : 520),
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 30),
                ChooseInfoFatura(),
                SizedBox(height: 30),
                CreditoDebitoInfo(type: type),
                SizedBox(height: 30),
              ],
            ),
          ),
          type == 0
              ? Container(
                  width: 520,
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.zero,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(155),
                        bottomLeft: Radius.circular(35),
                      ),
                    ),
                    child: Container(
                      color: fmodel.currentOption[2],
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      height: double.infinity,
                      alignment: Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: ListView(
                          children: <Widget>[
                            SizedBox(height: 30),
                            MeuCartao(option: fmodel.currentOption),
                            SizedBox(height: 30),
                            Card(
                              elevation: 5,
                              color: Colors.transparent,
                              child: Container(
                                color: Colors.white.withOpacity(0.4),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                "AGENCIA",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  shadows: shadows,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              InfoTexts(
                                                text: fmodel.userCards[fmodel
                                                            .currentOption[0] -
                                                        1][5] +
                                                    " ",
                                                hover: true,
                                                size: 16,
                                                weight: FontWeight.w600,
                                                shadows: true,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                "CONTA",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  shadows: shadows,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              InfoTexts(
                                                text: fmodel.userCards[fmodel
                                                            .currentOption[0] -
                                                        1][6] +
                                                    " ",
                                                hover: true,
                                                size: 16,
                                                weight: FontWeight.w600,
                                                shadows: true,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    InfoTexts(
                                      text: "Informações Gerais",
                                      size: 16,
                                      hover: false,
                                      shadows: false,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InfoTexts(
                                          text: "Saldo",
                                          size: 16,
                                          hover: false,
                                          shadows: false,
                                        ),
                                        InfoTexts(
                                          text: getPath(
                                              fmodel.currentOption[0] - 1, 0),
                                          size: 18,
                                          hover: true,
                                          weight: FontWeight.bold,
                                          color: darkGreen,
                                          shadows: false,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InfoTexts(
                                          text: "Fatura Atual",
                                          size: 14,
                                          hover: false,
                                          shadows: false,
                                        ),
                                        InfoTexts(
                                          text: getPath(
                                                  fmodel.currentOption[0] - 1,
                                                  1) +
                                              " ",
                                          size: 16,
                                          hover: false,
                                          weight: FontWeight.bold,
                                          color: darkGreen,
                                          shadows: false,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InfoTexts(
                                        text: "Faturas Passadas",
                                        size: 16,
                                        hover: false,
                                        weight: FontWeight.bold,
                                        color: fmodel.currentOption[2],
                                        shadows: false,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InfoTexts(
                                          text: "Março 2020",
                                          size: 14,
                                          hover: false,
                                          shadows: false,
                                        ),
                                        InfoTexts(
                                          text: "NA" + " ",
                                          size: 16,
                                          hover: false,
                                          weight: FontWeight.bold,
                                          shadows: false,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InfoTexts(
                                        text: "Próximas Faturas",
                                        size: 16,
                                        hover: false,
                                        weight: FontWeight.bold,
                                        color: fmodel.currentOption[2],
                                        shadows: false,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InfoTexts(
                                          text: "Maio 2020",
                                          size: 14,
                                          hover: false,
                                          shadows: false,
                                        ),
                                        InfoTexts(
                                          text: "NA" + " ",
                                          size: 16,
                                          hover: false,
                                          weight: FontWeight.bold,
                                          shadows: false,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InfoTexts(
                                          text: "Junho 2020",
                                          size: 14,
                                          hover: false,
                                          shadows: false,
                                        ),
                                        InfoTexts(
                                          text: "NA" + " ",
                                          size: 16,
                                          hover: false,
                                          weight: FontWeight.bold,
                                          shadows: false,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
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
    this.weight,
    this.color,
  });

  final bool shadows;
  final String text;
  final double size;
  final bool hover;
  final FontWeight weight;
  final Color color;

  @override
  _InfoTextsState createState() => _InfoTextsState();
}

class _InfoTextsState extends State<InfoTexts> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hover) {
        if (widget.hover) {
          if (hover) {
            setState(() {
              hovering = true;
            });
          } else {
            setState(() {
              hovering = false;
            });
          }
        }
      },
      onTap: () {},
      child: Text(
        widget.text,
        style: TextStyle(
          color: hovering || !widget.hover
              ? widget.color != null ? widget.color : Colors.white
              : Colors.transparent,
          shadows: !hovering && widget.hover || !widget.shadows
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
          backgroundColor: hovering || !widget.hover
              ? Colors.transparent
              : Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
