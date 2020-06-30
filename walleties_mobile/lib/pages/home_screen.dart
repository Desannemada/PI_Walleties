import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/card_aba.dart';
import 'package:walleties_mobile/pages/HS_widgets/drawer.dart';
import 'package:walleties_mobile/pages/HS_widgets/geral_aba.dart';
import 'package:walleties_mobile/pages/HS_widgets/manage_cards.dart';
import 'package:walleties_mobile/pages/HS_widgets/operacoes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    if (model.userInfo[3] == 'assets/profileImage.jpg') {
      precacheImage(AssetImage('assets/profileImage.jpg'), context);
    } else {
      precacheImage(NetworkImage(model.userInfo[3]), context);
    }
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
            icon: Icon(
              Icons.autorenew,
              color: yellow,
            ),
            onPressed: () {
              model.updateWaiting(false);
              model.updateUserInfo();
            },
          ),
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
          ),
        ],
      ),
      drawer: UserDrawer(),
      body: model.waiting
          ? model.currentOption[0] == 0 ? AbaGeral() : AbaCartao()
          : Center(
              child: CircularProgressIndicator(),
            ),
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
                      onPressed: () {
                        if (index < 2) {
                          model.updateCobMoney("0,00");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Operacoes(index);
                              },
                            ),
                          );
                        }
                      },
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
