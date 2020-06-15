import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/firestore_model.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 77,
                width: 77,
                child: Card(
                  elevation: 3,
                  shape: CircleBorder(),
                  child: fmodel.userInfo[3] == 'assets/profileImage.jpg'
                      ? Image.asset(
                          'assets/profileImage.jpg',
                          scale: 2.8,
                        )
                      : Image.network(
                          fmodel.userInfo[3],
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 71,
                height: 71,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            fmodel.userInfo[0],
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          ),
          Text(
            fmodel.userInfo[1],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
          SizedBox(height: 5),
          Text(
            "Contas: " + fmodel.userContas.toString(),
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
