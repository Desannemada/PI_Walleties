import 'package:flutter/material.dart';

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
}
