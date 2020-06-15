import 'package:flutter/material.dart';

import '../../extra/custom_cursor.dart';

class NavigationBar extends StatelessWidget {
  final bool type;

  NavigationBar({this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: type ? 80 : 60,
            width: type ? 80 : 60,
            child: Image.asset('assets/logo.png'),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              type ? Container() : SizedBox(width: 20),
              NavBarItem('Sobre'),
              SizedBox(width: type ? 60 : 40),
              NavBarItem('Desenvolvedores'),
            ],
          )
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  const NavBarItem(this.title);

  @override
  Widget build(BuildContext context) {
    return CustomCursor(
      cursorStyle: CustomCursor.pointer,
      child: FlatButton(
        child: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {},
      ),
    );
  }
}
