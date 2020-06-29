import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class ChooseInfoFatura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);

    double barSize() {
      double fatura = 0.0;
      for (var compra in fmodel.faturaCredito) {
        if (compra['name_bank'] ==
            fmodel.userCards[fmodel.currentOption[0] - 1][4]) {
          fatura = fatura +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      }
      double result = (fatura /
          double.parse(fmodel.userCards[fmodel.currentOption[0] - 1][9]
              .replaceAll('.', '')
              .replaceAll(',', '.')));
      return result;
    }

    String getInfo(int index) {
      double result = 0.0;
      for (var compra in fmodel.faturaCredito) {
        if (compra['name_bank'] ==
            fmodel.userCards[fmodel.currentOption[0] - 1][4]) {
          result = result +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      }

      if (index == 0) {
        return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
            .format(result);
      } else if (index == 1) {
        double limite = double.parse(fmodel
            .userCards[fmodel.currentOption[0] - 1][9]
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
            .format(limite - result);
      }
    }

    String getTotalFatura(String mes) {
      String date;
      if (model.getMonthInt(mes) < 10) {
        date = mes.substring(mes.length - 4) +
            "-0" +
            model.getMonthInt(mes).toString();
      } else {
        date = mes.substring(mes.length - 4) +
            "-" +
            model.getMonthInt(mes).toString();
      }
      double result = 0;
      for (var compra in fmodel.faturaCredito) {
        if (compra['name_bank'] ==
                fmodel.userCards[fmodel.currentOption[0] - 1][4] &&
            compra['data'].substring(0, 7) == date) {
          result = result +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      }

      return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
          .format(result);
    }

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Escolher",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: fmodel.currentOption[2],
                      ),
                    ),
                  ),
                  CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: model.currentMonth,
                        items: model.cardMonths[fmodel.currentOption[0] - 1]
                            .map((String value) {
                          // print(model.cardMonths);
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          model.updateCurrentMonth(newValue);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 30,
                      children: <Widget>[
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: <Widget>[
                            Text(
                              "Fatura Atual",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              model.currentMonth ==
                                      model.getMonth(DateTime.now().month) +
                                          " " +
                                          DateTime.now().year.toString()
                                  ? getInfo(0)
                                  : getTotalFatura(model.currentMonth),
                              style: TextStyle(
                                fontSize: 24,
                                color: lightGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        model.currentMonth ==
                                model.getMonth(DateTime.now().month) +
                                    " " +
                                    DateTime.now().year.toString()
                            ? Wrap(
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Limite Disponível",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    getInfo(1),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: fmodel.currentOption[2],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 11),
                    Container(
                      height: 15,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: barSize(),
                        child: Container(
                          color: fmodel.currentOption[2],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
