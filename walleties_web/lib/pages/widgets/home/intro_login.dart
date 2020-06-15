import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class IntroLogin extends StatefulWidget {
  final bool type;

  IntroLogin({this.type});

  @override
  _IntroLoginState createState() => _IntroLoginState();
}

class _IntroLoginState extends State<IntroLogin> {
  final List<String> images = [
    "assets/inicioIcon1.png",
    "assets/inicioIcon2.png",
    "assets/inicioIcon3.png",
    "assets/inicioIcon4.png",
    "assets/inicioIcon5.png",
    "assets/inicioIcon6.png"
  ];

  final List<String> frases = [
    "Cadastre cartões",
    "Consulte saldos",
    "Consulte faturas",
    "Pague",
    "Deposite",
    "Transfira"
  ];

  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  _moveScroll(int aux) {
    _controller.animateTo(
        aux == 0
            ? _controller.position.maxScrollExtent
            : _controller.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Container(
      // constraints: BoxConstraints(minWidth: 600, maxWidth: 800),
      alignment: Alignment.center,
      width: widget.type ? 600 : double.infinity,
      child: Column(
        crossAxisAlignment:
            widget.type ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: FittedBox(
              child: Text(
                'WALLETIES',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  height: 0.9,
                  fontSize: 80,
                ),
              ),
            ),
          ),
          Text(
            'CARTEIRA DIGITAL',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              height: 1.2,
              fontSize: 34,
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Nosso aplicativo integra e gerencia todas as suas contas bancárias em um lugar só. \nDeposite, pague, transfira, agilize!',
            textAlign: widget.type ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              height: 1.7,
            ),
          ),
          SizedBox(height: 60),
          Container(
            height: 130,
            child: NotificationListener(
              onNotification: (t) {
                if (_controller.position.pixels ==
                    _controller.position.maxScrollExtent) {
                  model.updateIntroListScroll(true);
                } else if (_controller.position.pixels ==
                    _controller.position.minScrollExtent) {
                  model.updateIntroListScroll(false);
                }
                return true;
              },
              child: ListView.separated(
                controller: _controller,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 20),
                itemCount: 6,
                itemBuilder: (context, index) => Container(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(images[index]),
                      SizedBox(height: 10),
                      Text(
                        frases[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: List.generate(
              2,
              (index) => Expanded(
                child: Container(
                  height: 11,
                  child: CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      color: index == 0 && model.introListScroll ||
                              index == 1 && !model.introListScroll
                          ? Colors.grey
                          : Colors.white,
                      onPressed: () =>
                          index == 1 ? _moveScroll(0) : _moveScroll(1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
