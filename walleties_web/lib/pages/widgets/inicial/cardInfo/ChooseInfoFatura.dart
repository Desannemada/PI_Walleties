import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class ChooseInfoFatura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    double barSize() {
      double result = (double.parse(fmodel
                  .userCards[fmodel.currentOption[0] - 1][9]
                  .replaceAll('.', '')
                  .replaceAll(',', '.')) -
              double.parse(fmodel.userCards[fmodel.currentOption[0] - 1][8]
                  .replaceAll('.', '')
                  .replaceAll(',', '.'))) /
          double.parse(fmodel.userCards[fmodel.currentOption[0] - 1][9]
              .replaceAll('.', '')
              .replaceAll(',', '.'));
      return result;
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
                        value: "Not connected",
                        items: [
                          "Not connected",
                          "Not connected2",
                          "Not connected3"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          // amodel.updateFaturalAtual(newValue);
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
                              (double.parse(fmodel.userCards[
                                              fmodel.currentOption[0] - 1][9]
                                          .replaceAll('.', '')
                                          .replaceAll(',', '.')) -
                                      double.parse(fmodel.userCards[
                                              fmodel.currentOption[0] - 1][8]
                                          .replaceAll('.', '')
                                          .replaceAll(',', '.')))
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 24,
                                  color: lightGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        /*amodel.accounts[amodel.currentAccount]['faturas']
                                        [amodel.faturaAtual]['credito']
                                    ['disponivel'] !=
                                ''
                            ? */
                        Wrap(
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
                              (double.parse(fmodel
                                          .userCards[fmodel.currentOption[0] - 1]
                                              [9]
                                          .replaceAll('.', '')
                                          .replaceAll(',', '.')) -
                                      (double.parse(fmodel
                                              .userCards[fmodel.currentOption[0] - 1]
                                                  [9]
                                              .replaceAll('.', '')
                                              .replaceAll(',', '.')) -
                                          double.parse(fmodel
                                              .userCards[fmodel.currentOption[0] - 1]
                                                  [8]
                                              .replaceAll('.', '')
                                              .replaceAll(',', '.'))))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 24,
                                color: fmodel.currentOption[2],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                        //: Container(),
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
