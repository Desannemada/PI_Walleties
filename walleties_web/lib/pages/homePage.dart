import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:walleties/main.dart';
import 'package:walleties/pages/widgets/home/intro_login.dart';
import 'package:walleties/pages/widgets/home/sign_in.dart';
import 'package:walleties/pages/widgets/home/tab_bar_login.dart';
import 'package:walleties/pages/widgets/home/sign_up.dart';
import 'package:walleties/pages/widgets/responsive/responsive.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _controller;
  ScrollController _controller2;

  @override
  void initState() {
    _controller = ScrollController();
    _controller2 = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                "assets/loginBackground.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 1240,
                height: 750,
                padding: EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(
                    controller: _controller,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20, bottom: 80),
                    children: <Widget>[
                      NavBarResponsive(),
                      SizedBox(height: 80),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: HomeContent(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: Container(
        height: 480,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            IntroLogin(type: true),
            SizedBox(width: 190),
            Container(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TabBarLogin(),
                  Container(
                    height: 415,
                    child: TabBarView(
                      children: [
                        Center(child: SignIn()),
                        Center(child: SignUp()),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      tablet: MobileTablet(),
      mobile: MobileTablet(),
    );
  }
}

class MobileTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IntroLogin(type: false),
        SizedBox(height: 100),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TabBarLogin(),
              Container(
                height: 415,
                child: TabBarView(
                  children: [
                    Center(child: SignIn()),
                    Center(child: SignUp()),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
