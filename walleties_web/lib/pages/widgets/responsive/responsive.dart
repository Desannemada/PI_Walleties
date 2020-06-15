import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/widgets/home/navigation_bar.dart';
import 'package:walleties/pages/widgets/inicial/cardInfo.dart';
import 'package:walleties/pages/widgets/inicial/general_info.dart';
import 'package:walleties/pages/widgets/inicial/inicialAppBar.dart';

class NavBarResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: NavigationBar(type: false),
      desktop: NavigationBar(type: true),
    );
  }
}

class InicialAppBarResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    return ScreenTypeLayout(
      mobile: InicialAppBar(type: fmodel.currentOption[0] == 0 ? 0 : 2),
      tablet: InicialAppBar(type: fmodel.currentOption[0] == 0 ? 0 : 1),
      desktop: InicialAppBar(type: 0),
    );
  }
}

class CardInfoResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints: ScreenBreakpoints(tablet: 600, desktop: 1620, watch: 300),
      mobile: CardInfo(type: 2),
      tablet: CardInfo(type: 1),
      desktop: CardInfo(type: 0),
    );
  }
}

class GeneralInfoResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return ScreenTypeLayout(
      breakpoints: ScreenBreakpoints(
        tablet: 600,
        desktop: model.isDrawerOpen ? 1010 : 800,
        watch: 300,
      ),
      mobile: GeneralInfo(
        type: 2,
        space: 0,
        cardWidth: 323,
      ),
      tablet: GeneralInfo(
        type: 1,
        space: 30,
        cardWidth: 382.5,
      ),
      desktop: GeneralInfo(
        type: 0,
        space: (382.5 / 4) + 15,
        cardWidth: 382.5,
      ),
    );
  }
}
