import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walleties_mobile/colors/colors.dart';
import 'package:walleties_mobile/models/firebase_auth.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/login_screen.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginBackground.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.8),
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            scale: 10,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Walleties",
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image:
                                model.userInfo[3] == 'assets/profileImage.jpg'
                                    ? AssetImage(
                                        'assets/profileImage.jpg',
                                      )
                                    : NetworkImage(
                                        model.userInfo[3],
                                      ),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        model.userInfo[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        model.userInfo[1],
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Contas: " + model.userCards.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.options.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: index == model.options.length - 1
                                      ? 10
                                      : 1),
                              height: 45,
                              child: RaisedButton(
                                padding: EdgeInsets.zero,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      model.options[index][0],
                                      size: 35,
                                      color: model.setColor(index),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      model.options[index][1],
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  if (index == model.options.length - 1) {
                                    if (model.isConfigDown) {
                                      model.updateisConfigDown(false);
                                    } else {
                                      model.updateisConfigDown(true);
                                    }
                                  } else {
                                    model.updateCurrentOption(index);
                                    model.updateWhichAbaFatura(false);
                                    model.updateCardMonths(model.fMonths);
                                    model.updateCurrentMonth(
                                        model.getMonth(DateTime.now().month) +
                                            " " +
                                            DateTime.now().year.toString());
                                    if (index != 0) {
                                      model.updateIsTapped(false);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            index == model.options.length - 1 &&
                                    model.isConfigDown
                                ? ConfigMenu(options: model.options)
                                : Container(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfigMenu extends StatelessWidget {
  final List options;
  ConfigMenu({this.options});

  final List menu = ["Editar Perfil", "Sair"];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: menu.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: 35, right: 35, top: 10),
              height: 35,
              child: RaisedButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                child: Text(
                  menu[index],
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () async {
                  if (index == 1) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("Sair"),
                        content: Text("Têm certeza que deseja sair?"),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              AuthProvider().signOut();
                              model.resetCards();
                              model.changeAtualLoginWidget(LoginScreenMenu());
                            },
                            child: Text(
                              "Sim",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Não",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (index == 0) {
                    model.updateisConfigDown(false);
                    Navigator.of(context).pop();
                    model.updateEditProfileInfo(null, 1);
                    model.updateEditProfileInfo(false, 0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditProfile(initialValue: model.userInfo[0]);
                        },
                      ),
                    );
                  }
                },
              ),
            );
          }),
    );
  }
}

class EditProfile extends StatefulWidget {
  final initialValue;

  EditProfile({@required this.initialValue});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  StorageUploadTask _uploadTask;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainViewModel>(context);
    final filePath = 'images/${model.userInfo[2]}.png';
    final url = "gs://walleties-59f0f.appspot.com/walleties-59f0f.appspot.com";

    Future<dynamic> getImage() async {
      StorageReference ref =
          await FirebaseStorage.instance.getReferenceFromUrl(url);
      var storage = ref.child(filePath);
      return storage.getDownloadURL();
    }

    getTempImage() async {
      var aux = await getImage();
      if (aux != null) {
        model.updateEditProfileInfo(aux.toString(), 1);
        model.updateEditProfileInfo(false, 0);
      }
    }

    void uploadToFirebase(File file) async {
      StorageReference ref =
          await FirebaseStorage.instance.getReferenceFromUrl(url);
      var aux = ref.child(filePath).putFile(file);
      setState(() {
        _uploadTask = aux;
      });
      model.updateEditProfileInfo(true, 0);
      // print(getImage());
    }

    String _bytesTransferred(StorageTaskSnapshot snapshot) {
      double res = snapshot.bytesTransferred / 1024.0;
      double res2 = snapshot.totalByteCount / 1024.0;
      return '${res.truncate().toString()}/${res2.truncate().toString()}';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Editar Perfil",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 20),
            Center(
              child: Card(
                elevation: 5,
                shape: CircleBorder(),
                child: !model.editProfileInfo[0]
                    ? Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: model.editProfileInfo[1] == null
                                ? model.userInfo[3] == 'assets/profileImage.jpg'
                                    ? AssetImage('assets/profileImage.jpg')
                                    : NetworkImage(model.userInfo[3])
                                : NetworkImage(model.editProfileInfo[1]),
                          ),
                        ),
                      )
                    : Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            SizedBox(height: 5),
            _uploadTask != null
                ? Center(
                    child: StreamBuilder(
                      stream: _uploadTask.events,
                      builder: (context, snapshot) {
                        Widget subtitle;
                        if (snapshot.hasData) {
                          final StorageTaskEvent event = snapshot.data;
                          final StorageTaskSnapshot snap = event.snapshot;
                          subtitle = Text('${_bytesTransferred(snap)} KB sent');
                          if (_uploadTask.isSuccessful) {
                            getTempImage();
                          }
                        } else {
                          subtitle = const Text('Starting...');
                        }
                        return ListTile(
                          title:
                              _uploadTask.isComplete && _uploadTask.isSuccessful
                                  ? Center(
                                      child: Text(
                                        'Completo',
                                        // style: detailStyle,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        'Uploading',
                                        // style: detailStyle,
                                      ),
                                    ),
                          subtitle: Center(child: subtitle),
                        );
                      },
                    ),
                  )
                : Container(),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(top: 5),
                height: 35,
                child: RaisedButton(
                  color: Colors.grey,
                  child: Text(
                    "Escolher Imagem",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    //get image
                    var image = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (image != null) {
                      uploadToFirebase(File(image.path));
                    } else {
                      print("Imagem nao foi selecionada");
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Nome",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (val) {
                  if (val == "") {
                    return "Valor não pode ser vazio";
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                "Salvar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                // print(model.editProfileInfo[1]);
                // print(model.userInfo[3]);
                // print(model.userInfo[3]);
                // var image = await getImage();

                if (_formKey.currentState.validate()) {
                  int res = await model.updateUserDisplayName(_controller.text);
                  int res2 =
                      await model.updateUserPhotoURL(model.editProfileInfo[1]);

                  if (res == 0 && res2 == 0) {
                    showDialog(
                      context: context,
                      child: EditDialog(
                        "Aviso",
                        "Não houve mudanças.",
                      ),
                    );
                  } else {
                    if (res == 2 || res2 == 2) {
                      showDialog(
                        context: context,
                        child: EditDialog(
                          "Erro",
                          "Algo deu errado. Tente novamente mais tarde.",
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        child: EditDialog(
                          "Edição Concluída",
                          "Perfil editado com sucesso. Mudanças em outras plataformas requerem relogar.",
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditDialog extends StatelessWidget {
  EditDialog(this.title, this.content);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        Center(
          child: FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "OK",
              style: TextStyle(
                color: darkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
