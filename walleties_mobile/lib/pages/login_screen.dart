import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/LS_widgets/login.dart';
import 'package:walleties_mobile/pages/LS_widgets/signin.dart';

import 'LS_widgets/logo.dart';

final images = [
  "assets/loginIcons/inicioIcon1.png",
  "assets/loginIcons/inicioIcon2.png",
  "assets/loginIcons/inicioIcon3.png",
  "assets/loginIcons/inicioIcon4.png",
  "assets/loginIcons/inicioIcon5.png",
  "assets/loginIcons/inicioIcon6.png",
];

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/loginBackground.jpg",
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
          ),
          padding: EdgeInsets.all(15),
          child: model.atualLoginWidget,
        ),
      ),
    );
  }
}

class LoginScreenMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Logo(),
        Spacer(),
        Text(
          "Nosso aplicativo integra e gerencia todas as suas contas bancárias em um lugar só.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          "Deposite, pague, transfira, agilize!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          height: 65,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (context, index) => SizedBox(width: 15),
            itemBuilder: (context, index) => Image.asset(images[index]),
          ),
        ),
        Spacer(),
        Column(
          children: [
            LoginScreenButton(0),
            SizedBox(height: 20),
            LoginScreenButton(1),
          ],
        ),
        Spacer(),
      ],
    );
  }
}

class LoginScreenButton extends StatelessWidget {
  final int index;
  LoginScreenButton(this.index);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Container(
      width: double.infinity,
      height: 45,
      child: RaisedButton(
        color: lighterGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          index == 0 ? "Entrar" : "Registrar-se",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => index == 0
            ? model.changeAtualLoginWidget(Login())
            : model.changeAtualLoginWidget(SignIn()),
      ),
    );
  }
}
