import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/models/firebase_auth.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/LS_widgets/logo.dart';
import 'package:walleties_mobile/pages/login_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;

  final FocusNode _emailFocus = new FocusNode();
  final FocusNode _passwordFocus = new FocusNode();

  bool _showPassword = true;

  String error;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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
                  alignment: Alignment.center,
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
                        onFieldSubmitted: (value) {
                          _fieldFocusChange(
                              context, _emailFocus, _passwordFocus);
                        },
                        validator: (value) {
                          return value.isEmpty ? '*Campo obrigatório' : null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _showPassword,
                        textInputAction: TextInputAction.done,
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
                        onFieldSubmitted: (value) async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              waiting = true;
                            });
                            String res = await AuthProvider().signInWithEmail(
                                _emailController.text,
                                _passwordController.text);
                            if (res == "Error") {
                              print("\nLogin falhou\n");
                              setState(() {
                                error = "";
                              });
                            } else if (res == "Ok") {
                              print("\nLogin ok!\n");
                              model.updateWaiting(false);
                              model.updateisConfigDown(false);
                              model.updateUserInfo();
                              model.updateIsAddCardFormOpen(false);
                              setState(() {
                                error = "";
                              });
                            } else {
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
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          "Esqueceu a senha?",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                waiting = true;
                              });
                              String res = await AuthProvider().signInWithEmail(
                                  _emailController.text,
                                  _passwordController.text);
                              if (res == "Error") {
                                print("\nLogin falhou\n");
                                setState(() {
                                  error = "";
                                });
                              } else if (res == "Ok") {
                                print("\nLogin ok!\n");
                                model.updateWaiting(false);
                                model.updateisConfigDown(false);
                                model.updateUserInfo();
                                model.updateIsAddCardFormOpen(false);
                                setState(() {
                                  error = "";
                                });
                              } else {
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
                            'Entrar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 1,
                            width: 70,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("ou"),
                          ),
                          Container(
                            height: 1,
                            width: 70,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            String res = await AuthProvider().loginWithGoogle();
                            if (res == "Error") {
                              print("\nLogin with google FAIL\n");
                              setState(() {
                                error = "";
                              });
                            } else if (res == "Ok") {
                              print("\nGoogle Login OK!\n");
                              model.updateWaiting(false);
                              model.updateisConfigDown(false);
                              model.updateUserInfo();
                              model.updateIsAddCardFormOpen(false);
                              setState(() {
                                error = "";
                              });
                            } else {
                              setState(() {
                                error = res;
                              });
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                "assets/google_logo.png",
                                scale: 20,
                              ),
                              Expanded(
                                child: Text(
                                  'Sign in with Google',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
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
              ),
            ],
          ),
        ),
        waiting ? Center(child: CircularProgressIndicator()) : Container()
      ],
    );
  }
}
