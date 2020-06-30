import 'dart:html';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walleties/model/firestore_model.dart';
import 'package:walleties/pages/extra/custom_cursor.dart';
import 'package:firebase/firebase.dart' as fb;

class EditProfile extends StatefulWidget {
  final initialValue;

  EditProfile({@required this.initialValue});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  fb.UploadTask _uploadTask;
  String tempImage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    final fmodel = Provider.of<FirestoreModel>(context);

    uploadToFirebase(File file) async {
      final filePath = 'images/${fmodel.userInfo[2]}.png';
      var aux = fb
          .storage()
          .ref("walleties-59f0f.appspot.com")
          .child(filePath)
          .put(file);
      setState(() {
        _uploadTask = aux;
      });
    }

    uploadImage() async {
      InputElement uploadInput = FileUploadInputElement();
      uploadInput.click();

      uploadInput.onChange.listen(
        (changeEvent) {
          final file = uploadInput.files.first;
          final reader = FileReader();
          reader.readAsDataUrl(file);

          reader.onLoadEnd.listen(
            (loadEndEvent) async {
              uploadToFirebase(file);
            },
          );
        },
      );
    }

    Future<Uri> getImage() async {
      final filePath = 'images/${fmodel.userInfo[2]}.png';
      var storage =
          fb.storage().ref("walleties-59f0f.appspot.com").child(filePath);
      return storage.getDownloadURL();
    }

    getTempImage() async {
      var aux = await getImage();
      setState(() {
        tempImage = aux.toString();
      });
    }

    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
        width: 400,
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Editar Perfil",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: 96,
                  width: 96,
                  child: Card(
                    elevation: 3,
                    shape: CircleBorder(),
                    child: tempImage == null
                        ? fmodel.userInfo[3] == 'assets/profileImage.jpg'
                            ? Image.asset(
                                'assets/profileImage.jpg',
                                scale: 2.3,
                              )
                            : Image.network(
                                fmodel.userInfo[3],
                                fit: BoxFit.cover,
                              )
                        : Image.network(
                            tempImage,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            StreamBuilder<fb.UploadTaskSnapshot>(
              stream: _uploadTask?.onStateChanged,
              builder: (context, snapshot) {
                final event = snapshot?.data;
                double progressPercent = event != null
                    ? event.bytesTransferred / event.totalBytes * 100
                    : 0;
                if (progressPercent == 100) {
                  getTempImage();
                  return Center(child: Text('Upload Completo'));
                } else if (progressPercent == 0) {
                  return SizedBox();
                } else {
                  return LinearProgressIndicator(
                    value: progressPercent,
                  );
                }
              },
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.center,
              child: CustomCursor(
                cursorStyle: CustomCursor.pointer,
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  height: 30,
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
                      await uploadImage();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomCursor(
              cursorStyle: CustomCursor.text,
              child: Form(
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
            ),
            SizedBox(height: 20),
            CustomCursor(
              cursorStyle: CustomCursor.pointer,
              child: RaisedButton(
                color: Colors.blue,
                child: Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    fmodel.updateUserDisplayName(_controller.text);
                  }
                  var image = await getImage();
                  // print(image.toString());
                  fmodel.updateUserPhotoURL(image.toString());
                  showDialog(
                    context: context,
                    child: Dialog(
                      child: Container(
                        width: 300,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Center(
                                child: Text(
                                  "Perfil editado com sucesso.",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 70),
                                child: CustomCursor(
                                  cursorStyle: CustomCursor.pointer,
                                  child: RaisedButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    color: Colors.blue,
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
