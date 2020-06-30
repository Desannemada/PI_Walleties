import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final model = Provider.of<MainViewModel>(context);
    return ListView(
      shrinkWrap: true,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Logo(8),
        // Spacer(),
        SizedBox(height: 20),
        Text(
          "Nosso aplicativo integra e gerencia todas as suas contas bancárias em um lugar só.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          "Deposite, pague, transfira, agilize!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          height: 65,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (context, index) => SizedBox(width: 15),
            itemBuilder: (context, index) => Image.asset(images[index]),
          ),
        ),
        // Spacer(),
        SizedBox(height: 20),
        Column(
          children: [
            LoginScreenButton(0),
            SizedBox(height: 20),
            LoginScreenButton(1),
          ],
        ),
        // Spacer(),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
            (index) => Expanded(
              child: FlatButton(
                onPressed: () async {
                  if (index == 1) {
                    String url = "https://github.com/Desannemada/PI_Walleties";
                    if (await canLaunch(url)) {
                      launch(url);
                    } else {
                      print("Erro github");
                    }
                  } else {
                    model.changeAtualLoginWidget(DeveloperScreen());
                  }
                },
                child: Text(
                  index == 0 ? "DESENVOLVEDORES" : "GITHUB",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
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

class DeveloperScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    final List<List<String>> developers = [
      ["assets/renato.png", "Desenvolvedor Back-End"],
      ["assets/bruno.png", "Cyber Security"],
      ["assets/neto.png", "Gerente de Projeto"],
      ["assets/anne.png", "	Desenvolvedora Front-End"],
    ];

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // shrinkWrap: true,
        children: [
          Container(
            height: 64,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35,
                    ),
                    onPressed: () =>
                        model.changeAtualLoginWidget(LoginScreenMenu()),
                  ),
                ),
                Logo(10),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                // SizedBox(height: 10),
                Center(
                  child: Text(
                    "Conheça os nossos desenvolvedores:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: "Open Sans",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Developer(developer: developers[0]),
                    Developer(developer: developers[1]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Developer(developer: developers[2]),
                    Developer(developer: developers[3]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Developer extends StatelessWidget {
  Developer({
    @required this.developer,
  });

  final List<String> developer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.38,
      height: MediaQuery.of(context).size.width * 0.38,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.lightBlue,
                width: 2,
              ),
              image: DecorationImage(
                image: AssetImage(developer[0]),
                scale: 5,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            developer[1],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
