import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';
import 'package:walleties/pages/widgets/inicial/drawer/drawer_opcoes.dart';
import 'package:walleties/pages/widgets/inicial/drawer/profile.dart';

class MyDrawer extends StatelessWidget {
  final bool type;

  MyDrawer({this.type});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return model.isDrawerOpen
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                right: BorderSide(color: Colors.grey),
              ),
            ),
            child: Container(
              color: Colors.white.withOpacity(0.9),
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
                      type != null && !type
                          ? CustomCursor(
                              cursorStyle: CustomCursor.pointer,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    model.updateIsDrawerOpen();
                                  },
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  UserProfile(),
                  SizedBox(height: 10),
                  Expanded(child: DrawerOptions(type: type)),
                ],
              ),
            ),
          )
        : Container();
  }
}
