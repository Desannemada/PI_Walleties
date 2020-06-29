import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final FocusNode _nomeFocus = new FocusNode();
  final FocusNode _numeroFocus = new FocusNode();
  final FocusNode _validadeFocus = new FocusNode();
  final FocusNode _cvvFocus = new FocusNode();
  final FocusNode _agenciaFocus = new FocusNode();
  final FocusNode _contaFocus = new FocusNode();

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
              mask: ["", ""],
              index: 0,
              focus: [_nomeFocus, _numeroFocus],
              context: context,
            ),
            AddCardField(
              controller: _numeroCartaoController,
              hint: "0000-0000-0000-0000",
              label: "Número do Cartão",
              mask: ["xxxx-xxxx-xxxx-xxxx", "-"],
              index: 1,
              focus: [_numeroFocus, _validadeFocus],
              context: context,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddCardField(
                  controller: _validadeController,
                  label: "Validade",
                  hint: "mm/yy",
                  mask: ["xx/xx", "/"],
                  index: 2,
                  focus: [_validadeFocus, _cvvFocus],
                  context: context,
                ),
                AddCardField(
                  controller: _cvvController,
                  label: "CVV",
                  hint: "000 / 0000",
                  mask: ["xxxx", ""],
                  index: 3,
                  focus: [_cvvFocus, _agenciaFocus],
                  context: context,
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
                  hint: "1234",
                  mask: ["xxxxxxxxxx", ""],
                  index: 4,
                  focus: [_agenciaFocus, _contaFocus],
                  context: context,
                ),
                AddCardField(
                  controller: _contaController,
                  label: "Conta",
                  hint: "12345-6",
                  mask: ["xxxxxxxxxx", ""],
                  index: 5,
                  context: context,
                  focus: [_contaFocus],
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
                      } else if (!aux) {
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
  const AddCardField(
      {@required TextEditingController controller,
      @required String hint,
      @required String label,
      @required List<String> mask,
      @required int index,
      @required context,
      List<FocusNode> focus})
      : _controller = controller,
        _hint = hint,
        _label = label,
        _mask = mask,
        _index = index,
        _focus = focus,
        _context = context;

  final TextEditingController _controller;
  final String _hint;
  final String _label;
  final List<String> _mask;
  final int _index;
  final List<FocusNode> _focus;
  final BuildContext _context;

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
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
        focusNode: _focus[0],
        decoration: InputDecoration(
          hintText: _hint,
          labelText: _label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        ),
        inputFormatters: _index != 0
            ? [MaskedTextInputFormatter(mask: _mask[0], separator: _mask[1])]
            : [],
        textInputAction:
            _index != 5 ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (value) {
          if (_index != 5) {
            _fieldFocusChange(_context, _focus[0], _focus[1]);
          }
        },
        validator: (value) {
          if (value.isEmpty) {
            return '*Campo obrigatório';
          }
          switch (_index) {
            case 0:
              {
                if (!(RegExp(r"(^[a-zA-Z ]+$)").hasMatch(value))) {
                  return '*Formato Inválido';
                }
              }
              break;
            case 1:
              {
                if (!RegExp(r"([0-9]{4}[-][0-9]{4}[-][0-9]{4}[-][0-9]{4})")
                    .hasMatch(value)) {
                  return '*Formato Inválido';
                }
              }
              break;
            case 2:
              {
                if (!RegExp(r"([0-9]{2}/[0-9]{2})").hasMatch(value)) {
                  return '*Formato Inválido';
                }
              }
              break;
            default:
              {
                if (!RegExp(r"([0-9])").hasMatch(value)) {
                  return '*Formato Inválido';
                }
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

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
