import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
// import 'package:walleties_mobile/models/account_model.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/digi_ops.dart';

class AbaGeral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final amodel = Provider.of<AccountModel>(context);
    final model = Provider.of<MainViewModel>(context);

    return Container(
      padding: EdgeInsets.all(15),
      child: ListView(
        shrinkWrap: true,
        children: [
          model.userCards.isNotEmpty
              ? Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 15),
                    height: 75,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: model.userCards.length,
                      separatorBuilder: (context, index) => SizedBox(width: 0),
                      itemBuilder: (context, index) => RaisedButton(
                        padding: EdgeInsets.zero,
                        shape: CircleBorder(),
                        color: model.getOptions(index + 1)[2],
                        child: Text(
                          model.getOptions(index + 1)[1][0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        onPressed: () {
                          model.updateCurrentOption(index + 1);
                          model.updateCardMonths(model.fMonths);
                          model.updateCurrentMonth(
                              model.getMonth(DateTime.now().month) +
                                  " " +
                                  DateTime.now().year.toString());
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 25),
          Center(
            child: Text(
              "Operações Digitais",
              style: TextStyle(
                color: darkBlue,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(
              2,
              (index) => Container(
                margin: index == 0
                    ? EdgeInsets.only(right: 10)
                    : EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 50,
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    index == 0 ? "Cobrar" : "Pagar",
                    style: TextStyle(
                      color: nubank,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    if (model.userCards.isNotEmpty) {
                      if (index == 0) {
                        model.updateShowQRCode(false);
                        model.updateInfoQRCode("");
                        model.updateChooseCobCard(0);
                        model.updateCobMoney("0,00");
                      } else {
                        model.createSliders();
                        model.updateInfogetQRCode([]);
                      }
                      model.updateChecks();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return DigiOps(index);
                          },
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text("Aviso"),
                          content: Text(
                              "Cadastre um cartão antes de realizar operações."),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Center(
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    color: darkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 123.0 +
                (model.userCards.isNotEmpty
                    ? (55.0 * (model.userCards.length))
                    : 100),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.075 - 15),
                GeralCard("Fatura Atual", 0),
                SizedBox(width: 10),
                GeralCard("Limite Disponível", 1),
                SizedBox(width: MediaQuery.of(context).size.width * 0.075 - 15)
              ],
            ),
          ),
          SizedBox(height: 30),
          Align(
            child: Container(
              height: 123.0 +
                  (model.userCards.isNotEmpty
                      ? (55.0 * (model.userCards.length))
                      : 100),
              child: GeralCard("Saldo Atual", 2),
            ),
          ),
        ],
      ),
    );
  }
}

class GeralCard extends StatelessWidget {
  final String title;
  final int index;

  GeralCard(this.title, this.index);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    String getTotal(int index) {
      double result = 0;
      if (index == 2) {
        for (var card = 0; card < model.userCards.length; card++) {
          result = result +
              double.parse(
                model.userCards[card][8]
                    .replaceAll('.', '')
                    .replaceAll(',', '.'),
              );
        }
      } else if (index == 0) {
        for (var compra in model.faturaCredito) {
          result = result +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      } else if (index == 1) {
        for (var i = 0; i < model.userCards.length; i++) {
          result = result +
              (double.parse(model.userCards[i][9]
                      .replaceAll('.', '')
                      .replaceAll(',', '.')) -
                  double.parse(model
                      .getSingular(i, 0)
                      .substring(3)
                      .replaceAll('.', '')
                      .replaceAll(',', '.')));
        }
      }
      return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
          .format(result);
    }

    double barSize(int index, int i) {
      double result;
      result = double.parse(model
              .getSingular(i, index)
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

    // GlobalKey _keyRed = GlobalKey();
    // _getSizes() {
    //   final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    //   final sizeRed = renderBoxRed.size;
    //   print("SIZE of Red: $sizeRed");
    // }

    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[200]),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // FlatButton(onPressed: () => _getSizes(), child: Text("ah")),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: yellow,
                    fontSize: 22,
                  ),
                ),
              ),
              Divider(
                color: Colors.black.withOpacity(0.4),
                height: 20,
              ),
              Center(
                child: Text(
                  getTotal(index),
                  style: TextStyle(
                    fontSize: 25,
                    color: lightGreen,
                  ),
                ),
              ),
              SizedBox(height: 15),
              model.userCards.isNotEmpty
                  ? Column(
                      children: List.generate(
                        model.userCards.length,
                        (i) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              height: 45,
                              width: 45,
                              child: Card(
                                shape: CircleBorder(),
                                color: model.getOptions(i + 1)[2],
                                child: Center(
                                  child: Text(
                                    model.getOptions(i + 1)[1][0],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        model.getOptions(i + 1)[1],
                                        style: TextStyle(
                                          color: model.getOptions(i + 1)[2],
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        model.getSingular(i, index),
                                        style: TextStyle(
                                          color: model.getOptions(i + 1)[2],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    height: 10,
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: model.getOptions(i + 1)[2],
                                      ),
                                    ),
                                    // color: model.getOptions(i + 1)[2],
                                    child: FractionallySizedBox(
                                      widthFactor: barSize(index, i),
                                      child: Container(
                                        color: model.getOptions(i + 1)[2],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Text("Sem cartões cadastrados!"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
