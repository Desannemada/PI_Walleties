import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/firestore_model.dart';

class CreditoDebitoInfo extends StatelessWidget {
  final int type;

  CreditoDebitoInfo({this.type});

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 30,
      children: List.generate(
        2,
        (index) => Container(
          width: type != 1 ? 520 : 700,
          height: type != 1 ? 720 : 420,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FractionallySizedBox(
                heightFactor: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      index == 0 ? "Crédito" : "Débito",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: fmodel.currentOption[2],
                      ),
                    ),
                    Divider(
                      height: 40,
                      thickness: 0.5,
                      indent: 30,
                      endIndent: 30,
                      color: Colors.black,
                    ),
                    // CredDebFatura(
                    //   type: type,
                    //   path: index == 0 ? "NA" : "NA",
                    // )
                    Text("Not connected yet")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class CredDebFatura extends StatelessWidget {
//   final int type;
//   final path;

//   CredDebFatura({@required this.type, @required this.path});

//   @override
//   Widget build(BuildContext context) {
//     final fmodel = Provider.of<FirestoreModel>(context);

//     return SizedBox(
//       height: type != 1 ? 605 : 305,
//       child: ListView.separated(
//         shrinkWrap: true,
//         itemCount: path.length,
//         separatorBuilder: (context, index) => SizedBox(height: 20),
//         itemBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 5,
//           ),
//           child: CustomCursor(
//             cursorStyle: CustomCursor.pointer,
//             child: FlatButton(
//               onPressed: () {},
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text(
//                     path[index]['data'],
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                       color: fmodel.currentOption[2],
//                     ),
//                   ),
//                   ConstrainedBox(
//                     constraints: BoxConstraints(
//                       maxWidth: type != 2 ? 220 : 160,
//                     ),
//                     child: Text(
//                       path[index]['name'],
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     path[index]['money'],
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                       color: fmodel.currentOption[2],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
