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

  final FocusNode _emailFocus = new FocusNode();
  final FocusNode _passwordFocus = new FocusNode();
  final FocusNode _confirmPasswordFocus = new FocusNode();

  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool waiting = false;

  String error = "";

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

    return Stack(
      children: [
        Container(
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
                    Logo(10),
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
                        error != null
                            ? error.isNotEmpty ? "*" + error : ""
                            : "",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          hintText: "Email",
                        ),
                        validator: (value) {
                          return value.isEmpty ? '*Campo obrigatório' : null;
                        },
                        onFieldSubmitted: (value) {
                          _fieldFocusChange(
                              context, _emailFocus, _passwordFocus);
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _showPassword,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
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
                        onFieldSubmitted: (value) {
                          _fieldFocusChange(
                              context, _passwordFocus, _confirmPasswordFocus);
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _showConfirmPassword,
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
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
                        onFieldSubmitted: (value) async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              waiting = true;
                            });
                            String res = await AuthProvider().signup(
                                _emailController.text,
                                _passwordController.text);
                            if (res == "Ok") {
                              setState(() {
                                error = "";
                              });
                              print("\nUser cadastrado: " +
                                  _emailController.text +
                                  " " +
                                  _passwordController.text +
                                  "\n");
                              model.updateisConfigDown(false);
                              model.updateUserInfo();
                              showDialog(
                                context: context,
                                child: SignInDialog(),
                              );
                            } else {
                              print("\nCadastro ERRO\n");
                              setState(() {
                                error = res;
                                waiting = false;
                              });
                            }
                          } else {
                            setState(() {
                              waiting = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                waiting = true;
                              });
                              String res = await AuthProvider().signup(
                                  _emailController.text,
                                  _passwordController.text);
                              if (res == "Ok") {
                                setState(() {
                                  error = "";
                                });
                                print("\nUser cadastrado: " +
                                    _emailController.text +
                                    " " +
                                    _passwordController.text +
                                    "\n");
                                model.updateisConfigDown(false);
                                model.updateUserInfo();
                                showDialog(
                                  context: context,
                                  child: SignInDialog(),
                                );
                              } else {
                                print("\nCadastro ERRO\n");
                                setState(() {
                                  error = res;
                                  waiting = false;
                                });
                              }
                            } else {
                              setState(() {
                                waiting = false;
                              });
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
        ),
        waiting ? Center(child: CircularProgressIndicator()) : Container()
      ],
    );
  }
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
