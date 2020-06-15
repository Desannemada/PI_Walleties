import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/card_validation_model.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';
import 'package:walleties/pages/widgets/inicial/cardOps/add_card.dart';
import 'package:walleties/pages/widgets/inicial/cardOps/card_operations.dart';
import 'package:walleties/pages/widgets/inicial/cardOps/delete_card.dart';

class InicialAppBar extends StatelessWidget {
  final int type;

  InicialAppBar({this.type});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    final fmodel = Provider.of<FirestoreModel>(context);

    return Container(
      height: type != 2 ? 70 : 120,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 69,
            // color: Colors.pink,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                CustomCursor(
                  cursorStyle: CustomCursor.pointer,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => model.updateIsDrawerOpen(),
                  ),
                ),
                SizedBox(width: 10),
                Center(
                  child: Text(
                    fmodel.currentOption[1],
                    style: TextStyle(
                      fontSize: 26,
                      color: fmodel.currentOption[2],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                type != 2 ? AppBarItems(type: type) : Container(),
              ],
            ),
          ),
          type != 2
              ? Container()
              : Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      AppBarItems(type: type),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class AppBarItems extends StatelessWidget {
  final int type;

  AppBarItems({this.type});

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);
    final cvmodel = Provider.of<CardValidationModel>(context);

    void operations(int len, int index) {
      if (len == 2) {
        if (index == 0) {
          model.updateChosenBank(model.banks[0]);
          cvmodel.cleanValidation();
          showDialog(context: context, child: AddCard());
        } else if (index == 1) {
          showDialog(context: context, child: DeleteCard());
        }
      } else {
        if (index == 0) {
          print("Depositar");
          showDialog(context: context, child: CardOperations(index: 0));
        } else if (index == 1) {
          print("Pagar");
          showDialog(context: context, child: CardOperations(index: 1));
        } else if (index == 2) {
          print("Transferir");
          model.updateChosenBankT(fmodel.currentOption[1]);
          showDialog(context: context, child: CardOperations(index: 2));
        } else if (index == 3) {
          print("Cobrar");
          showDialog(context: context, child: CardOperations(index: 3));
        }
      }
    }

    return Row(
      children: [
        SizedBox(width: type != 2 ? 40 : 15),
        ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: fmodel.currentOption[3].length,
          separatorBuilder: (context, index) => SizedBox(width: 30),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: type != 2 ? 15 : 0),
            child: CustomCursor(
              cursorStyle: CustomCursor.pointer,
              child: FlatButton(
                onPressed: () {
                  operations(fmodel.currentOption[3].length, index);
                },
                child: Text(
                  fmodel.currentOption[3][index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
