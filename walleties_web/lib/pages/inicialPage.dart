import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/widgets/inicial/drawer/drawer.dart';
import 'package:walleties/pages/widgets/responsive/responsive.dart';

class InicialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "assets/loginBackground.jpg",
            fit: BoxFit.cover,
          ),
          Row(
            children: [
              ScreenTypeLayout(
                desktop: MyDrawer(),
                tablet: fmodel.currentOption[0] == 0 ? Container() : MyDrawer(),
                mobile: Container(),
              ),
              ScreenTypeLayout(
                desktop: InicialPageContent(type: true),
                tablet: InicialPageContent(
                    type: fmodel.currentOption[0] == 0 ? false : true),
                mobile: InicialPageContent(type: false),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ScreenTypeLayout(
              mobile: MyDrawer(type: false),
              desktop: Container(),
              tablet: fmodel.currentOption[0] == 0
                  ? MyDrawer(type: false)
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class InicialPageContent extends StatelessWidget {
  final bool type;

  InicialPageContent({this.type});

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);

    return Container(
      width: type
          ? model.isDrawerOpen
              ? MediaQuery.of(context).size.width - 250
              : MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          InicialAppBarResponsive(),
          Expanded(
            child: fmodel.currentOption[0] == 0
                ? GeneralInfoResponsive()
                : CardInfoResponsive(),
          ),
        ],
      ),
    );
  }
}
