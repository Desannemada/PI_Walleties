import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/extra/my_flutter_app_icons.dart';
// import 'package:walleties_mobile/models/account_model.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/add_card.dart';

class CardManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final amodel = Provider.of<AccountModel>(context);
    final model = Provider.of<MainViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Meus Cartões",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: RaisedButton(
                child: Text(
                  "Adicionar Cartão",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => model.updateIsAddCardFormOpen(true),
                color: blue,
              ),
            ),
            // SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: model.userCards.length + 1,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) => Container(
                  width: double.infinity,
                  child: index == 0
                      ? model.isAddCardFormOpen ? AddCard() : Container()
                      : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      MyFlutterApp.pay,
                                      color: model.getOptions(index)[2],
                                      size: 40,
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(model.userCards[index - 1][0]),
                                        Text(model.userCards[index - 1][1]),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
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
                                                  text: model.userCards[index]
                                                      [1],
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
                                              onPressed: () async {
                                                var res = await model
                                                    .deleteCard(index);
                                                if (res) {
                                                  model.updateCurrentOption(0);
                                                  Navigator.of(context).pop();
                                                }
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      Future.delayed(
                                                          Duration(seconds: 1),
                                                          () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      });
                                                      return ResultDeleteDialog(
                                                        res
                                                            ? "Conta removida com sucesso!"
                                                            : "Não foi possível completar a operação!",
                                                      );
                                                    });
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
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
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
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResultDeleteDialog extends StatelessWidget {
  final String title;
  ResultDeleteDialog(this.title);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
