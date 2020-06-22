import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';
import 'package:walleties/pages/widgets/inicial/cardInfo/MeuCartao.dart';

class GeneralInfo extends StatefulWidget {
  final int type;
  final double space;
  final double cardWidth;

  GeneralInfo(
      {@required this.type, @required this.space, @required this.cardWidth});

  @override
  _GeneralInfoState createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    final fmodel = Provider.of<FirestoreModel>(context);

    ScrollController _scrollController = ScrollController();

    void moveCard() {
      _scrollController.animateTo(currentIndex * (widget.cardWidth + 30),
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }

    return Container(
      color: Colors.white.withOpacity(0.3),
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: MediaQuery.of(context).size.height - 70,
      width: MediaQuery.of(context).size.width -
          (widget.type == 0 ? model.isDrawerOpen ? 250 : 0 : 0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          Align(
            child: Container(
              color: Colors.white.withOpacity(0.6),
              width: widget.type == 1 ? 550 : widget.type == 0 ? 700 : 450,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.arrow_back_ios, size: 50),
                      onPressed: () {
                        setState(
                          () {
                            if (currentIndex - 1 >= 0) {
                              currentIndex = currentIndex - 1;
                              moveCard();
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    height: widget.space != 0 ? 243 : 205.2,
                    width:
                        widget.type == 0 ? 600 : widget.type == 1 ? 440 : 330,
                    alignment: Alignment.center,
                    child: fmodel.userCards.length != 0
                        ? ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: fmodel.userCards.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 30),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? widget.space : 0,
                                  right: index == fmodel.userCards.length - 1
                                      ? widget.space
                                      : 0,
                                ),
                                child: Container(
                                  width: widget.cardWidth,
                                  child: CustomCursor(
                                    cursorStyle: CustomCursor.pointer,
                                    child: GestureDetector(
                                      child: MeuCartao(
                                        option: fmodel.getOptions(index + 1),
                                      ),
                                      onTap: () {
                                        fmodel.updateCurrentOption(index + 1);
                                        // amodel.updateCurrentAccount(fmodel
                                        //         .userCards[
                                        //     fmodel.currentOption[0] - 1][1]);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Text(
                            "Sem cartões cadastrados",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.arrow_forward_ios, size: 50),
                      onPressed: () {
                        setState(() {
                          if (currentIndex + 1 < fmodel.userCards.length) {
                            currentIndex = currentIndex + 1;
                            moveCard();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 30,
            children: <Widget>[
              GeneralCards(index: 0),
              GeneralCards(index: 1),
              GeneralCards(index: 2),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class GeneralCards extends StatelessWidget {
  GeneralCards({
    @required this.index,
  });

  final int index;

  final List titles = ["Saldo", "Fatura Atual", "Limite Disponível"];

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);

    String getSingular(int i, int index) {
      double result = 0;
      if (index == 0) {
        result = double.parse(
            fmodel.userCards[i][8].replaceAll('.', '').replaceAll(',', '.'));
      } else if (index == 1) {
        for (var compra in fmodel.faturaCredito) {
          if (compra['name_bank'] == fmodel.getOptions(i + 1)[1]) {
            result = result +
                double.parse(
                    compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
          }
        }
      } else if (index == 2) {
        result = result +
            double.parse(fmodel.userCards[i][9]
                .replaceAll('.', '')
                .replaceAll(',', '.'));
      }
      return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
          .format(result);
    }

    String getTotal(int index) {
      double result = 0;
      if (index == 0) {
        for (var card = 0; card < fmodel.userCards.length; card++) {
          result = result +
              double.parse(
                fmodel.userCards[card][8]
                    .replaceAll('.', '')
                    .replaceAll(',', '.'),
              );
        }
      } else if (index == 1) {
        for (var compra in fmodel.faturaCredito) {
          result = result +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      } else if (index == 2) {
        for (var card in fmodel.userCards) {
          result = result +
              double.parse(card[9].replaceAll('.', '').replaceAll(',', '.'));
        }
      }
      return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
          .format(result);
    }

    double barSize(int index, int i) {
      double result;
      result = double.parse(getSingular(i, index)
              .substring(3)
              .replaceAll('.', '')
              .replaceAll(',', '.')) /
          double.parse(getTotal(index)
              .substring(3)
              .replaceAll('.', '')
              .replaceAll(',', '.'));

      if (result.isNaN) {
        return 0;
      }
      return result;
    }

    return Container(
      width: model.isDrawerOpen ? 500 : 550,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                titles[index],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: fmodel.currentOption[2],
                ),
              ),
              Divider(
                height: 25,
                thickness: 0.5,
                indent: 30,
                endIndent: 30,
                color: Colors.black,
              ),
              GeralTexts(
                fontSize: 25,
                text: getTotal(index),
                color: lightGreen,
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: fmodel.userCards.length,
                    separatorBuilder: (context, i) => SizedBox(height: 20),
                    itemBuilder: (context, i) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            fmodel.options[i + 1][0],
                            size: 65,
                            color: fmodel.setColor(i + 1),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      fmodel.getOptions(i + 1)[1],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: fmodel.getOptions(i + 1)[2],
                                      ),
                                    ),
                                    GeralTexts(
                                      fontSize: 22,
                                      text: getSingular(i, index),
                                      color: fmodel.getOptions(i + 1)[2],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 20,
                                  width: 347,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: FractionallySizedBox(
                                    widthFactor: barSize(index, i),
                                    child: Container(
                                      color: fmodel.getOptions(i + 1)[2],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GeralTexts extends StatefulWidget {
  final double fontSize;
  final Color color;
  final String text;

  GeralTexts(
      {@required this.fontSize, @required this.text, @required this.color});

  @override
  _GeralTextsState createState() => _GeralTextsState();
}

class _GeralTextsState extends State<GeralTexts> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
        widget.text,
        style: TextStyle(
          fontSize: widget.fontSize,
          color: hovering ? widget.color : Colors.transparent,
          backgroundColor:
              hovering ? Colors.transparent : Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
