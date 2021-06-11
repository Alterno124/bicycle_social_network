import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as p;

List<Asset> resultList = <Asset>[];
List<Asset> images = <Asset>[];
String _error = 'No Error Dectected';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppScreenMode();
  }
}

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}

class MyAppScreenMode extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Steppers'),
          ),
          body: StepperBody(),
        ));
  }
}

class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static MyData data = MyData();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<Step> steps = [
    Step(
        title: const Text('Name'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Form(
          key: formKeys[0],
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _focusNode,
                keyboardType: TextInputType.text,
                autocorrect: false,
                onSaved: (String value) {
                  data.name = value;
                },
                maxLines: 1,
                //initialValue: 'Aseem Wangoo',
                validator: (value) {
                  if (value.isEmpty || value.length < 1) {
                    return 'Please enter name';
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Enter your name',
                    hintText: 'Enter a name',
                    //filled: true,
                    icon: const Icon(Icons.person),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Phone'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: Form(
          key: formKeys[1],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.phone,
                autocorrect: false,
                validator: (value) {
                  if (value.isEmpty || value.length < 10) {
                    return 'Please enter valid number';
                  }
                },
                onSaved: (String value) {
                  data.phone = value;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Enter your number',
                    hintText: 'Enter a number',
                    icon: const Icon(Icons.phone),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Email'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
        content: Form(
          key: formKeys[2],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter valid email';
                  }
                },
                onSaved: (String value) {
                  data.email = value;
                },
                maxLines: 1,
                decoration: InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'Enter a email address',
                    icon: const Icon(Icons.email),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    Step(
        title: const Text('Age'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        content: Form(
          key: formKeys[3],
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                autocorrect: false,
                validator: (value) {
                  if (value.isEmpty || value.length > 2) {
                    return 'Please enter valid age';
                  }
                },
                maxLines: 1,
                onSaved: (String value) {
                  data.age = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter your age',
                    hintText: 'Enter age',
                    icon: const Icon(Icons.explicit),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
    //  Step(
    //     title: const Text('Fifth Step'),
    //     subtitle: const Text('Subtitle'),
    //     isActive: true,
    //     state: StepState.complete,
    //     content: const Text('Enjoy Step Fifth'))
  ];

  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        showSnackBarMessage('Please enter correct data');
      } else {
        formState.save();
        print("Name: ${data.name}");
        print("Phone: ${data.phone}");
        print("Email: ${data.email}");
        print("Age: ${data.age}");

        AlertDialog(
          title: Text("Details"),
          //content:  Text("Hello World"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Name : " + data.name),
                Text("Phone : " + data.phone),
                Text("Email : " + data.email),
                Text("Age : " + data.age),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    }

    return Container(
        child: ListView(children: <Widget>[
      Stepper(
        steps: steps,
        type: StepperType.horizontal,
        currentStep: this.currStep,
        onStepContinue: () {
          setState(() {
            if (formKeys[currStep].currentState.validate()) {
              if (currStep < steps.length - 1) {
                currStep = currStep + 1;
              } else {
                currStep = 0;
              }
            }
            // else {
            // Scaffold
            //     .of(context)
            //     .showSnackBar( SnackBar(content:  Text('$currStep')));

            // if (currStep == 1) {
            //   print('First Step');
            //   print('object' + FocusScope.of(context).toStringDeep());
            // }

            // }
          });
        },
        onStepCancel: () {
          setState(() {
            if (currStep > 0) {
              currStep = currStep - 1;
            } else {
              currStep = 0;
            }
          });
        },
        onStepTapped: (step) {
          setState(() {
            currStep = step;
          });
        },
      ),
      RaisedButton(
        child: Text(
          'Save details',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _submitDetails,
        color: Colors.blue,
      ),
    ]));
  }
}

class View_Registro extends StatefulWidget {
  User detailsUser;
  View_Registro({Key key, this.detailsUser}) : super(key: key);
  @override
  _View_RegistroState createState() => _View_RegistroState();
}

class _View_RegistroState extends State<View_Registro> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
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

  createData(String base64, int id, String email, String nombre) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    if (contador == 0) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("UsersBikes")
          .doc("Eduardo Camargo");
      Map<String, dynamic> students = {
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
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("UsersBikes")
          .doc("Eduardo Camargo");
      Map<String, dynamic> students = {
        "email": "email",
        "imagen_Bicicleta_1": base64,
        "nombre": "nombre",
        "user_Id": "uid"
      };
      documentReference.set(students).whenComplete(() {
        print("$studentName created");
      });
    }
    if (id == 1) {
      contador++;
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("UsersBikes")
          .doc("Eduardo Camargo");
      Map<String, dynamic> students = {
        "email": "email",
        "imagen_Bicicleta_2": base64,
        "nombre": "nombre",
        "user_Id": "uid"
      };
      documentReference.update(students).whenComplete(() {
        print("$studentName created");
      });
    }
    if (id == 2) {
      contador++;
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("UsersBikes")
          .doc("Eduardo Camargo");
      Map<String, dynamic> students = {
        "email": "email",
        "imagen_Bicicleta_3": base64,
        "nombre": "nombre",
        "user_Id": "uid"
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Registro de Bicicleta'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: new Text('Foto',
                        style: GoogleFonts.openSans(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 16),
                        )),
                    content: Column(
                      children: <Widget>[
                        Text(
                          'Ingresa las fotos de tu bicicleta con el objetivo de notificar amigos cercanos si de robo se tratara. ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: new Text(
                            "Seleccionar",
                            style: GoogleFonts.openSans(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          onPressed: loadAssets,
                        ),
                        SizedBox(height: 25),
                        Container(
                          height: 120,
                          width: 400,
                          child: Expanded(
                            child: buildGridView(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                        /*TextFormField(
                                                    decoration:
                                                        InputDecoration(labelText: 'Email Address'),
                                                  ),*/
                        /*TextFormField(
                                                    decoration: InputDecoration(labelText: 'Password'),
                                                  ),*/
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Descripción'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Home Address'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Postcode'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Consejos'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Mobile Number'),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 0) {
      cargarFoto();
    }
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  File getImageFileFromAssets(String path) {
    final file = File(path);
    return file;
  }

  void cargarFoto() async {
    for (int i = 0; i < images.length; i++) {
      var path2 =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      var tipoImagen = p.extension(path2);
      tipoImagen = tipoImagen.split(".").last;
      var newFile = getImageFileFromAssets(path2);
      var base64Image = base64Encode(newFile.readAsBytesSync());
      createData(base64Image, i, "melo", "melo");
    }
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
      images = resultList;
      //enviarImagenes();
      _error = error;
    });
  }
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
