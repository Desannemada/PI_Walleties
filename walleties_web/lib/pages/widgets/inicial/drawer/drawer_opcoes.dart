import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';
import 'package:walleties/pages/widgets/inicial/drawer/edit_profile.dart';

class DrawerOptions extends StatefulWidget {
  final bool type;
  DrawerOptions({this.type});

  @override
  _DrawerOptionsState createState() => _DrawerOptionsState();
}

class _DrawerOptionsState extends State<DrawerOptions> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    final fmodel = Provider.of<FirestoreModel>(context);
    ScrollController _controller = ScrollController();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          FlatButton.icon(
            onPressed: () {
              fmodel.updateWaiting(false);
              fmodel.updateUserInfo();
            },
            icon: Icon(Icons.autorenew),
            label: Text("Recarregar Página"),
          ),
          ListView.builder(
            controller: _controller,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: fmodel.options.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    height: 35,
                    child: CustomCursor(
                      cursorStyle: CustomCursor.pointer,
                      child: RaisedButton(
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              fmodel.options[index][0],
                              size: 30,
                              color: fmodel.setColor(index),
                            ),
                            SizedBox(width: 10),
                            Text(
                              fmodel.options[index][1],
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (index == fmodel.options.length - 1) {
                            model.updateisConfigDown(!model.isConfigDown);
                          } else {
                            model.updateCardMonths(fmodel.fMonths);
                            fmodel.updateCurrentOption(index);
                            model.updateCurrentMonth(
                                model.getMonth(DateTime.now().month) +
                                    " " +
                                    DateTime.now().year.toString());
                          }
                          if (widget.type != null && !widget.type) {
                            model.updateIsDrawerOpen();
                          }
                        },
                      ),
                    ),
                  ),
                  index == fmodel.options.length - 1 && model.isConfigDown
                      ? ConfigMenu(options: fmodel.options)
                      : Container(),
                ],
              );
            },
          ),
        ],
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
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);

    void _signOut() async {
      try {
        await fmodel.auth.signOut();
        await fmodel.googleSignIn.signOut();
        Navigator.pushNamed(context, "/Home");
        model.updateisConfigDown(false);
      } catch (e) {
        print(e.toString());
        return null;
      }
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 35, right: 35, top: 10),
            height: 25,
            child: CustomCursor(
              cursorStyle: CustomCursor.pointer,
              child: RaisedButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                child: Text(
                  menu[index],
                  style: TextStyle(fontSize: 14),
                ),
                onPressed: () {
                  if (index == 1) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("Sair"),
                        content: Text("Têm certeza que deseja sair?"),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              _signOut();
                            },
                            child: Text(
                              "Sim",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
                            child: Text(
                              "Não",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (index == 0) {
                    showDialog(
                      context: context,
                      child: EditProfile(initialValue: fmodel.userInfo[0]),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}
