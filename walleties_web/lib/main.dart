import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/card_validation_model.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/homePage.dart';
import 'package:walleties/pages/inicialPage.dart';
import 'package:walleties/pages/widgets/home/about_info.dart';
import 'package:walleties/pages/widgets/home/intro_login.dart';
import 'package:walleties/pages/widgets/responsive/responsive.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MainViewModel>(
            create: (_) => MainViewModel(),
          ),
          ChangeNotifierProvider<FirestoreModel>(
            create: (_) => FirestoreModel(),
          ),
          ChangeNotifierProvider<CardValidationModel>(
            create: (_) => CardValidationModel(),
          ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  var _iOS = [
    'iPad Simulator',
    'iPhone Simulator',
    'iPod Simulator',
    'iPad',
    'iPhone',
    'iPod'
  ];
  bool isIOS() {
    var matches = false;
    _iOS.forEach((name) {
      if (html.window.navigator.platform.contains(name) ||
          html.window.navigator.userAgent.contains(name)) {
        matches = true;
      }
    });
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Walleties App',
      initialRoute: '/Home',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: "Open Sans"),
        accentColor: Colors.blue,
        cursorColor: Colors.blue,
      ),
      routes: {
        '/Home': (context) {
          if (!(html.window.navigator.platform == "Android" ||
                  html.window.navigator.userAgent.contains("Android")) &&
              !isIOS()) {
            return MainScreen();
          } else {
            return MobileWarning();
          }
        },
        '/Geral': (context) => InicialPage(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if ((!snapshot.hasData || snapshot.data == null)) {
          print("Iniciando Tela de Login...");
          return HomePage();
        }
        print("Iniciando Tela de Menu...");
        return InicialPage();
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MobileWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    List apks = ["Walleties App 32-bit", "Walleties App 64-bit"];

    return Scaffold(
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
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 20, bottom: 80),
                    children: <Widget>[
                      NavBarResponsive(),
                      SizedBox(height: 50),
                      Container(
                        width: double.infinity,
                        // height: 510,
                        alignment: Alignment.center,
                        child: model.currentMobileHomeWidget
                            ? IntroLogin(type: false)
                            : Container(height: 1230, child: AboutInfo()),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Text(
                          "Baixe nosso aplicativo mobile!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      (html.window.navigator.platform == "Android" ||
                              html.window.navigator.userAgent
                                  .contains("Android"))
                          ? Column(
                              children: [
                                Column(
                                  children: List.generate(
                                    2,
                                    (index) => Container(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: Colors.blue,
                                        onPressed: () async {
                                          String url = index == 0
                                              ? "https://github.com/Desannemada/PI_Walleties/raw/master/APKs/32_bit/app-armeabi-v7a-release.apk"
                                              : "https://github.com/Desannemada/PI_Walleties/raw/master/APKs/64_bit/app-arm64-v8a-release.apk";
                                          if (await canLaunch(url)) {
                                            launch(url);
                                          } else {
                                            print("Erro github");
                                          }
                                        },
                                        child: Text(
                                          apks[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "*Somente disponível para Android ;)",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.red),
                                )
                              ],
                            )
                          : Center(
                              child: Text(
                                "Somente disponível para Android :(",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
