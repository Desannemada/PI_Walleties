import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/extra/my_flutter_app_icons.dart';
import 'package:walleties_mobile/pages/login_screen.dart';
import 'package:walleties_mobile/services/custom_api.dart';

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

  MainViewModel() {
    _atualLoginWidget = LoginScreenMenu();
    getUserInfo();
    getUserContas();

    //---------------------------------------------
    // for (var i = 0; i < AccountModel().cardsInfo.length; i++) {
    //   updateUserCards(AccountModel().cardsInfo[i]);
    //   updateOptions(AccountModel().cardsInfo[i][4]);
    // }
    //---------------------------------------------
    print("MainViewModel call");
  }

  List<String> _userInfo = [
    "Username",
    "usuario@walleties.com",
    "No ID",
    "assets/profileImage.jpg",
  ];
  List get userInfo => _userInfo;
  void updateUserInfo(List aux) {
    _userInfo = aux;
    print("USERINFO-----" + _userInfo.toString());
    setUserInfo();
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

  Future<bool> setUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> aux = [];

    if (_userInfo.isEmpty) {
      return prefs.setStringList("userInfo", []) ?? false;
    } else {
      aux = _userInfo;
      return prefs.setStringList("userInfo", aux) ?? false;
    }
  }

  Future<bool> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await prefs.getStringList("userInfo") == null) {
      _userInfo = [];
      notifyListeners();
      return false;
    } else {
      List<String> aux = await prefs.getStringList("userInfo");

      _userInfo = aux;
      notifyListeners();
      return true;
    }
  }
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
    notifyListeners();
  }

  void resetCards() {
    _options = [
      [MyFlutterApp.geral, "Geral"],
      [MyFlutterApp.cog_1, "Configurações"]
    ];
    _userCards = [];
    notifyListeners();
  }

  CustomAPI api = CustomAPI();

  void getUserContas() async {
    resetCards();
    var contas = await api.getCardsInfo(userInfo[1]);
    print(contas);
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
    }
  }

  Future<dynamic> addCard(String nome, String numeroCartao, String validade,
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
    var res;
    if (userCards.isEmpty) {
      res = await api.addNewUser(data);
      if (res.statusCode == 400) {
        await api.addNewCard(data);
      }
      getUserContas();
      return true;
    } else {
      res = await api.addNewCard(data);
      if (res.statusCode == 200 || res.statusCode == 201) {
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
}
