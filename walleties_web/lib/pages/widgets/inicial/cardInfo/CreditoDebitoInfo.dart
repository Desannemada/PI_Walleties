import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class CreditoDebitoInfo extends StatelessWidget {
  final int type;

  CreditoDebitoInfo({this.type});

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 30,
      children: List.generate(
        2,
        (index) => Container(
          width: type != 1 ? 520 : 700,
          height: type != 1 ? 720 : 420,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FractionallySizedBox(
                heightFactor: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      index == 0 ? "Crédito" : "Débito",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: fmodel.currentOption[2],
                      ),
                    ),
                    Divider(
                      height: 40,
                      thickness: 0.5,
                      indent: 30,
                      endIndent: 30,
                      color: Colors.black,
                    ),
                    CredDebFatura(
                      type: type,
                      index: index,
                    )
                    // Text("Not connected yet")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CredDebFatura extends StatelessWidget {
  final int type;
  final index;

  CredDebFatura({@required this.type, @required this.index});

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    return SizedBox(
      height: type != 1 ? 605 : 305,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: index == 0
            ? fmodel.faturaCredito.length
            : fmodel.faturaDebito.length,
        // separatorBuilder: (context, i) => SizedBox(height: 20),
        itemBuilder: (context, i) {
          bool aux = false;
          List aux2 = [];
          if (index == 0) {
            if (fmodel.faturaCredito[i]['name_bank'] ==
                fmodel.userCards[fmodel.currentOption[0] - 1][4]) {
              aux = true;
              aux2 = [
                (fmodel.faturaCredito[i]['data']).substring(0, 10),
                fmodel.faturaCredito[i]['item'],
                NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ').format(
                    double.parse(fmodel.faturaCredito[i]['valor']
                        .replaceAll('.', '')
                        .replaceAll(',', '.')))
              ];
            }
          }
          if (index == 1) {
            if (fmodel.faturaDebito[i]['name_bank'] ==
                fmodel.userCards[fmodel.currentOption[0] - 1][4]) {
              aux = true;
              aux2 = [
                (fmodel.faturaDebito[i]['data']).substring(0, 10),
                fmodel.faturaDebito[i]['item'],
                NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ').format(
                    double.parse(fmodel.faturaDebito[i]['valor']
                        .replaceAll('.', '')
                        .replaceAll(',', '.')))
              ];
            }
          }
          // print(aux2);

          return aux
              ? Padding(
                  padding: const EdgeInsets.only(right: 5, left: 5, bottom: 20),
                  child: CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: FlatButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            aux2[0],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: fmodel.currentOption[2],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: type != 2 ? 220 : 160,
                            ),
                            child: Text(
                              aux2[1],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            aux2[2],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: fmodel.currentOption[2],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox();
        },
      ),
    );
  }
}
