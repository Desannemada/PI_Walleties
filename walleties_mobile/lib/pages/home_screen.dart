import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/card_aba.dart';
import 'package:walleties_mobile/pages/HS_widgets/drawer.dart';
import 'package:walleties_mobile/pages/HS_widgets/geral_aba.dart';
import 'package:walleties_mobile/pages/HS_widgets/manage_cards.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          model.currentOption[1],
          style: TextStyle(
            color: model.currentOption[2],
            fontSize: 22,
            fontFamily: "Open Sans",
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              model.updateIsAddCardFormOpen(false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CardManager();
                  },
                ),
              );
            },
          )
        ],
      ),
      drawer: UserDrawer(),
      body: model.currentOption[0] == 0 ? AbaGeral() : AbaCartao(),
      bottomNavigationBar: model.currentOption[0] != 0
          ? BottomAppBar(
              child: Container(
                height: AppBar().preferredSize.height + 15,
                alignment: Alignment.center,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: List.generate(
                    4,
                    (index) => FlatButton(
                      onPressed: () {},
                      child: Text(
                        model.currentOption[3][index],
                        style: TextStyle(
                          fontSize: 18,
                          color: model.currentOption[2],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
