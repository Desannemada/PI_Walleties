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

  bool _showPassword = true;

  String error;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
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
                          String res = await AuthProvider().signInWithEmail(
                              _emailController.text, _passwordController.text);
                          if (res == "Error") {
                            print("Login falhou");
                            setState(() {
                              error = "";
                            });
                          } else if (res == "Ok") {
                            print("Login ok!");
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
                          print("Login with google FAIL");
                          setState(() {
                            error = "";
                          });
                        } else if (res == "Ok") {
                          print("Google Login OK!");
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
    );
  }
}
