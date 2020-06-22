import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/extra/my_flutter_app_icons.dart';
import 'package:walleties_mobile/pages/login_screen.dart';
import 'package:walleties_mobile/services/custom_api.dart';
import 'package:intl/intl.dart';

class MainViewModel with ChangeNotifier {
  Widget _atualLoginWidget;
  Widget get atualLoginWidget => _atualLoginWidget;
  void changeAtualLoginWidget(Widget novo) {
    _atualLoginWidget = novo;
    notifyListeners();
  }

  bool _isConfigDown = false;
  bool get isConfigDown => _isConfigDown;
  updateisConfigDown(bool aux) {
    _isConfigDown = aux;
    notifyListeners();
  }

  bool _isTapped = false;
  bool get isTapped => _isTapped;
  updateIsTapped(bool aux) {
    _isTapped = aux;
    notifyListeners();
  }

  bool _whichAbaFatura = false;
  bool get whichAbaFatura => _whichAbaFatura;
  void updateWhichAbaFatura() {
    _whichAbaFatura = !_whichAbaFatura;
    notifyListeners();
  }

  int _chooseCobCard = 0;
  int get chooseCobCard => _chooseCobCard;
  void updateChooseCobCard(int i) {
    _chooseCobCard = i;
    notifyListeners();
  }

  bool _showQRCode = false;
  bool get showQRCode => _showQRCode;
  void updateShowQRCode(bool aux) {
    _showQRCode = aux;
    notifyListeners();
  }

  String _infoQRCode = "";
  String get infoQRCode => _infoQRCode;
  void updateInfoQRCode(String aux) {
    _infoQRCode = aux;
    notifyListeners();
  }

  List _infogetQRCode = [];
  List get infogetQRCode => _infogetQRCode;
  void updateInfogetQRCode(List aux) {
    _infogetQRCode = aux;
    notifyListeners();
  }

  List _checks = [];
  List get checks => _checks;
  void updateChecks() {
    _checks = [];
    for (var i = 0; i < userCards.length; i++) {
      if (i == _chooseCobCard) {
        checks.add(Icon(Icons.check_box));
      } else {
        checks.add(Icon(Icons.check_box_outline_blank));
      }
    }
    notifyListeners();
  }

  MainViewModel() {
    _atualLoginWidget = LoginScreenMenu();
    updateUserInfo();
    // getUserInfo();
    // getUserContas();

    //---------------------------------------------
    // for (var i = 0; i < AccountModel().cardsInfo.length; i++) {
    //   updateUserCards(AccountModel().cardsInfo[i]);
    //   updateOptions(AccountModel().cardsInfo[i][4]);
    // }
    //---------------------------------------------
    print("MainViewModel call");
  }

  List _userInfo = [
    "Username",
    "usuario@walleties.com",
    "No ID",
    "assets/profileImage.jpg",
  ];
  List get userInfo => _userInfo;
  void updateUserInfo(/*List aux*/) async {
    // _userInfo = aux;
    // print("USERINFO-----" + _userInfo.toString());
    // // setUserInfo();
    // notifyListeners();
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
      // resetCards();
      getUserContas();
    } else {
      print("Error: Updating User Info...");
    }
  }

  String _currentImage;
  String get currentImage => _currentImage;
  void updateInfo(List aux) {
    _userInfo = aux;
    _currentImage = userInfo[3];
    notifyListeners();
  }

  bool _isAddCardFormOpen = false;
  bool get isAddCardFormOpen => _isAddCardFormOpen;

  void updateIsAddCardFormOpen(bool aux) {
    _isAddCardFormOpen = aux;
    notifyListeners();
  }

  List<String> _banks = [
    "Banco do Brasil",
    "Bradesco",
    "Nubank",
    "Santander",
    "Inter"
  ];
  List<String> get banks => _banks;

  String _chosenBank = "Banco do Brasil";
  String get chosenBank => _chosenBank;
  updateChosenBank(String bank) {
    _chosenBank = bank;
    notifyListeners();
  }

  String _chosenBankT = "Banco do Brasil";
  String get chosenBankT => _chosenBankT;
  updateChosenBankT(String bank) {
    _chosenBankT = bank;
    notifyListeners();
  }

  // Future<bool> setUserInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> aux = [];

  //   if (_userInfo.isEmpty) {
  //     return prefs.setStringList("userInfo", []) ?? false;
  //   } else {
  //     aux = _userInfo;
  //     return prefs.setStringList("userInfo", aux) ?? false;
  //   }
  // }

  // Future<bool> getUserInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if (await prefs.getStringList("userInfo") == null) {
  //     _userInfo = [];
  //     notifyListeners();
  //     return false;
  //   } else {
  //     List<String> aux = await prefs.getStringList("userInfo");

  //     _userInfo = aux;
  //     notifyListeners();
  //     getUserContas();
  //     return true;
  //   }
  // }
  //------------------------------------------------------------------------

  List _options = [
    [MyFlutterApp.geral, "Geral"],
    [MyFlutterApp.cog_1, "Configurações"],
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

  void updateOptions(String option) {
    _options.insert(_options.length - 1, [MyFlutterApp.pay, option]);
    notifyListeners();
  }

  List _userCards = [];
  List get userCards => _userCards;
  void updateUserCards(List cards) {
    _userCards.add(cards);
    updateChecks();
    notifyListeners();
  }

  void resetCards() {
    _options = [
      [MyFlutterApp.geral, "Geral"],
      [MyFlutterApp.cog_1, "Configurações"]
    ];
    _userCards = [];
  }

  CustomAPI api = CustomAPI();

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
      getCredito();
      getDebito();
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

    var val =
        NumberFormat.currency(locale: "pt_br", symbol: '', customPattern: "")
            .format(double.parse(valor.toString().replaceAll(',', '.')))
            .toString();
    // print("VAL: " + val);
    List<String> opdata = [
      currentOption[1],
      index == 0 ? "Depósito" : "Pagamento",
      val
    ];

    var response = await api.dep_pag(data, opdata);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
