import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
// import 'package:walleties_mobile/models/account_model.dart';
import 'package:walleties_mobile/models/firebase_auth.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/login_screen.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    // final amodel = Provider.of<AccountModel>(context);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginBackground.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.8),
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            scale: 10,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Walleties",
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image:
                                model.userInfo[3] == 'assets/profileImage.jpg'
                                    ? AssetImage(
                                        'assets/profileImage.jpg',
                                      )
                                    : NetworkImage(
                                        model.userInfo[3],
                                      ),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        model.userInfo[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                      Text(
                        model.userInfo[1],
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Contas: " + model.userCards.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.options.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              height: 45,
                              child: RaisedButton(
                                padding: EdgeInsets.zero,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      model.options[index][0],
                                      size: 35,
                                      color: model.setColor(index),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      model.options[index][1],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  if (index == model.options.length - 1) {
                                    if (model.isConfigDown) {
                                      model.updateisConfigDown(false);
                                    } else {
                                      model.updateisConfigDown(true);
                                    }
                                  } else {
                                    model.updateCurrentOption(index);
                                    if (index != 0) {
                                      model.updateIsTapped(false);
                                      // amodel.updateCurrentAccount(
                                      //     model.userCards[
                                      //         model.currentOption[0] - 1][1]);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            index == model.options.length - 1 &&
                                    model.isConfigDown
                                ? ConfigMenu(options: model.options)
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfigMenu extends StatelessWidget {
  final List options;
  ConfigMenu({this.options});

  final List menu = ["Editar Perfil", "Sair"];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 35, right: 35, top: 10),
            height: 35,
            child: RaisedButton(
              padding: EdgeInsets.zero,
              color: Colors.white,
              child: Text(
                menu[index],
                style: TextStyle(fontSize: 15),
              ),
              onPressed: () {
                if (index == 1) {
                  model.changeAtualLoginWidget(LoginScreenMenu());
                  AuthProvider().signOut();
                }
                if (index == 0) {
                  // showDialog(
                  //   context: context,
                  //   child: EditProfile(initialValue: fmodel.userInfo[0]),
                  // );
                }
              },
            ),
          );
        });
  }
}
