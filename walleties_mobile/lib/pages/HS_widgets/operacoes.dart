import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/main_view_model.dart';

class Operacoes extends StatefulWidget {
  final index;
  Operacoes(this.index);

  @override
  _OperacoesState createState() => _OperacoesState();
}

class _OperacoesState extends State<Operacoes> {
  final List titles = ["Depósito", "Pagamento", "Transferência", "Cobrança"];
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nomeController;
  TextEditingController _cpfController;
  TextEditingController _valorController;
  TextEditingController _agenciaController;
  TextEditingController _contaController;
  TextEditingController _boletoController;
  List controllers;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: "");
    _cpfController = TextEditingController(text: "");
    _valorController = TextEditingController(text: "");
    _agenciaController = TextEditingController(text: "");
    _contaController = TextEditingController(text: "");
    _boletoController = TextEditingController(text: "");
    controllers = [
      [_valorController],
      [_boletoController],
      [_nomeController, _cpfController, _agenciaController, _contaController],
      [_valorController]
    ];
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _valorController.dispose();
    _boletoController.dispose();
    _agenciaController.dispose();
    _contaController.dispose();
    super.dispose();
  }

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
          titles[widget.index],
          style: TextStyle(
            color: model.currentOption[2],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              widget.index == 0
                  ? OpDeposito(controllers[widget.index])
                  : widget.index == 1
                      ? OpPagamento(controllers[widget.index])
                      : widget.index == 2
                          ? OpTransferencia(controllers[widget.index])
                          : widget.index == 3
                              ? OpCobrar(controllers[widget.index])
                              : Container(),
              SendButton(
                index: widget.index,
                controller: controllers[widget.index],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final List options = ["Depositar", "Pagar", "Transferir", "Cobrar"];
  final int index;
  final List<TextEditingController> controller;

  SendButton({@required this.index, @required this.controller});
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
            options[index],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (model.cobMoney == "inválido") {
              showDialog(context: context, child: OpDialog(0, 2));
            } else {
              if (controller[0].text.isNotEmpty) {
                var res;
                var text = double.parse(controller[0]
                    .text
                    .replaceAll('.', '')
                    .replaceAll(',', '.'));
                if (index == 0) {
                  bool res = await model.ops_dep_pag(text, 0);
                  if (res) {
                    model.getUserContas();
                    Navigator.of(context).pop();
                    showDialog(context: context, child: OpDialog(text, 0));
                  } else {
                    showDialog(context: context, child: OpDialog(text, 2));
                  }
                } else if (index == 1) {
                  bool aux = model.checkOpPagDisponivel(double.parse(
                      controller[0]
                          .text
                          .replaceAll('.', '')
                          .replaceAll(',', '.')));
                  if (aux) {
                    res = await model.ops_dep_pag(text, 1);
                    if (res) {
                      model.getUserContas();
                      Navigator.of(context).pop();
                      showDialog(context: context, child: OpDialog(text, 1));
                    } else {
                      showDialog(context: context, child: OpDialog(text, 2));
                    }
                  } else {
                    showDialog(context: context, child: OpDialog(0, 4));
                  }
                }
              }
            }
          },
        ),
      ),
    );
  }
}

class OpDialog extends StatelessWidget {
  final double text;
  final int type;
  OpDialog(this.text, this.type);

  @override
  Widget build(BuildContext context) {
    String getText() {
      try {
        String value =
            NumberFormat.currency(locale: "pt_br", symbol: 'R\$ ').format(text);
        return type == 0
            ? "Depósito de ${value} realizado com sucesso!"
            : type == 1
                ? "Pagamento de ${value} realizado com sucesso!"
                : type == 2
                    ? "Não foi possível completar a operação."
                    : type == 3
                        ? "Valor total difere do valor da compra."
                        : type == 4
                            ? "Limite Indisponível."
                            : "Valor Inválido.";
      } catch (e) {}
    }

    return AlertDialog(
      title: Text(
          type == 0 || type == 1 ? "Operação Concluída!" : "Operação Falhou."),
      content: Text(getText()),
      actions: [
        RaisedButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: Colors.blue,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class OpDeposito extends StatelessWidget {
  final List controllers;
  OpDeposito(this.controllers);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        AddCardField(
          controller: controllers[0],
          hint: "10,00",
          label: "Valor",
        ),
      ],
    );
  }
}

class OpPagamento extends StatelessWidget {
  final List controllers;
  OpPagamento(this.controllers);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        AddCardField(
          controller: controllers[0],
          hint: "10,00",
          label: "Valor",
        ),
      ],
    );
  }
}

class OpCobrar extends StatelessWidget {
  final List controllers;
  OpCobrar(this.controllers);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        AddCardField(
          controller: controllers[0],
          hint: "10,00",
          label: "Valor",
        ),
      ],
    );
  }
}

class OpTransferencia extends StatelessWidget {
  final List controllers;
  OpTransferencia(this.controllers);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        DropDownBanco(),
        model.chosenBankT == model.currentOption[1]
            ? Container()
            : ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  AddCardField(
                    controller: controllers[0],
                    hint: "Thomas Martins",
                    label: "Nome",
                  ),
                  AddCardField(
                    controller: controllers[1],
                    hint: "000.000.000-00",
                    label: "CPF",
                  ),
                ],
              ),
        AddCardField(
          controller: controllers[2],
          hint: "algo",
          label: "Agência",
        ),
        AddCardField(
          controller: controllers[3],
          hint: "algo",
          label: "Conta",
        ),
      ],
    );
  }
}

class AddCardField extends StatelessWidget {
  AddCardField({
    @required TextEditingController controller,
    @required String hint,
    @required String label,
  })  : _controller = controller,
        _hint = hint,
        _label = label;

  final TextEditingController _controller;
  final String _hint;
  final String _label;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    NumberFormat oCcy = new NumberFormat.currency(locale: 'eu', symbol: "");
    // String money;

    return Container(
      padding: EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: _controller,
        inputFormatters: [
          _label == "Valor"
              ? WhitelistingTextInputFormatter(RegExp("[0-9,.]"))
              : BlacklistingTextInputFormatter(RegExp("[,.]")),
        ],
        decoration: InputDecoration(
          hintText: _hint,
          labelText: _label,
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
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        ),
        onChanged: (value) {
          try {
            model.updateCobMoney(oCcy.format(double.parse(
                _controller.text.replaceAll(".", "").replaceAll(",", "."))));
          } catch (e) {
            if (_controller.text.isEmpty) {
              model.updateCobMoney("0,00");
            } else {
              model.updateCobMoney("inválido");
            }
          }
        },
      ),
    );
  }
}

class DropDownBanco extends StatefulWidget {
  @override
  _DropDownBancoState createState() => _DropDownBancoState();
}

class _DropDownBancoState extends State<DropDownBanco> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          labelText: "Banco",
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: model.chosenBankT,
            isDense: true,
            onChanged: (String newValue) {
              model.updateChosenBankT(newValue);
            },
            items: model.banks.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
