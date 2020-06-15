import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class TabBarLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Material(
      color: Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(50),
      child: CustomCursor(
        cursorStyle: CustomCursor.pointer,
        child: TabBar(
          onTap: (_) => model.updateCurrentTabLogin(),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.blue,
          ),
          tabs: List.generate(
            2,
            (index) => Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                index == 0 ? "Entre" : "Registre-se",
                style: TextStyle(
                  color: index == 0 && model.currentTabLogin ||
                          index == 1 && !model.currentTabLogin
                      ? Colors.black
                      : Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
