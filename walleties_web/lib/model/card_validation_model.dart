import 'package:flutter/material.dart';

class CardValidationItem {
  final String value;
  final String error;

  CardValidationItem(this.value, this.error);
}

class CardValidationModel with ChangeNotifier {
  List<CardValidationItem> _cvi = [
    CardValidationItem(null, null),
    CardValidationItem(null, null),
    CardValidationItem(null, null),
    CardValidationItem(null, null),
    CardValidationItem(null, null),
    CardValidationItem(null, null)
  ];

  //Getter
  List<CardValidationItem> get cvi => _cvi;
  bool get isValid {
    if (_cvi[0].value != null &&
        _cvi[1].value != null &&
        _cvi[2].value != null &&
        _cvi[3].value != null &&
        _cvi[4].value != null &&
        _cvi[5].value != null) {
      print("true");
      return true;
    } else {
      print("false");
      return false;
    }
  }

  //Setter
  void updateItem(String value, int index) {
    switch (index) {
      case 0: //Nome
        {
          if (value.length <= 20) {
            cvi[0] = CardValidationItem(value, null);
          } else {
            cvi[0] = CardValidationItem(null, "Máximo de 20 caracteres");
          }
        }
        break;
      case 1: //Número Cartão
        {
          RegExp regExp =
              new RegExp(r"([0-9]{4}[-][0-9]{4}[-][0-9]{4}[-][0-9]{4})");
          if (value.length == 19 && regExp.hasMatch(value)) {
            cvi[1] = CardValidationItem(value, null);
          } else {
            cvi[1] = CardValidationItem(null, "Formato inválido");
          }
        }
        break;
      case 2: //Validade
        {
          RegExp regExp = new RegExp(r"([0-9]{2}[/]{1}[0-9]{2})");
          if (value.length == 5 && regExp.hasMatch(value)) {
            cvi[2] = CardValidationItem(value, null);
          } else {
            cvi[2] = CardValidationItem(null, "Formato inválido");
          }
        }
        break;
      case 3: //CVV
        {
          if ((value.length == 3 || value.length == 4) &&
              double.tryParse(value) != null) {
            cvi[3] = CardValidationItem(value, null);
          } else {
            cvi[3] = CardValidationItem(null, "Formato inválido");
          }
        }
        break;
      case 4: //Agência
        {
          if (value != "") {
            cvi[4] = CardValidationItem(value, null);
          } else {
            cvi[4] = CardValidationItem(null, "Campo obrigatório");
          }
        }
        break;
      case 5: //Conta
        {
          if (value != "") {
            cvi[5] = CardValidationItem(value, null);
          } else {
            cvi[5] = CardValidationItem(null, "Campo obrigatório");
          }
        }
        break;
    }

    notifyListeners();
  }

  //Clean
  void cleanValidation() {
    _cvi = [
      CardValidationItem(null, null),
      CardValidationItem(null, null),
      CardValidationItem(null, null),
      CardValidationItem(null, null),
      CardValidationItem(null, null),
      CardValidationItem(null, null)
    ];
    notifyListeners();
  }
}
