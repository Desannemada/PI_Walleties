import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      case "Bradesco":
        return bradesco;
      case "Santander":
        return santander;
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
    // print(i);
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
    print("Getting User Cards Info");
    resetCards();
    var contas = await api.getCardsInfo(userInfo[1]);
    print("CONTAS ->> " + contas.toString());
    if (contas != null) {
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
      // print(userCards);
      getCredito();
      getDebito();
      updateUserContas(contas.length);
    } else {
      updateUserContas(0);
    }

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
      print("AddCard: Trying to add new user");
      var res = await api.addNewUser(data);
      if (res.statusCode == 400) {
        print("AddCard: Error new user, trying new card");
        await api.addNewCard(data);
      }
      getUserContas();
    } else {
      print("AddCard: Trying to add new card");
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

  List faturaDebito = [];

  void getDebito() async {
    faturaDebito = await api.getFaturaDebito(userInfo[1]);
    notifyListeners();

    print("\nFATURA-DEBITO: " + faturaDebito.toString() + "\n");
  }

  List faturaCredito = [];

  void getCredito() async {
    faturaCredito = await api.getFaturaCredito(userInfo[1]);
    // print(faturaCredito);

    notifyListeners();

    print("\nFATURA-CREDITO: " + faturaCredito.toString() + "\n");
  }

  void ops_dep_pag(double valor, int index) async {
    List<String> data = [
      userInfo[1],
      userCards[currentOption[0] - 1][0],
      userCards[currentOption[0] - 1][1],
      userCards[currentOption[0] - 1][2],
      userCards[currentOption[0] - 1][3],
      userCards[currentOption[0] - 1][4],
      userCards[currentOption[0] - 1][5],
      userCards[currentOption[0] - 1][6],
      index == 0
          ? NumberFormat.currency(
                  locale: "pt_br", symbol: '', customPattern: "")
              .format(double.parse(userCards[currentOption[0] - 1][8]
                      .replaceAll('.', '')
                      .replaceAll(',', '.')) +
                  valor)
          : NumberFormat.currency(
                  locale: "pt_br", symbol: '', customPattern: "")
              .format(double.parse(userCards[currentOption[0] - 1][8]
                      .replaceAll('.', '')
                      .replaceAll(',', '.')) -
                  valor),
      userCards[currentOption[0] - 1][7]
    ];

    List<String> opdata = [
      currentOption[1],
      index == 0 ? "Depósito" : "Pagamento",
      NumberFormat.currency(locale: "pt_br", symbol: '', customPattern: "")
          .format(double.parse(
              valor.toString().replaceAll('.', '').replaceAll(',', '.')))
          .toString()
    ];

    var aux = await api.dep_pag(data, opdata);
  }

  List userInfo = [
    "Username",
    "usuario@gmail.com",
    "userId",
    "assets/profileImage.jpg",
  ];

  void updateUserInfo() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      print("Updating User Info...");
      List aux = [
        user.displayName == null ? "Username" : user.displayName,
        user.email != null ? user.email : "usuario@gmail.com",
        user.uid != null ? user.uid : "userId",
        user.photoUrl != null
            ? user.photoUrl
                .replaceAll("s96-c/photo.jpg", "photo.jpg")
                .replaceAll("=s96-c", "")
            : "assets/profileImage.jpg"
      ];
      updateInfo(aux);
      resetCards();
      getUserContas();
    } else {
      print("Error: Updating User Info...");
    }
  }

  String _currentImage;
  String get currentImage => _currentImage;

  void updateCurrentImage(Uri image) {
    print("update image: " + image.toString());
    _currentImage = image.toString();
    notifyListeners();
  }

  void updateInfo(List aux) {
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

  FirestoreModel() {
    print("Iniciando FirestoreModel...");
    updateUserInfo();
  }
}
