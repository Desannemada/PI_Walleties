import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:walleties_mobile/models/account_model.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/home_screen.dart';
import 'package:walleties_mobile/pages/login_screen.dart';
import 'package:walleties_mobile/pages/splash_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MainViewModel>(
            create: (_) => MainViewModel(),
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
      title: 'Walleties Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: "Open Sans"),
        accentColor: Colors.blue,
        cursorColor: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          print("To login screen");
          return LoginScreen();
        }
        print("To home screen");
        return HomeScreen();
      },
    );
  }
}
