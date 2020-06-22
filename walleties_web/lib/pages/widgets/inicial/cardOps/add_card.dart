import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/card_validation_model.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

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
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);
    final cvmodel = Provider.of<CardValidationModel>(context);

    return Dialog(
      child: Container(
        width: 450,
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Dados do Cartão",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CustomCursor(
                      cursorStyle: CustomCursor.pointer,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        iconSize: 28,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  )
                ],
              ),
              AddCardField(
                controller: _nomeController,
                hint: "MARY A MARTINS",
                label: "Nome no cartão",
                index: 0,
              ),
              AddCardField(
                controller: _numeroCartaoController,
                hint: "0000-0000-0000-0000",
                label: "Número do Cartão",
                index: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AddCardField(
                    controller: _validadeController,
                    label: "Validade",
                    hint: "mm/yy",
                    index: 2,
                  ),
                  AddCardField(
                    controller: _cvvController,
                    label: "CVV",
                    hint: "000 / 0000",
                    index: 3,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Dados da Conta",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropDownBanco(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AddCardField(
                    controller: _agenciaController,
                    label: "Agência",
                    hint: "1234-5",
                    index: 4,
                  ),
                  AddCardField(
                    controller: _contaController,
                    label: "Conta",
                    hint: "12346578-9",
                    index: 5,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: CustomCursor(
                  cursorStyle: CustomCursor.pointer,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Adicionar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (cvmodel.isValid) {
                        fmodel.addCard(
                            _nomeController.text,
                            _numeroCartaoController.text,
                            _validadeController.text,
                            _cvvController.text,
                            model.chosenBank,
                            _agenciaController.text,
                            _contaController.text);
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.of(context).pop(true);
                              });
                              return ResultAddDialog();
                            });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _nomeController.dispose();
    _numeroCartaoController.dispose();
    _validadeController.dispose();
    _cvvController.dispose();
    _agenciaController.dispose();
    _contaController.dispose();
    super.dispose();
  }
}

class ResultAddDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Text(
          "Conta adicionada com sucesso!",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
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
    @required int index,
  })  : _controller = controller,
        _hint = hint,
        _label = label,
        _index = index;

  final TextEditingController _controller;
  final String _hint;
  final String _label;
  final int _index;

  @override
  Widget build(BuildContext context) {
    final cvmodel = Provider.of<CardValidationModel>(context);

    double pad;
    if (["CVV", "Validade", "Conta", "Agência"].contains(_label)) {
      pad = 180;
    } else {
      pad = double.infinity;
    }

    return Container(
      width: pad,
      padding: EdgeInsets.only(top: 15),
      child: CustomCursor(
        cursorStyle: CustomCursor.text,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: _hint,
            labelText: _label,
            errorText: cvmodel.cvi[_index].error,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          ),
          onChanged: (String value) {
            cvmodel.updateItem(value, _index);
          },
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
      ),
    );
  }
}
