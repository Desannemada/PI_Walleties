import 'package:flutter/material.dart';
import 'dart:html' as html;

class MainViewModel with ChangeNotifier {
  //user info-------------------------------------------

  //-----------------------------------------------------

  bool _introListScroll = false;
  bool get introListScroll => _introListScroll;

  updateIntroListScroll(bool aux) {
    _introListScroll = aux;
    notifyListeners();
  }

  bool _currentTabLogin = false;
  bool get currentTabLogin => _currentTabLogin;

  updateCurrentTabLogin() {
    _currentTabLogin = !_currentTabLogin;
    notifyListeners();
  }

  bool _isDrawerOpen = true;
  bool get isDrawerOpen => _isDrawerOpen;
  updateIsDrawerOpen() {
    _isDrawerOpen = !_isDrawerOpen;
    print("drawer");
    notifyListeners();
  }

  bool _isConfigDown = false;
  bool get isConfigDown => _isConfigDown;
  updateisConfigDown(bool aux) {
    _isConfigDown = aux;
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

  int _currentHomeWidget = 0;
  int get currentHomeWidget => _currentHomeWidget;
  updateCurrentHomeWidget(int aux) {
    _currentHomeWidget = aux;
    notifyListeners();
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

  bool _currentMobileHomeWidget = true;
  bool get currentMobileHomeWidget => _currentMobileHomeWidget;
  void updateCurrentMobileHomeWidget(bool aux) {
    _currentMobileHomeWidget = aux;
    notifyListeners();
  }

  var _iOS = [
    'iPad Simulator',
    'iPhone Simulator',
    'iPod Simulator',
    'iPad',
    'iPhone',
    'iPod'
  ];

  bool isIOS() {
    var matches = false;
    _iOS.forEach((name) {
      if (html.window.navigator.platform.contains(name) ||
          html.window.navigator.userAgent.contains(name)) {
        matches = true;
      }
    });
    return matches;
  }

  MainViewModel() {
    _currentMonth =
        getMonth(DateTime.now().month) + " " + DateTime.now().year.toString();
    updateisConfigDown(false);
  }
}
