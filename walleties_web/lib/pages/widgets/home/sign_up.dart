import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:walleties/colors/colors.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  String _errorMessage = "";
  bool _showPassword = true;
  bool _showConfirmPassword = true;

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
    final fmodel = Provider.of<FirestoreModel>(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            _errorMessage != "" ? "*" + _errorMessage : _errorMessage,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          SizedBox(height: 5),
          CustomCursor(
            cursorStyle: CustomCursor.text,
            child: TextFormField(
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
          ),
          SizedBox(height: 20),
          CustomCursor(
            cursorStyle: CustomCursor.text,
            child: TextFormField(
              controller: _passwordController,
              obscureText: _showPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                ),
                hintText: "Senha",
                suffixIcon: CustomCursor(
                  cursorStyle: CustomCursor.pointer,
                  child: IconButton(
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
          ),
          SizedBox(height: 20),
          CustomCursor(
            cursorStyle: CustomCursor.text,
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _showConfirmPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                ),
                hintText: "Confirmar Senha",
                suffixIcon: CustomCursor(
                  cursorStyle: CustomCursor.pointer,
                  child: IconButton(
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
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: CustomCursor(
              cursorStyle: CustomCursor.pointer,
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    bool result = await _register(
                        _emailController.text, _passwordController.text, model);
                    if (result) {
                      // _showSnackBar("Registro efetuado com sucesso!");
                      fmodel.updateUserInfo();
                      fmodel.updateCurrentOption(0);
                      model.updateisConfigDown(false);
                      Navigator.pushNamed(context, "/Geral");
                      showDialog(
                        context: context,
                        child: SignInDialog(),
                      );
                    } else {
                      _showSnackBar("Algum erro ocorreu. Tente novamente.");
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _register(
      String email, String password, MainViewModel model) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Sucesso ao criar conta: $email / $password");
      setState(() {
        _errorMessage = "";
      });
      return true;
    } catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
      return false;
    }
  }

  void _showSnackBar(String text) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class SignInDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    return AlertDialog(
      title: Text("Bem-vindo ao Walleties!"),
      content: Text("Registro efetuado com sucesso! \nOlá " +
          fmodel.userInfo[0] +
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
