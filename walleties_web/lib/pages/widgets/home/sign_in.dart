import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/model/main_view_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;

  bool _showPassword = true;
  String _errorMessage = "";
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);
    final model = Provider.of<MainViewModel>(context);

    Future<void> _signInWithEmailAndPassword(FirebaseAuth _auth) async {
      try {
        final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ))
            .user;
        if (user != null) {
          model.updateisConfigDown(false);
          fmodel.updateWaiting(false);
          fmodel.updateUserInfo();
          Navigator.pushNamed(context, "/Geral");
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.message;
          waiting = false;
        });
      }
    }

    Future<void> _signInWithGoogle(
        GoogleSignIn _googleSignIn, FirebaseAuth _auth) async {
      try {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        if (user != null) {
          fmodel.updateWaiting(false);
          model.updateisConfigDown(false);
          fmodel.updateUserInfo();
          Navigator.pushNamed(context, "/Geral");
        }
      } catch (e) {
        print(e.message);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return !waiting
        ? Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
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
                      return value.isEmpty ? '*Campo obrigatório' : null;
                    },
                    onFieldSubmitted: (String aux) async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          waiting = true;
                        });

                        await _signInWithEmailAndPassword(fmodel.auth);
                      }
                    },
                  ),
                ),
                CustomCursor(
                  cursorStyle: CustomCursor.pointer,
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            waiting = true;
                          });
                          await _signInWithEmailAndPassword(fmodel.auth);
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
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: CustomCursor(
                    cursorStyle: CustomCursor.pointer,
                    child: RaisedButton(
                      onPressed: () async {
                        await _signInWithGoogle(
                            fmodel.googleSignIn, fmodel.auth);
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
                ),
              ],
            ),
          )
        : CircularProgressIndicator();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
