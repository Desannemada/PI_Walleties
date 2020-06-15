import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class DeleteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    return Dialog(
      child: Container(
        width: 400,
        height: MediaQuery.of(context).size.height / 2,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Meus cartões",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.scale(
                    scale: 0.8,
                    child: CustomCursor(
                      cursorStyle: CustomCursor.pointer,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        iconSize: 28,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                )
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: fmodel.userCards.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) => Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 55,
                      child: Card(
                        color: Colors.grey[300],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.credit_card, size: 25),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(fmodel.userCards[index][4]),
                                  Text(fmodel.userCards[index][1]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          child: AlertDialog(
                              title: Text(
                                "Deletando cartão",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: RichText(
                                text: TextSpan(
                                  text:
                                      "Tem certeza que deseja deletar o cartão\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Open Sans",
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: fmodel.userCards[index][1],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontFamily: "Open Sans",
                                      ),
                                    ),
                                    TextSpan(
                                      text: " ?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Open Sans",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    fmodel.deleteCard(index);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "SIM",
                                    style: TextStyle(
                                      color: darkGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    "NÃO",
                                    style: TextStyle(
                                      color: darkGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
