import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/account_model.dart';
import 'package:walleties/model/card_validation_model.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/homePage.dart';
import 'package:walleties/pages/inicialPage.dart';

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
          // ChangeNotifierProvider<AccountModel>(
          //   create: (_) => AccountModel(),
          // ),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
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
        '/Home': (context) => MainScreen(),
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
          print("dont have data");
          return HomePage();
        }
        print("hasdata");
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
