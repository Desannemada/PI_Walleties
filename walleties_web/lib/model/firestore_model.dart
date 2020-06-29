import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/main_view_model.dart';
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

  void getUserContas() async {
    print("Getting User Cards Info");
    resetCards();

    var contas = await api.getCardsInfo(userInfo[1]);
    print("\nCONTAS ->> " + contas.toString());
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
      for (var i = 0; i < _options.length; i++) {
        if (_options[i][1] == currentOption[1]) {
          updateCurrentOption(i);
          break;
        }
      }
      getDebitoCredito();
      updateUserContas(contas.length);
    } else {
      updateUserContas(0);
      updateWaiting(true);
    }
  }

  Future<bool> addCard(String nome, String numeroCartao, String validade,
      String cvv, String banco, String agencia, String conta) async {
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

    if (userCards.isEmpty) {
      print("AddCard: Trying to add new user");
      var res = await api.addNewUser(data);
      if (res.statusCode == 400) {
        print("AddCard: Error new user, trying new card");
        var res2 = await api.addNewCard(data);
        if (res2.statusCode == 200 || res2.statusCode == 201) {
          getUserContas();
          return true;
        } else {
          return false;
        }
      } else if (res.statusCode == 200 || res.statusCode == 201) {
        getUserContas();
        return true;
      }
    } else {
      print("AddCard: Trying to add new card");
      var res3 = await api.addNewCard(data);
      if (res3.statusCode == 200 || res3.statusCode == 201) {
        getUserContas();
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> deleteCard(int index) async {
    var res = await api.deleteCard(userCards[index][7]);
    if (res.statusCode == 200 || res.statusCode == 201) {
      print("Deletado");
      resetCards();
      getUserContas();
      return true;
    } else {
      print("Erro ao deletar");
      return false;
    }
  }

  List faturaDebito = [];
  List faturaCredito = [];

  void getDebitoCredito() async {
    faturaDebito = await api.getFaturaDebito(userInfo[1]);
    faturaDebito = faturaDebito.reversed.toList();
    faturaCredito = await api.getFaturaCredito(userInfo[1]);
    faturaCredito = faturaCredito.reversed.toList();
    notifyListeners();

    updateMonths();

    print("\nFATURA-DEBITO: " + faturaDebito.toString() + "\n");
    print("\nFATURA-CREDITO: " + faturaCredito.toString() + "\n");
    updateWaiting(true);
  }

  List<List<String>> _fMonths = [];
  List<List<String>> get fMonths => _fMonths;

  void updateMonths() {
    List<List<String>> monthsD = [];
    List<List<String>> monthsC = [];
    List<String> temp;
    for (var card in userCards) {
      temp = [];
      for (var item in faturaDebito) {
        if (!(temp.contains(
                MainViewModel().getMonthYear(item['data'].substring(0, 7)))) &&
            item['name_bank'] == card[4]) {
          temp.add(MainViewModel().getMonthYear(item['data'].substring(0, 7)));
        }
      }
      if (!(temp.contains(MainViewModel().currentMonth))) {
        temp.add(MainViewModel().currentMonth);
      }
      monthsD.add(temp);
    }

    for (var card in userCards) {
      temp = [];
      for (var item in faturaCredito) {
        if (!(temp.contains(
                MainViewModel().getMonthYear(item['data'].substring(0, 7)))) &&
            item['name_bank'] == card[4]) {
          temp.add(MainViewModel().getMonthYear(item['data'].substring(0, 7)));
        }
      }
      if (!(temp.contains(MainViewModel().currentMonth))) {
        temp.add(MainViewModel().currentMonth);
      }
      monthsC.add(temp);
    }

    List<List<String>> months = [];
    for (var i = 0; i < userCards.length; i++) {
      List<String> aux = monthsD[i] + monthsC[i];
      months.add([]);
      for (var j = 0; j < aux.length; j++) {
        if (!(months[i].contains(aux[j]))) {
          months[i].add(aux[j]);
        }
      }
    }

    _fMonths = months;
    notifyListeners();
  }

  Future<bool> ops_dep_pag(double valor, int index) async {
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

    var response = await api.dep_pag(data, opdata);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  List userInfo = [
    "Username",
    "usuario@gmail.com",
    "userId",
    "assets/profileImage.jpg",
  ];

  bool _waiting;
  bool get waiting => _waiting;
  void updateWaiting(bool aux) {
    _waiting = aux;
    // print("\n\n\nwaiting: " + aux.toString() + "\n\n\n");
    notifyListeners();
  }

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
      updateCurrentOption(0);
      updateInfo(aux);
      getUserContas();
    } else {
      print("Error: Updating User Info...");
      updateWaiting(true);
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
    updateWaiting(true);
    updateUserInfo();
  }
}
