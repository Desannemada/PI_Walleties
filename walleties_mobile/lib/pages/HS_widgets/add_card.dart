import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/main_view_model.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nomeController;
  TextEditingController _numeroCartaoController;
  TextEditingController _validadeController;
  TextEditingController _cvvController;
  TextEditingController _agenciaController;
  TextEditingController _contaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: "");
    _numeroCartaoController = TextEditingController(text: "");
    _validadeController = TextEditingController(text: "");
    _cvvController = TextEditingController(text: "");
    _agenciaController = TextEditingController(text: "");
    _contaController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _numeroCartaoController.dispose();
    _validadeController.dispose();
    _cvvController.dispose();
    _agenciaController.dispose();
    _contaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AddCardField(
              controller: _nomeController,
              hint: "MARY A MARTINS",
              label: "Nome do Titular",
            ),
            AddCardField(
              controller: _numeroCartaoController,
              hint: "0000-0000-0000-0000",
              label: "Número do Cartão",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddCardField(
                  controller: _validadeController,
                  label: "Validade",
                  hint: "mm/yy",
                ),
                AddCardField(
                  controller: _cvvController,
                  label: "CVV",
                  hint: "000 / 0000",
                ),
              ],
            ),
            DropDownBanco(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AddCardField(
                  controller: _agenciaController,
                  label: "Agência",
                  hint: "a",
                ),
                AddCardField(
                  controller: _contaController,
                  label: "Conta",
                  hint: "a",
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // color: blue,
                    onPressed: () => model.updateIsAddCardFormOpen(false),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: RaisedButton(
                    child: Text(
                      "Confirmar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    color: lighterGreen,
                    onPressed: () async {
                      bool aux = true;
                      for (var card in model.userCards) {
                        if (model.chosenBank == card[4]) {
                          aux = false;
                        }
                      }

                      if (_formKey.currentState.validate() && aux) {
                        var res = await model.addCard(
                          _nomeController.text,
                          _numeroCartaoController.text,
                          _validadeController.text,
                          _cvvController.text,
                          model.chosenBank,
                          _agenciaController.text,
                          _contaController.text,
                        );
                        if (res) {
                          model.updateIsAddCardFormOpen(false);
                        }
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.of(context).pop(true);
                              });
                              return ResultAddDialog(
                                res
                                    ? "Conta adicionada com sucesso!"
                                    : "Não foi possível completar a operação!",
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.of(context).pop(true);
                              });
                              return ResultAddDialog(
                                "Máximo de uma conta por banco!",
                              );
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddCardField extends StatelessWidget {
  const AddCardField({
    @required TextEditingController controller,
    @required String hint,
    @required String label,
    // @required int index,
  })  : _controller = controller,
        _hint = hint,
        _label = label;
  // _index = index;

  final TextEditingController _controller;
  final String _hint;
  final String _label;
  // final int _index;

  @override
  Widget build(BuildContext context) {
    // final cvmodel = Provider.of<CardValidationModel>(context);

    double pad;
    if (["CVV", "Validade", "Conta", "Agência"].contains(_label)) {
      pad = 180;
    } else {
      pad = double.infinity;
    }

    return Container(
      width: pad,
      padding: EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: _hint,
          labelText: _label,
          // errorText: cvmodel.cvi[_index].error,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        ),
        validator: (value) {
          return value.isEmpty ? '*Campo obrigatório' : null;
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
            value: model.chosenBank,
            isDense: true,
            onChanged: (String newValue) {
              model.updateChosenBank(newValue);
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

class ResultAddDialog extends StatelessWidget {
  final String title;
  ResultAddDialog(this.title);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Text(
          title,
          // overflow: TextOverflow.visible,
          softWrap: true,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
