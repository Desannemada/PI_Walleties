import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/main_view_model.dart';

class AboutInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          height: 90,
          child: Row(
            children: [
              FlatButton.icon(
                onPressed: () => model.updateCurrentHomeWidget(0),
                icon: Icon(
                  Icons.arrow_back,
                  color: darkGreen,
                  size: 30,
                ),
                label: Text(
                  "Voltar",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: darkGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 90),
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              children: [Desenvolvedores()],
            ),
          ),
        ),
      ],
    );
  }
}

class Desenvolvedores extends StatelessWidget {
  final List<List<String>> developers = [
    ["assets/renato.png", "Desenvolvedor Back-End"],
    ["assets/bruno.png", "Cyber Security"],
    ["assets/neto.png", "Gerente de Projeto"],
    ["assets/anne.png", "	Desenvolvedora Front-End"],
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: "Conheça os desenvolvedores do  ",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontFamily: "Open Sans",
              ),
              children: [
                TextSpan(
                  text: "Walleties",
                  style: TextStyle(
                    fontSize: 30,
                    color: darkGreen,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Open Sans",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            children: List.generate(
              4,
              (index) => Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.lightBlue,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: AssetImage(developers[index][0]),
                        scale: 5,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    developers[index][1],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
