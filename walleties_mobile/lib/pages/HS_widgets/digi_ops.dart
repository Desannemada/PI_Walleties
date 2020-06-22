import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walleties_mobile/extra/my_flutter_app_icons.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/HS_widgets/operacoes.dart';
import 'dart:convert';

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
          color: model.currentOption[2],
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          index == 0 ? "Cobrar" : "Pagar",
          style: TextStyle(
            color: model.currentOption[2],
          ),
        ),
      ),
      body: index == 0 ? DigiOpCobrar() : DigiOpPagar(),
    );
  }
}

class DigiOpPagar extends StatelessWidget {
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
    List ops = ["NOME: ", "AGÊNCIA: ", "CONTA: ", "VALOR: "];

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
                      print("\n\n" + res + "\n\n");
                      List aux = res.split("+");

                      if (res != "" && aux.isEmpty) {
                        showDialog(context: context, child: QRErroDialog(res));
                      } else if (aux.isNotEmpty) {
                        print("Updating qr code info...");
                        model.updateInfogetQRCode(aux);
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

  @override
  void initState() {
    super.initState();
    _cobController = TextEditingController(text: "");
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
          SizedBox(height: 5),
          Form(
            child: OpDigital([
              _cobController,
              0,
            ]),
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

class OpDigital extends StatelessWidget {
  final List info;
  OpDigital(this.info);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        AddCardField(
          controller: info[0],
          hint: "10,00",
          label: "Valor",
        ),
        SendDigiButton(
          info: [info[0], 0],
        )
      ],
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
            if (info[0].text != "") {
              print(
                  "Gerar QR CODE - ${info[0].text} - ${model.userCards[model.chooseCobCard][5]}  ${model.userCards[model.chooseCobCard][6]}");
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
                  model.userInfo[1]);
              print(model.infoQRCode);
              model.updateShowQRCode(true);
            }
          },
        ),
      ),
    );
  }
}
