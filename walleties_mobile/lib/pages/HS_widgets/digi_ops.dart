import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/extra/my_flutter_app_icons.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/operacoes.dart';

class DigiOps extends StatelessWidget {
  final int index;
  DigiOps(this.index);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          index == 1 && model.infogetQRCode.length > 2
              ? FlatButton(
                  onPressed: () {
                    model.updateInfogetQRCode([]);
                    for (var i = 0; i < model.userCards.length; i++) {
                      model.pagControllers[i].clear();
                    }
                  },
                  child: Text(
                    "Repetir",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(),
          index == 1 && model.infogetQRCode.length > 2
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text(
                          "Avaliação de Cartões",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "O Walleties utiliza a API NSFF que verifica suas contas no período atual e retorna um valor positivo ou negativo afim de lhe informar o estado de seu balanço atual.",
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("Positivo")
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("Negativo")
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          Center(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: darkGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                  ),
                )
              : Container()
        ],
        title: Text(
          index == 0 ? "Cobrar" : "Pagar",
          style: TextStyle(
            color: model.currentOption[2],
          ),
        ),
      ),
      body: !model.avaliacoesWaiting
          ? index == 0 ? DigiOpCobrar() : DigiOpPagar()
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

class DigiOpPagar extends StatefulWidget {
  @override
  _DigiOpPagarState createState() => _DigiOpPagarState();
}

class _DigiOpPagarState extends State<DigiOpPagar> {
  Future<String> scan() async {
    try {
      var result = await BarcodeScanner.scan();
      return result.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        return "Permissão não foi concedida";
      } else {
        return "Erro";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    NumberFormat oCcy = new NumberFormat.currency(locale: 'eu', symbol: "");
    List ops = ["NOME: ", "AGÊNCIA: ", "CONTA: ", "VALOR: "];
    List ops2 = ["Fatura", "Disponível", "Saldo"];

    return model.infogetQRCode.length == 5
        ? Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    "Informarções do Pagamento",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ops[index],
                            style: TextStyle(
                              fontSize: 18,
                              color: yellow,
                            ),
                          ),
                          Text(
                            index != 3
                                ? model.infogetQRCode[index]
                                : NumberFormat.currency(
                                    locale: "pt_br",
                                    symbol: 'R\$',
                                  )
                                    .format(double.parse(model
                                        .infogetQRCode[index]
                                        .replaceAll('.', '')
                                        .replaceAll(',', '.')))
                                    .toString(),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Escolha sua forma de pagamento: ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 15),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: model.userCards.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: model.avaliacoes[index]
                                                      ['status'] ==
                                                  "positivo"
                                              ? Colors.green
                                              : Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: model.getOptions(index + 1)[2],
                                        ),
                                        child: Center(
                                          child: Text(
                                            model.getOptions(index + 1)[1][0],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.userCards[index][0],
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "****-****-****-" +
                                            model.userCards[index][1]
                                                .substring(15),
                                        style: TextStyle(
                                          color: model.getOptions(index + 1)[2],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                model.getOptions(index + 1)[2],
                                          ),
                                        ),
                                        child: Form(
                                          child: TextFormField(
                                            controller:
                                                model.pagControllers[index],
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter(
                                                RegExp("[0-9,.]"),
                                              )
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              labelText: "Valor",
                                              hintText: "10,00",
                                              counter: Text(
                                                model.pagValues[index].isEmpty
                                                    ? "R\$ 0,00"
                                                    : "R\$ " +
                                                        model.pagValues[index],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              try {
                                                model.updatePagValues(
                                                    oCcy.format(double.parse(
                                                        model
                                                            .pagControllers[
                                                                index]
                                                            .text
                                                            .replaceAll(".", "")
                                                            .replaceAll(
                                                                ",", "."))),
                                                    index);
                                              } catch (e) {
                                                print(
                                                    "Error UpdatePagValues: " +
                                                        e.message +
                                                        "\n");
                                                if (model.pagControllers[index]
                                                    .text.isEmpty) {
                                                  model.updatePagValues(
                                                      "0,00", index);
                                                } else {
                                                  model.updatePagValues(
                                                      "inválido", index);
                                                }
                                              }
                                              // print(model.pagValues);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(
                                    3,
                                    (i) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(ops2[i]),
                                        Text(
                                          model.getSingular(index, i),
                                          style: TextStyle(
                                            color:
                                                model.getOptions(index + 1)[2],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 5)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "R\$ " + model.pagTotal.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 10, top: 25),
                  child: model.pagWaiting
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          child: Text(
                            "Pagar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () async {
                            var aux = true;
                            for (var item in model.pagValues) {
                              if (item == "inválido") {
                                aux = false;
                              }
                            }
                            if (model.pagTotal == model.infogetQRCode[3]) {
                              if (aux) {
                                if (model.checkLimiteDisponivel()) {
                                  model.updatePagWaiting(true);
                                  var res = await model.updateFaturaCredito();
                                  if (res is List<bool>) {
                                    model.updatePagWaiting(false);
                                  }

                                  showDialog(
                                    context: context,
                                    child: WillPopScope(
                                      onWillPop: () {
                                        bool aux = true;
                                        for (var item in res) {
                                          if (item) {
                                            aux = false;
                                          }
                                        }
                                        if (aux) {
                                          model.getUserContas();
                                        }
                                        model.updateInfogetQRCode([]);
                                        for (var i = 0;
                                            i < model.userCards.length;
                                            i++) {
                                          model.pagControllers[i].clear();
                                        }
                                        // Navigator.of(context).pop();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        return Future.value(true);
                                      },
                                      child: AlertDialog(
                                        title: Text("Pagamento"),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            res.length,
                                            (index) {
                                              return model.pagValues[index] !=
                                                          "0,00" &&
                                                      model.pagValues[index] !=
                                                          ""
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          model.getOptions(
                                                              index + 1)[1],
                                                          style: TextStyle(
                                                            color: model
                                                                .getOptions(
                                                                    index +
                                                                        1)[2],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              res[index]
                                                                  ? "Concluído"
                                                                  : "Erro",
                                                            ),
                                                            Text(
                                                              "R\$ " +
                                                                  model.pagValues[
                                                                      index],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Container();
                                            },
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              bool aux = false;
                                              for (var item in res) {
                                                if (item) {
                                                  aux = true;
                                                }
                                              }
                                              if (aux) {
                                                model.getUserContas();
                                              }
                                              model.updatePagWaiting(false);
                                              model.updateInfogetQRCode([]);
                                              for (var i = 0;
                                                  i < model.userCards.length;
                                                  i++) {
                                                model.pagControllers[i].clear();
                                              }
                                              Navigator.of(context).pop();
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            },
                                            child: Center(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                  color: darkGreen,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  showDialog(
                                      context: context, child: OpDialog(0, 4));
                                }
                              } else {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showDialog(
                                    context: context, child: OpDialog(0, 5));
                              }
                            } else {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showDialog(
                                  context: context, child: OpDialog(0, 3));
                            }
                          },
                          color: Colors.blue,
                        ),
                ),
              ],
            ),
          )
        : Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: double.infinity,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    scale: 5,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Realize seu pagamento com o Walleties",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    child: Text(
                      "Scannear QR Code",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue,
                    onPressed: () async {
                      String res = await scan();
                      // print("\n\n" + res + "\n\n");
                      List aux = res.split("+");
                      for (var i = 0; i < model.userCards.length; i++) {
                        model.pagControllers[i].clear();
                        model.updatePagValues("0,00", i);
                      }

                      if (res != "" && aux.isEmpty) {
                        showDialog(context: context, child: QRErroDialog(res));
                      } else if (aux.isNotEmpty) {
                        print("\nUpdating qr code info...\n");
                        model.updateInfogetQRCode(aux);
                        model.avaliarCartoes();
                        model.updateAvaliacoesWaiting(true);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
  }
}

class QRErroDialog extends StatelessWidget {
  final String msg;
  QRErroDialog(this.msg);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return AlertDialog(
      title: Text("Erro"),
      content: Text(
        msg == "Erro" ? "Algo deu errado, tente novamente." : "Sem permissão.",
      ),
      actions: [
        FlatButton(
          onPressed: () {
            model.updateInfogetQRCode([]);
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}

class DigiOpCobrar extends StatefulWidget {
  @override
  _DigiOpCobrarState createState() => _DigiOpCobrarState();
}

class _DigiOpCobrarState extends State<DigiOpCobrar> {
  TextEditingController _cobController;
  final _formKey = GlobalKey<FormState>();
  final oCcy = new NumberFormat.currency(locale: 'eu', symbol: "");
  String money;

  @override
  void initState() {
    super.initState();
    _cobController = TextEditingController(
      text: "",
    );
  }

  @override
  void dispose() {
    _cobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Escolha sua conta:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 5),
          ListView.separated(
            shrinkWrap: true,
            itemCount: model.userCards.length,
            separatorBuilder: (context, index) => Divider(height: 5),
            itemBuilder: (context, index) => Container(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              MyFlutterApp.pay,
                              color: model.getOptions(index + 1)[2],
                              size: 40,
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(model.userCards[index][0]),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Agência ",
                                          style: TextStyle(
                                            color:
                                                model.getOptions(index + 1)[2],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(model.userCards[index][5]),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Row(
                                      children: [
                                        Text(
                                          "Conta ",
                                          style: TextStyle(
                                            color:
                                                model.getOptions(index + 1)[2],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(model.userCards[index][6]),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: model.checks[index],
                          onPressed: () {
                            model.updateShowQRCode(false);
                            model.updateInfoQRCode("");
                            model.updateChooseCobCard(index);
                            model.updateChecks();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Digite o valor:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          Form(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                TextFormField(
                  controller: _cobController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[0-9,.]"))
                  ],
                  decoration: InputDecoration(
                    hintText: "10,00",
                    labelText: "Valor",
                    counter: Text(
                      "R\$ " + model.cobMoney,
                      style: TextStyle(
                        fontSize: 16,
                        color: weirdBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                  onChanged: (value) {
                    try {
                      model.updateCobMoney(oCcy.format(double.parse(
                          _cobController.text
                              .replaceAll(".", "")
                              .replaceAll(",", "."))));
                    } catch (e) {
                      if (_cobController.text.isEmpty) {
                        model.updateCobMoney("0,00");
                      } else {
                        model.updateCobMoney("inválido");
                      }
                    }
                  },
                ),
                SendDigiButton(
                  info: [_cobController, 0],
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          model.showQRCode
              ? Center(
                  child: QrImage(
                    data: model.infoQRCode,
                    size: 180,
                    version: QrVersions.auto,
                    gapless: false,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class SendDigiButton extends StatelessWidget {
  final List options = ["Gerar QR CODE", "Ler QR CODE"];
  final List info;

  SendDigiButton({@required this.info});
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: RaisedButton(
          color: Colors.blue,
          child: Text(
            options[info[1]],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            if (model.cobMoney == "inválido") {
              showDialog(context: context, child: OpDialog(0, 2));
            } else {
              if (info[0].text != "") {
                FocusScope.of(context).requestFocus(FocusNode());
                print(
                    "\nGerar QR CODE - ${info[0].text} - ${model.userCards[model.chooseCobCard][5]}  ${model.userCards[model.chooseCobCard][6]}");
                model.updateInfoQRCode(model.userCards[model.chooseCobCard][0] +
                    "+" +
                    model.userCards[model.chooseCobCard][5] +
                    "+" +
                    model.userCards[model.chooseCobCard][6] +
                    "+" +
                    NumberFormat.currency(
                            locale: "pt_br", symbol: '', customPattern: "")
                        .format(double.parse(info[0]
                            .text
                            .replaceAll('.', '')
                            .replaceAll(',', '.')))
                        .toString() +
                    "+" +
                    model.userInfo[1] +
                    "\n");
                // print(model.infoQRCode);
                model.updateShowQRCode(true);
              }
            }
          },
        ),
      ),
    );
  }
}
