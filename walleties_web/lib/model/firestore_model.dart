import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/pages/extra/my_flutter_app_icons.dart';
import 'package:walleties/services/custom_api.dart';

class FirestoreModel with ChangeNotifier {
  int _userContas = 0;
  int get userContas => _userContas;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth get auth => _auth;
  GoogleSignIn get googleSignIn => _googleSignIn;

  void updateUserContas(int contas) {
    _userContas = contas;
    print("updateUserContas");
    notifyListeners();
  }

  List _options = [
    [MyFlutterApp.geral, "Geral"],
    [MyFlutterApp.cog_1, "Configurações"]
  ];
  List get options => _options;
  List _ops = [
    [
      yellow,
      ["Adicionar Cartão", "Remover Cartão"]
    ],
    [
      darkGreen,
      ["Depositar", "Pagar", "Transferir", "Cobrar"]
    ]
  ];
  Color setColor(int i) {
    switch (_options[i][1]) {
      case "Nubank":
        return nubank;
      case "Banco do Brasil":
        return bancodobrasil;
      case "Inter":
        return inter;
      case "Geral":
        return yellow;
      case "Configurações":
        return Colors.black;
      default:
        return _ops[1][0];
    }
  }

  List _currentOption = [
    0,
    "Geral",
    yellow,
    ["Adicionar Cartão", "Remover Cartão"]
  ];
  List get currentOption => _currentOption;

  void updateCurrentOption(int i) {
    print(i);
    _currentOption = [
      i,
      _options[i][1],
      setColor(i),
      i == 0 ? _ops[0][1] : _ops[1][1]
    ];
    notifyListeners();
  }

  List getOptions(int i) {
    return [i, _options[i][1], setColor(i), i == 0 ? _ops[0][1] : _ops[1][1]];
  }

  void resetCards() {
    _options = [
      [MyFlutterApp.geral, "Geral"],
      [MyFlutterApp.cog_1, "Configurações"]
    ];
    _userCards = [];
    notifyListeners();
  }

  void updateOptions(String option) {
    bool aux = false;
    for (var item in _options) {
      if (option == item[1]) {
        aux = true;
      }
    }
    if (!aux) {
      _options.insert(_options.length - 1, [MyFlutterApp.pay, option]);
    }
    notifyListeners();
  }

  List _userCards = [];
  List get userCards => _userCards;
  void updateUserCards(List cards) {
    _userCards.add(cards);
    notifyListeners();
  }

  // List<dynamic> _faturas;

  void getUserContas() async {
    resetCards();
    var contas = await api.getCardsInfo(userInfo[1]);
    print(contas);
    for (var item in contas) {
      updateOptions(item['name_bank']);
      updateUserCards([
        item['name'],
        item['numero'],
        item['venc'],
        item['cvv'],
        item['name_bank'],
        item['agencia'],
        item['conta'],
        item['_id'],
        item['saldo'],
        item['limite'],
      ]);
    }
    updateUserContas(contas.length);
    // var fatura = await api.getFatura(userInfo[1]);

    // DocumentReference documentReference =
    //     Firestore.instance.collection("usuarios").document(userInfo[2]);
    // documentReference.get().then((datasnapshot) {
    //   if (datasnapshot.exists) {
    //     resetCards();
    //     for (var key in datasnapshot.data.keys) {
    //       updateOptions(datasnapshot.data[key.toString()][4].toString());
    //       updateUserCards(datasnapshot.data[key]);
    //     }
    //     updateUserContas(datasnapshot.data.keys.length);
    //   } else {
    //     print("no");
    //   }
    // });
  }

  void addCard(String nome, String numeroCartao, String validade, String cvv,
      String banco, String agencia, String conta) async {
    List<String> data = [
      userInfo[1],
      nome,
      numeroCartao,
      validade,
      cvv,
      banco,
      agencia,
      conta
    ];
    // Firestore.instance
    //     .collection('usuarios')
    //     .document(userInfo[2])
    //     .setData({numeroCartao: data}, merge: true).then((value) {
    //   resetCards();
    //   getUserContas();
    // }, onError: () {
    //   print("Erro");
    // });
    if (userCards.isEmpty) {
      print("hey");
      var res = await api.addNewUser(data);
      if (res.statusCode == 400) {
        print("uh");
        await api.addNewCard(data);
      }
      getUserContas();
    } else {
      print("hi");
      await api.addNewCard(data);
      getUserContas();
    }
  }

  void deleteCard(int index) async {
    // Firestore.instance.collection('usuarios').document(userInfo[2]).updateData(
    //     {userCards[index][1]: FieldValue.delete()}).whenComplete(() {
    //   print("Deletado");
    //   resetCards();
    //   getUserContas();
    // });
    var res = await api.deleteCard(userCards[index][7]);
    if (res.statusCode == 200 || res.statusCode == 201) {
      print("Deletado");
      resetCards();
      getUserContas();
    } else {
      print("Erro ao deletar");
    }
  }

  List userInfo = [
    "Username",
    "usuario@gmail.com",
    "userId",
    "",
  ];

  void updateUserInfo() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      List aux = [
        user.displayName == null ? "Username" : user.displayName,
        user.email != null ? user.email : "usuario@gmail.com",
        user.uid != null ? user.uid : "userId",
        user.photoUrl != null
            ? user.photoUrl
                .replaceAll("s96-c/photo.jpg", "photo.jpg")
                .replaceAll("=s96-c", "")
            : ""
      ];
      updateInfo(aux);
      resetCards();
      getUserContas();
    }
    print("oi");
  }

  String _currentImage;
  String get currentImage => _currentImage;

  void updateCurrentImage(Uri image) {
    print("update image: " + image.toString());
    _currentImage = image.toString();
    notifyListeners();
  }

  void updateInfo(List aux) {
    print("ah");
    userInfo = aux;
    _currentImage = userInfo[3];
    notifyListeners();
  }

  void updateUserDisplayName(String name) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo profile = UserUpdateInfo();
    if (name != null && userInfo[0] != name) {
      profile.displayName = name;
      userInfo[0] = name;
      user.updateProfile(profile);
      notifyListeners();
    }
  }

  void updateUserPhotoURL(String url) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo profile = UserUpdateInfo();
    if (url != null) {
      print("photourl");
      profile.photoUrl = url;
      userInfo[3] = url;
      user.updateProfile(profile);
      notifyListeners();
    }
  }

  CustomAPI api = CustomAPI();
  int errorResponse = 0;

  // Future<List<dynamic>> getInfo() async {
  //   print(await api.getCardsInfo("anne.eleven@hotmail.com"));
  //   print(await api.getFatura("anne.eleven@hotmail.com"));
  // }

  // Future<List<dynamic>> addNewUser(int id) async {
  //   var res = await api.addNewUser(id);
  //   print(res);
  //   return res;
  // }

  FirestoreModel() {
    print("Iniciando FirestoreModel...");
    // api.addNewCard([
    //   "anne.eleven@hotmail.com",
    //   "Fulano Sicrano Beltrano",
    //   "3333.3333.3333.3555",
    //   "31/94",
    //   "999",
    //   "Nubank",
    //   "1111-1",
    //   "11.111-1"
    // ]);
    updateUserInfo();
    print(userCards);
  }
}
