import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/models/main_view_model.dart';

class FaturaInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return !model.whichAbaFatura
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Text(
                  "Recentes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  separatorBuilder: (context, index) => Divider(height: 30),
                  itemBuilder: (context, index) => Row(
                    children: [
                      Text(
                        "10/10/10",
                        style: TextStyle(
                          color: model.currentOption[2].withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "Informação",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      )),
                      Text(
                        "R\$ 100,00",
                        style: TextStyle(
                          color: model.currentOption[2].withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text("Ah"),
          );
  }
}
