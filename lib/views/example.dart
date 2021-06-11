/*import 'dart:convert';
import 'dart:io';
import 'package:bicycle_social_network/views/View_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:bicycle_social_network/services/SRVRegistro.dart';
import 'package:path/path.dart' as p;

List<Asset> resultList = <Asset>[];
List<Asset> images = <Asset>[];
String _error = 'No Error Dectected';

class View_Registro extends StatefulWidget {
  final User detailsUser;
  View_Registro({Key key, @required this.detailsUser}) : super(key: key);

  @override
  _View_RegistroState createState() =>
      _View_RegistroState(detailsUser: detailsUser);
}

class _View_RegistroState extends State<View_Registro> {
  final GoogleSignIn _gSignIn = GoogleSignIn();
  final User detailsUser;
  _View_RegistroState({Key key, @required this.detailsUser});
  String studentName, studentId, studentProgramId;
  double studentGpa;
  String uid = FirebaseAuth.instance.currentUser.uid;
  int contador = 0;

  getStudentName(name) {
    this.studentName = name;
  }

  getStudentId(id) {
    this.studentId = id;
  }

  getStudyProgramId(programId) {
    this.studentProgramId = programId;
  }

  getStudentGpa(gpa) {
    this.studentGpa = double.parse(gpa);
  }

  createData(String base64, int id, String descripcion, String email,
      String nombre) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    if (contador == 0) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("UsersBikes").doc(nombre);
      Map<String, dynamic> students = {
        "descripcion": descripcion,
        "email": email,
        "imagen_Bicicleta_1": base64,
        "nombre": nombre,
        "user_Id": uid
      };
      documentReference.set(students).whenComplete(() {
        print("$studentName created");
      });
    }
    if (id == 0) {
      contador++;
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("UsersBikes").doc(nombre);
      Map<String, dynamic> students = {
        "descripcion": descripcion,
        "email": email,
        "imagen_Bicicleta_1": base64,
        "nombre": nombre,
        "user_Id": uid
      };
      documentReference.set(students).whenComplete(() {
        print("$studentName created");
      });
    }
    if (id == 1) {
      contador++;
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("UsersBikes").doc(nombre);
      Map<String, dynamic> students = {
        "descripcion": descripcion,
        "email": email,
        "imagen_Bicicleta_2": base64,
        "nombre": nombre,
        "user_Id": uid
      };
      documentReference.update(students).whenComplete(() {
        print("$studentName created");
      });
    }
    if (id == 2) {
      contador++;
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("UsersBikes").doc(nombre);
      Map<String, dynamic> students = {
        "descripcion": descripcion,
        "email": email,
        "imagen_Bicicleta_3": base64,
        "nombre": nombre,
        "user_Id": uid
      };
      documentReference.update(students).whenComplete(() {
        print("$studentName created");
      });
    }
  }

  readData() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection("UsersBikes")
        .doc(studentName)
        .get()
        .then((value) {
      print(value.data()["studentName"]);
      print(value.data()["studentId"]);
      print(value.data()["studyProgramId"]);
      print(value.data()["studentGpa"]);
    });
  }

  updateData() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);
    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentId": studentId,
      "studyProgramId": studentProgramId,
      "studentGpa": studentGpa
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName created");
    });
  }

  deleteData() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);
    documentReference.delete().whenComplete(() {
      print("Student delete");
    });
  }

  @override
  Widget build(BuildContext context) {
    final _claveFormulario = GlobalKey<FormState>();
    TextEditingController descripcionController = new TextEditingController();

    final titulo = Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(
                'Images/banner_5.jpg',
              ),
              height: 300.0,
              width: 300.0,
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            'Registro de Bicicleta',
            style: new TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 15.0),
          Text(
              'A continuación, encontrarás un formulario para que ingreses datos básicos de tu bici.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
        ],
      ),
    );

    final descripcion = TextFormField(
      maxLines: 10,
      controller: descripcionController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Debes escribir los componentes de tu bici.';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText:
            'Describe las características únicas que posee tu bici, así como los componentes que la componen.',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final sendButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: EdgeInsets.all(12),
        color: Colors.red,
        child: Text('Continuar', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          for (int i = 0; i < images.length; i++) {
            var path2 =
                await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
            var tipoImagen = p.extension(path2);
            tipoImagen = tipoImagen.split(".").last;
            var newFile = getImageFileFromAssets(path2);
            var base64Image = base64Encode(newFile.readAsBytesSync());
            createData(base64Image, i, descripcionController.text,
                detailsUser.email, detailsUser.displayName);
          }
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
              builder: (context) => new Home(
                detailsUser: detailsUser,
              ),
            ),
          );
          /*if (_claveFormulario.currentState.validate()) {
            registro(detailsUser.email, descripcionController.text);
            Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                builder: (context) => new Home(
                  detailsUser: detailsUser,
                ),
              ),
            );
          }*/
        },
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _claveFormulario,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 48.0),
                titulo,
                SizedBox(
                  height: 200,
                  width: 300,
                  child: Image_Widget(),
                ),
                SizedBox(height: 30.0),
                descripcion,
                sendButton,
              ],
            ),
          ),
        ));
  }
}

/*Future<File> compressFile(File file) async {
  final filePath = file.absolute.path;
  File compressedFile = await FlutterNativeImage.compressImage(
    filePath,
    targetWidth: 300,
    targetHeight: 199,
  );
  return compressedFile;
}*/

File getImageFileFromAssets(String path) {
  final file = File(path);
  return file;
}

class Image_Widget extends StatefulWidget {
  @override
  _Image_WidgetState createState() => _Image_WidgetState();
}

class _Image_WidgetState extends State<Image_Widget> {
  int _counter = 0;
  bool _isButtonDisabled;

  @override
  void initState() {
    _isButtonDisabled = false;
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _isButtonDisabled = true;
      _counter++;
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#ff0000",
          actionBarTitle: "Selecciona la galería",
          allViewTitle: "Todas mis fotos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _isButtonDisabled = true;
      _counter++;
      images = resultList;
      //enviarImagenes();
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Center(child: Text('Error: $_error')),
        RaisedButton(
          color: Colors.red,
          textColor: Colors.white,
          child: new Text(_isButtonDisabled
              ? "Selecciona las fotos de tu bici"
              : "Selecciona las fotos de tu bici"),
          onPressed:
              _isButtonDisabled ? null : /*_incrementCounter*/ loadAssets,
        ),
        /*ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // background
            onPrimary: Colors.white, // foreground
          ),
          child: Text("Selecciona las fotos de tu bici"),
          onPressed: loadAssets,
        ),*/
        Expanded(
          child: buildGridView(),
        )
      ],
    );
  }

  enviarImagenes() async {
    for (int i = 0; i < images.length; i++) {
      var path2 =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      var tipoImagen = p.extension(path2);
      tipoImagen = tipoImagen.split(".").last;
      var newFile = getImageFileFromAssets(path2);
      var base64Image = base64Encode(newFile.readAsBytesSync());
      foto(base64Image, tipoImagen);
    }
  }
}*/

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async {
  runApp(MaterialApp(
    home: Stepper(),
  ));
}

class Stepper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}