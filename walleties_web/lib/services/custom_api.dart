/*
* Operações de integração com WS (API)
*/

import 'dart:convert';

import 'package:walleties/services/api.dart';
import 'package:http/http.dart' as http;

class CustomAPI extends API {
  static CustomAPI _api;

  CustomAPI();

  static CustomAPI instance() {
    if (_api == null) {
      _api = CustomAPI();
    }

    return _api;
  }

  Future<List<dynamic>> getFatura(String email) async {
    var response = await http
        .get("http://bankapi123.herokuapp.com/card-info/mostra/$email");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Erro: " + response.statusCode.toString());
    }
  }

  Future<List<dynamic>> getCardsInfo(String email) async {
    var response = await http
        .get("http://bankapi123.herokuapp.com/card-info/card_list/$email");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Erro: " + response.statusCode.toString());
    }
  }

  Future<http.Response> addNewUser(List<String> info) async {
    var url = "https://bankapi123.herokuapp.com/card-info";
    Map data = {
      'person_email': info[0],
      'cards_list': [
        {
          'name': info[1],
          'numero': info[2],
          'venc': info[3],
          'cvv': info[4],
          'name_bank': info[5],
          'agencia': info[6],
          "conta": info[7],
        }
      ],
    };
    String body = json.encode(data);
    print("NEW_USER: " + body);

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 201) {
      return response;
    } else {
      print("Erro: " + response.statusCode.toString());
      return response;
    }
  }

  Future<http.Response> addNewCard(List<String> info) async {
    var url = "http://bankapi123.herokuapp.com/card-info/add_card/${info[0]}";
    print(url);
    Map data = {
      'cards_list': {
        'name': info[1],
        'numero': info[2],
        'venc': info[3],
        'cvv': info[4],
        'name_bank': info[5],
        'agencia': info[6],
        "conta": info[7],
      },
    };
    print("DATA: " + data.toString());
    String body = json.encode(data);
    print("NEW_CARD: " + body);

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      print("Erro: " + response.statusCode.toString());
    }
  }

  Future<http.Response> deleteCard(String id) async {
    var url = "http://bankapi123.herokuapp.com/card-info/sai_cartao/$id";

    var response = await http.delete(
      url,
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      print("Erro: " + response.statusCode.toString());
    }
  }
}
