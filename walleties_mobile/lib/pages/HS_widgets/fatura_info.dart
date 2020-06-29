import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/models/main_view_model.dart';

class FaturaInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Text(
            model.whichAbaFatura ? "Crédito" : "Débito",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.whichAbaFatura
                ? model.faturaCredito.length
                : model.faturaDebito.length,
            itemBuilder: (context, i) {
              bool aux = false;
              List aux2 = [];
              if (model.whichAbaFatura) {
                if (model.faturaCredito[i]['name_bank'] ==
                        model.userCards[model.currentOption[0] - 1][4] &&
                    model.getMonthYear(
                            model.faturaCredito[i]['data'].substring(0, 7)) ==
                        model.currentMonth) {
                  aux = true;
                  aux2 = [
                    (model.faturaCredito[i]['data']).substring(0, 10),
                    model.faturaCredito[i]['item'],
                    NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
                        .format(double.parse(model.faturaCredito[i]['valor']
                            .replaceAll('.', '')
                            .replaceAll(',', '.')))
                  ];
                }
              }
              if (!model.whichAbaFatura) {
                if (model.faturaDebito[i]['name_bank'] ==
                        model.userCards[model.currentOption[0] - 1][4] &&
                    model.getMonthYear(
                            model.faturaDebito[i]['data'].substring(0, 7)) ==
                        model.currentMonth) {
                  aux = true;
                  aux2 = [
                    (model.faturaDebito[i]['data']).substring(0, 10),
                    model.faturaDebito[i]['item'],
                    NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
                        .format(double.parse(model.faturaDebito[i]['valor']
                            .replaceAll('.', '')
                            .replaceAll(',', '.')))
                  ];
                }
              }

              return aux
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              aux2[0],
                              style: TextStyle(
                                color: model.currentOption[2].withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  aux2[1],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              aux2[2],
                              style: TextStyle(
                                color: model.currentOption[2].withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 30)
                      ],
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
