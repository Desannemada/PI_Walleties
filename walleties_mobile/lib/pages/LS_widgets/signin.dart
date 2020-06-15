import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/firebase_auth.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/LS_widgets/logo.dart';
import 'package:walleties_mobile/pages/login_screen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  bool _showPassword = true;
  bool _showConfirmPassword = true;

  String error = "";

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 64,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35,
                    ),
                    onPressed: () =>
                        model.changeAtualLoginWidget(LoginScreenMenu()),
                  ),
                ),
                Logo(),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    error != null ? error.isNotEmpty ? "*" + error : "" : "",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      hintText: "Email",
                    ),
                    validator: (value) {
                      return value.isEmpty ? '*Campo obrigatório' : null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _showPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      hintText: "Senha",
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              _showPassword = !_showPassword;
                            },
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      return value.isEmpty ? '*Campo obrigatório' : null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _showConfirmPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      hintText: "Confirmar Senha",
                      suffixIcon: IconButton(
                        icon: Icon(_showConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              _showConfirmPassword = !_showConfirmPassword;
                            },
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '*Campo obrigatório';
                      } else if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return '*Campos de senha devem ser iguais';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          String res = await AuthProvider().signup(
                              _emailController.text, _passwordController.text);
                          if (res == "Ok") {
                            setState(() {
                              error = "";
                            });
                            print("User cadastrado: " +
                                _emailController.text +
                                " " +
                                _passwordController.text);
                            model.getUserInfo();
                            showDialog(
                              context: context,
                              child: SignInDialog(),
                            );
                          } else {
                            print("Cadastro ERRO");
                            setState(() {
                              error = res;
                            });
                          }
                        }
                      },
                      child: Text(
                        'Registrar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _showSnackBar(String text) {
  //   Scaffold.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(text),
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }
}

class SignInDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return AlertDialog(
      title: Text("Bem-vindo ao Walleties!"),
      content: Text("Registro efetuado com sucesso! \nOlá " +
          model.userInfo[0] +
          ", você pode alterar seu perfil nas configurações."),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "OK",
            style: TextStyle(
                color: darkGreen, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
