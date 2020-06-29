import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/card_aba.dart';

class GeralCardInfo extends StatefulWidget {
  @override
  _GeralCardInfoState createState() => _GeralCardInfoState();
}

class _GeralCardInfoState extends State<GeralCardInfo> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    String getInfo(int index) {
      double result = 0.0;
      for (var compra in model.faturaCredito) {
        if (compra['name_bank'] ==
            model.userCards[model.currentOption[0] - 1][4]) {
          result = result +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      }
      if (index == 0) {
        result = double.parse(model.userCards[model.currentOption[0] - 1][8]
            .replaceAll('.', '')
            .replaceAll(',', '.'));
        return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
            .format(result);
      } else if (index == 1) {
        return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
            .format(result);
      } else if (index == 2) {
        double limite = double.parse(model.userCards[model.currentOption[0] - 1]
                [9]
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
      for (var compra in model.faturaCredito) {
        if (compra['name_bank'] ==
                model.userCards[model.currentOption[0] - 1][4] &&
            compra['data'].substring(0, 7) == date) {
          result = result +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      }

      return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
          .format(result);
    }

    return GestureDetector(
      onTap: () {
        model.updateWhichAbaFatura(!model.whichAbaFatura);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: model.currentOption[2].withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  !model.whichAbaFatura ? "Informações Gerais" : "Faturas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: model.currentOption[2],
                  ),
                ),
                IconButton(
                  color: Colors.black.withOpacity(0.5),
                  icon: Icon(
                    model.isTapped ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => model.updateIsTapped(!model.isTapped),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: List.generate(
                !model.whichAbaFatura &&
                        model.currentMonth ==
                            model.getMonth(DateTime.now().month) +
                                " " +
                                DateTime.now().year.toString()
                    ? 3
                    : model.whichAbaFatura &&
                            model.currentMonth ==
                                model.getMonth(DateTime.now().month) +
                                    " " +
                                    DateTime.now().year.toString()
                        ? 2
                        : model.whichAbaFatura &&
                                !(model.currentMonth ==
                                    model.getMonth(DateTime.now().month) +
                                        " " +
                                        DateTime.now().year.toString())
                            ? 1
                            : 2,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        !model.whichAbaFatura
                            ? index == 0
                                ? "Saldo"
                                : index == 1
                                    ? "Fatura Atual"
                                    : "Limite Disponível"
                            : index == 0 ? "Fatura Atual" : "Limite Disponível",
                        style: TextStyle(
                          color: model.currentOption[2].withOpacity(0.5),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InfoTexts(
                        text: !model.whichAbaFatura &&
                                model.currentMonth ==
                                    model.getMonth(DateTime.now().month) +
                                        " " +
                                        DateTime.now().year.toString()
                            ? getInfo(index)
                            : model.whichAbaFatura &&
                                    model.currentMonth ==
                                        model.getMonth(DateTime.now().month) +
                                            " " +
                                            DateTime.now().year.toString()
                                ? getInfo(index + 1)
                                : model.whichAbaFatura &&
                                        !(model.currentMonth ==
                                            model.getMonth(
                                                    DateTime.now().month) +
                                                " " +
                                                DateTime.now().year.toString())
                                    ? getTotalFatura(model.currentMonth)
                                    : index == 0
                                        ? getInfo(index)
                                        : getTotalFatura(model.currentMonth),
                        // text: model.currentMonth ==
                        //         model.getMonth(DateTime.now().month) +
                        //             " " +
                        //             DateTime.now().year.toString()
                        //     ? getInfo(0)
                        //     : getTotalFatura(model.currentMonth),
                        // text: !model.whichAbaFatura
                        //     ? index == 1
                        //         ? getTotalFatura(model.currentMonth)
                        //         : getSingular(model.currentOption[0] - 1, index)
                        //     : getSingular(
                        //         model.currentOption[0] - 1, index + 1),
                        hover: true,
                        size: 18,
                        weight: FontWeight.w600,
                        shadows: false,
                        color: !model.whichAbaFatura
                            ? index == 0 ? darkGreen : lightGreen
                            : lightGreen,
                        type: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
