import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class CardOperations extends StatefulWidget {
  final index;

  CardOperations({@required this.index});

  @override
  _CardOperationsState createState() => _CardOperationsState();
}

class _CardOperationsState extends State<CardOperations> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nomeController;
  TextEditingController _cpfController;
  MoneyMaskedTextController _valorController;
  TextEditingController _agenciaController;
  TextEditingController _contaController;
  MoneyMaskedTextController _boletoController;
  List controllers;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: "");
    _cpfController = TextEditingController(text: "");
    _valorController = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.', initialValue: 0.0);
    _agenciaController = TextEditingController(text: "");
    _contaController = TextEditingController(text: "");
    _boletoController = MoneyMaskedTextController(
        decimalSeparator: ',', thousandSeparator: '.', initialValue: 0.0);
    controllers = [
      [_valorController],
      [_boletoController],
      [_nomeController, _cpfController, _agenciaController, _contaController],
      [_valorController]
    ];
  }

  List options = ["Depósito", "Pagamento", "Transferência", "Cobrar"];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 450,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    options[widget.index],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
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
    final fmodel = Provider.of<FirestoreModel>(context);

    return Align(
      alignment: Alignment.center,
      child: CustomCursor(
        cursorStyle: CustomCursor.pointer,
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
              var res;
              var text = double.parse(
                  controller[0].text.replaceAll('.', '').replaceAll(',', '.'));
              if (index == 0) {
                res = await fmodel.ops_dep_pag(text, 0);
                if (res) {
                  Navigator.of(context).pop();
                  fmodel.getUserContas();
                  showDialog(context: context, child: OpDialog(text, 0));
                } else {
                  showDialog(context: context, child: OpDialog(text, 2));
                }
              } else if (index == 1) {
                res = await fmodel.ops_dep_pag(text, 1);
                if (res) {
                  Navigator.of(context).pop();
                  fmodel.getUserContas();
                  showDialog(context: context, child: OpDialog(text, 1));
                } else {
                  showDialog(context: context, child: OpDialog(text, 2));
                }
              }
            },
          ),
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
                : "Não foi possível completar a operação.";
      } catch (e) {}
    }

    return AlertDialog(
      title: Text(type != 2 ? "Operação Concluída!" : "Operação Falhou."),
      content: Text(getText()),
      actions: [
        CustomCursor(
          cursorStyle: CustomCursor.pointer,
          child: RaisedButton(
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
    final fmodel = Provider.of<FirestoreModel>(context);
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        DropDownBanco(),
        model.chosenBankT == fmodel.currentOption[1]
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
          hint: "1234",
          label: "Agência",
        ),
        AddCardField(
          controller: controllers[3],
          hint: "12345-6",
          label: "Conta",
        ),
      ],
    );
  }
}

class AddCardField extends StatelessWidget {
  const AddCardField({
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
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: CustomCursor(
        cursorStyle: CustomCursor.text,
        child: TextFormField(
          controller: _controller,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter(RegExp("[0-9]"))
          ],
          decoration: InputDecoration(
            hintText: _hint,
            labelText: _label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
        ),
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
        child: CustomCursor(
          cursorStyle: CustomCursor.pointer,
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
      ),
    );
  }
}
