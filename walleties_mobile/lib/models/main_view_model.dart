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
  void updateWhichAbaFatura(bool aux) {
    _whichAbaFatura = aux;
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

  String _cobMoney = "";
  String get cobMoney => _cobMoney;
  void updateCobMoney(String m) {
    _cobMoney = m;
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

  List _sliders = [];
  List get sliders => _sliders;
  void createSliders() {
    _sliders = [];
    for (var i = 0; i < userCards.length; i++) {
      _sliders.add(0.0);
    }
    notifyListeners();
  }

  void updateSliders(double value, int i) {
    _sliders[i] = value;
    notifyListeners();
  }

  double getMaxSliders(int index) {
    double value = 0.0;
    for (var i = 0; i < sliders.length; i++) {
      if (i != index) {
        value = value + sliders[i];
      }
    }
    return value;
  }

  MainViewModel() {
    print("\nIniciando MainViewModel...\n");
    _atualLoginWidget = LoginScreenMenu();
    updateWaiting(false);
    _currentMonth =
        getMonth(DateTime.now().month) + " " + DateTime.now().year.toString();
    updateUserInfo();
    updateisConfigDown(false);
  }

  List _userInfo = [
    "Username",
    "usuario@walleties.com",
    "No ID",
    "assets/profileImage.jpg",
  ];
  List get userInfo => _userInfo;
  void updateUserInfo() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      print("\nUpdating User Info...\n");
      List aux = [
        user.displayName == null
            ? "Username"
            : user.displayName == "" ? "Username" : user.displayName,
        user.email != null ? user.email : "usuario@walleties.com",
        user.uid != null ? user.uid : "userId",
        user.photoUrl != null
            ? user.photoUrl
                .replaceAll("s96-c/photo.jpg", "photo.jpg")
                .replaceAll("=s96-c", "")
            : "assets/profileImage.jpg"
      ];
      print(aux);
      updateCurrentOption(0);
      updateInfo(aux);
      getUserContas();
    } else {
      print("\nError: Updating User Info...\n");
      updateWaiting(true);
    }
  }

  bool _waiting;
  bool get waiting => _waiting;
  void updateWaiting(bool aux) {
    _waiting = aux;
    // print("\n\n\nwaiting: " + aux.toString() + "\n\n\n");
    notifyListeners();
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
    createPagControllers();
    notifyListeners();
  }

  void resetCards() {
    _options = [
      [MyFlutterApp.geral, "Geral"],
      [MyFlutterApp.cog_1, "Configurações"]
    ];
    _userCards = [];
    faturaCredito = [];
    faturaDebito = [];
  }

  CustomAPI api = CustomAPI();

  void getUserContas() async {
    print("\nGetting User Cards Info\n");
    resetCards();

    var contas = await api.getCardsInfo(userInfo[1]);
    print("\nCONTAS ->> " + contas.toString() + "\n");
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
      // createSliders();
    } else {
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
      print("\nAddCard: Trying to add new user\n");
      var res = await api.addNewUser(data);
      if (res.statusCode == 400) {
        print("\nAddCard: Error new user, trying new card\n");
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
      print("\nAddCard: Trying to add new card\n");
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
      print("\nDeletado\n");
      resetCards();
      getUserContas();
      return true;
    } else {
      print("\nErro ao deletar\n");
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
        if (!(temp.contains(getMonthYear(item['data'].substring(0, 7)))) &&
            item['name_bank'] == card[4]) {
          temp.add(getMonthYear(item['data'].substring(0, 7)));
        }
      }
      if (!(temp.contains(_currentMonth))) {
        temp.add(_currentMonth);
      }
      monthsD.add(temp);
    }

    for (var card in userCards) {
      temp = [];
      for (var item in faturaCredito) {
        if (!(temp.contains(getMonthYear(item['data'].substring(0, 7)))) &&
            item['name_bank'] == card[4]) {
          temp.add(getMonthYear(item['data'].substring(0, 7)));
        }
      }
      if (!(temp.contains(_currentMonth))) {
        temp.add(_currentMonth);
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

    // print(months);

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

    var val =
        NumberFormat.currency(locale: "pt_br", symbol: '', customPattern: "")
            .format(valor)
            .toString();
    // print("VAL: " + val);
    List<String> opdata = [
      currentOption[1],
      index == 0 ? "Depósito" : "Pagamento",
      val
    ];

    var response = await api.dep_pag(data, opdata);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('\nOperação Concluida\n');
      return true;
    } else {
      print('\nOperação Falhou\n');
      return false;
    }
  }

  Future<List> qrPagamento() async {}

  bool _avaliacoesWaiting = false;
  bool get avaliacoesWaiting => _avaliacoesWaiting;
  void updateAvaliacoesWaiting(bool aux) {
    _avaliacoesWaiting = aux;
    notifyListeners();
  }

  bool _pagWaiting = false;
  bool get pagWaiting => _pagWaiting;
  void updatePagWaiting(bool aux) {
    _pagWaiting = aux;
    notifyListeners();
  }

  List _avaliacoes = [];
  List get avaliacoes => _avaliacoes;
  void avaliarCartoes() async {
    // print(pagValues);
    _avaliacoes = [];
    List fatura = [];
    List aux = [];
    for (var i = 0; i < userCards.length; i++) {
      aux = [];
      for (var item in faturaDebito) {
        if (item['name_bank'] == getOptions(i + 1)[1]) {
          // print("SIM " + item['valor']);
          double valor = double.parse(
              item['valor'].replaceAll('.', '').replaceAll(',', '.'));
          if (item['item'] == "Depósito") {
            aux.add([valor, "Deposito"]);
          } else {
            aux.add([valor - (valor * 2), "pagamento"]);
          }
        }
      }
      fatura.add(aux);
    }
    for (var i = 0; i < fatura.length; i++) {
      _avaliacoes.add(await api.avaliarCartao(fatura[i]));
      if (i == fatura.length - 1) {
        updateAvaliacoesWaiting(false);
      }
    }

    // print("\n\n" + _avaliacoes.toString() + "\n\n");

    notifyListeners();
  }

  Future<List<bool>> updateFaturaCredito() async {
    List<bool> results = [];
    for (var i = 0; i < pagValues.length; i++) {
      if (pagValues[i] != "" && pagValues[i] != "0,00") {
        List info = [
          userInfo[1],
          getOptions(i + 1)[1],
          "Walleties Pay: " + infogetQRCode[0],
          pagValues[i],
        ];
        var res = await api.updateFat(info);
        if (res.statusCode == 200 || res.statusCode == 201) {
          results.add(true);
        } else {
          results.add(false);
        }
      } else {
        results.add(false);
      }
    }
    return results;
  }

  String getMoney(String valor) {
    return NumberFormat.currency(
      locale: "pt_br",
      symbol: 'R\$',
    )
        .format(double.parse(valor.replaceAll('.', '').replaceAll(',', '.')))
        .toString();
  }

  String getSingular(int i, int index) {
    double result = 0;
    if (index == 2) {
      result = double.parse(
          userCards[i][8].replaceAll('.', '').replaceAll(',', '.'));
    } else if (index == 0) {
      for (var compra in faturaCredito) {
        if (compra['name_bank'] == userCards[i][4]) {
          result = result +
              double.parse(
                  compra['valor'].replaceAll('.', '').replaceAll(',', '.'));
        }
      }
    } else if (index == 1) {
      result = double.parse(
              userCards[i][9].replaceAll('.', '').replaceAll(',', '.')) -
          double.parse(getSingular(i, 0)
              .substring(4)
              .replaceAll('.', '')
              .replaceAll(',', '.'));
    }
    return NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ')
        .format(result);
  }

  Future<int> updateUserDisplayName(String name) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo profile = UserUpdateInfo();
    if (userInfo[0] == name) {
      return 0;
    }
    if (name != null) {
      profile.displayName = name;
      userInfo[0] = name;
      user.updateProfile(profile);
      notifyListeners();
      return 1;
    }
    return 2;
  }

  Future<int> updateUserPhotoURL(String url) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo profile = UserUpdateInfo();
    if (editProfileInfo[1] == null) {
      return 0;
    }
    if (url != null) {
      // print("\nphotourl\n");
      profile.photoUrl = url;
      userInfo[3] = url;
      user.updateProfile(profile);
      notifyListeners();
      return 1;
    } else {
      return 2;
    }
  }

  List _meses = [
    ["Janeiro", 1],
    ["Fevereiro", 2],
    ["Março", 3],
    ["Abril", 4],
    ["Maio", 5],
    ["Junho", 6],
    ["Julho", 7],
    ["Agosto", 8],
    ["Setembro", 9],
    ["Outubro", 10],
    ["Novembro", 11],
    ["Dezembro", 12],
  ];
  List get meses => _meses;
  String getMonth(int i) {
    for (var item in _meses) {
      if (item[1] == i) {
        return item[0];
      }
    }
  }

  int getMonthInt(String month) {
    for (var item in _meses) {
      if (item[0] == month.substring(0, month.length - 5)) {
        return item[1];
      }
    }
  }

  String getMonthYear(String date) {
    return getMonth(int.parse(date.substring(5, 7))) +
        " " +
        date.substring(0, 4);
  }

  List<List<String>> _cardMonths = [];
  List<List<String>> get cardMonths => _cardMonths;

  List<List<List<String>>> _past_future_faturas = [];
  List<List<List<String>>> get past_future_faturas => _past_future_faturas;

  void updateCardMonths(List<List<String>> months) {
    _cardMonths = months;
    _past_future_faturas = [];
    for (var i = 0; i < months.length; i++) {
      past_future_faturas.add([[], []]);
      for (var j = 0; j < months[i].length; j++) {
        if (getMonthInt(months[i][j]) < getMonthInt(_currentMonth)) {
          past_future_faturas[i][0].add(months[i][j]);
        }
        if (getMonthInt(months[i][j]) > getMonthInt(_currentMonth)) {
          past_future_faturas[i][1].add(months[i][j]);
        }
      }
    }

    notifyListeners();
  }

  String _currentMonth = "";
  String get currentMonth => _currentMonth;
  void updateCurrentMonth(String newMonth) {
    _currentMonth = newMonth;
    notifyListeners();
  }

  List<TextEditingController> _pagControllers = [];
  List<TextEditingController> get pagControllers => _pagControllers;
  void createPagControllers() {
    _pagControllers = [];
    for (var item in userCards) {
      _pagControllers.add(TextEditingController(text: ""));
    }
    createPagValues();
    notifyListeners();
  }

  List<String> _pagValues = [];
  List<String> get pagValues => _pagValues;
  void createPagValues() {
    _pagValues = [];
    for (var item in userCards) {
      _pagValues.add("");
    }
    notifyListeners();
  }

  void updatePagValues(String value, int index) {
    _pagValues[index] = value;
    // print(_pagValues);
    ///////////////////////////
    _pagTotal = "0,00";
    double aux = 0.0;
    for (var item in pagValues) {
      try {
        aux = aux + double.parse(item.replaceAll(".", "").replaceAll(",", "."));
      } catch (e) {}
    }
    _pagTotal =
        NumberFormat.currency(locale: "pt_br", symbol: "", customPattern: "")
            .format(aux);
    notifyListeners();
  }

  String _pagTotal = "0,00";
  String get pagTotal => _pagTotal;
  // void updatePagTotal() {
  //   notifyListeners();
  // }

  bool checkLimiteDisponivel() {
    bool aux = true;
    for (var i = 0; i < pagValues.length; i++) {
      double value =
          double.parse(pagValues[i].replaceAll('.', '').replaceAll(',', '.'));
      double disponivel = double.parse(getSingular(i, 1)
          .substring(3)
          .replaceAll('.', '')
          .replaceAll(',', '.'));
      if (disponivel - value < 0) {
        aux = false;
      }
    }
    // print(aux);
    return aux;
  }

  bool checkOpPagDisponivel(double value) {
    bool aux = true;

    double disponivel = double.parse(getSingular(currentOption[0] - 1, 2)
        .substring(3)
        .replaceAll('.', '')
        .replaceAll(',', '.'));

    if (disponivel - value < 0) {
      aux = false;
    }
    // print(aux);
    return aux;
  }

  int _chosenConta = 0;
  int get chosenConta => _chosenConta;
  void updateChosenConta(int aux) {
    _chosenConta = aux;
    notifyListeners();
  }

  List _editProfileInfo = [false, null];
  List get editProfileInfo => _editProfileInfo;
  void updateEditProfileInfo(var aux, int i) {
    _editProfileInfo[i] = aux;
    notifyListeners();
  }
}
