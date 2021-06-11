import 'dart:convert';
import 'package:bicycle_social_network/servicio_mapa/map/bloc/bloc.dart';
import 'package:bicycle_social_network/views/View_Registro.dart';
import 'package:bicycle_social_network/views/View_home.dart';
import 'package:bicycle_social_network/views/View_login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_social_network/services/SRVRegistro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bicycle_social_network/servicio_mapa/map/maps.dart';

class View_Bikes extends StatelessWidget {
  final User detailsUser;
  String imagen;
  View_Bikes({Key key, @required this.detailsUser, this.imagen})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.red,
          centerTitle: true,
        ),
        bottomAppBarColor: Colors.blue[900],
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.orange),
      ),
      home: View_BikesP(
        detailsUser: detailsUser,
        imagen: imagen,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class View_BikesP extends StatefulWidget {
  final User detailsUser;
  String imagen;
  View_BikesP({Key key, @required this.detailsUser, this.imagen})
      : super(key: key);

  _View_BikesStateP createState() => _View_BikesStateP();
}

class _View_BikesStateP extends State<View_BikesP> {
  //creamos un arreglo de datos imagenes y nombre ejercicio
  List<Container> listamos = List();

  var arreglox = [
    {
      "nombre": "Pierna",
      "imagen": "banner_3.jpg",
      "deporte": "Trabajo con polea 4 repiticiones de 12"
    },
    {
      "nombre": "Pesas",
      "imagen": "pesas.jpg",
      "deporte": "Trabajo con pesas...."
    },
    {
      "nombre": "Cinta Elastica",
      "imagen": "cinta.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Cinta",
      "imagen": "cinta2.jpg",
      "deporte": "Trabajo con cinta 2 repeticiones de 15"
    },
    {
      "nombre": "Abdomen",
      "imagen": "abdomen2.jpg",
      "deporte": "Abdomen alto..."
    },
    {"nombre": "Peso", "imagen": "peso.jpg", "deporte": "Trabajo pesas de 5kg"},
    {
      "nombre": "Pierna + Gluteos",
      "imagen": "pierna2.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Gluteos",
      "imagen": "gluteos.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Mas Gluteos",
      "imagen": "gluteos2.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Pierna..",
      "imagen": "pierna.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Barra",
      "imagen": "barra2.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Rusa",
      "imagen": "rusa.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Pierna..",
      "imagen": "pierna3.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Cinta Elastica",
      "imagen": "cinta2.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Peso z",
      "imagen": "peso2.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Mancuernas",
      "imagen": "mancuernas.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Estiramiento",
      "imagen": "estiramiento.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
    {
      "nombre": "Otro",
      "imagen": "otro.png",
      "deporte": "Fortalece pierna y Gluteos"
    },
    {"nombre": "Otro+", "imagen": "otro1.png", "deporte": "pierna y Gluteos"},
    {
      "nombre": "mas Ejercicio",
      "imagen": "pierna5.png",
      "deporte": "Fortalece pierna y Gluteos"
    },
    {
      "nombre": "barra de 5k",
      "imagen": "barra.jpg",
      "deporte": "Trabajo con cinta 4 repeticiones de 15"
    },
  ];

  Future getData() async {
    var parsedJson = await getImagenes("rubenchoortegon@gmail.com");
    return parsedJson;
  }

  _listado() async {
    for (var i = 0; i < 1; i++) {
      final int contador = i + 1;
      final arregloxyz = arreglox[i];
      final String imagen = arregloxyz["imagen"];
      final String nombreDato = "Imagen$contador";
      listamos.add(new Container(
          padding: new EdgeInsets.all(10.0),
          child: new Card(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                new Hero(
                  tag: arregloxyz['nombre'],
                  child: new Material(
                    child: new InkWell(
                      onTap: () =>
                          Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new Detalle(
                            detailsUser: widget.detailsUser,
                            nombre: arregloxyz['nombre'],
                            imagen: imagen,
                            deporte: arregloxyz['deporte']),
                      )),
                      child: Image.memory(base64Decode(widget.imagen)),
                    ),
                  ),
                ),
                /*new Center(
                    child: Icon(Icons.search),
                  ),*/
              ],
            ),
          )));
    }

    /*for (var i = 0; i < 1; i++) {
      final int contador = i + 1;
      final arregloxyz = arreglox[i];
      final String imagen = arregloxyz["imagen"];
      final String nombreDato = "Imagen$contador";
      listamos.add(new Container(
          padding: new EdgeInsets.all(10.0),
          child: new FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  var mydata = snapshot.data;
                  return Card(
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        new Hero(
                          tag: arregloxyz['nombre'],
                          child: new Material(
                            child: new InkWell(
                              onTap: () => Navigator.of(context)
                                  .push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Detalle(
                                    detailsUser: widget.detailsUser,
                                    nombre: arregloxyz['nombre'],
                                    imagen: imagen,
                                    deporte: arregloxyz['deporte']),
                              )),
                              child:
                                  Image.memory(base64Decode(mydata['Imagen1'])),
                            ),
                          ),
                        ),
                        new Center(
                          child: Icon(Icons.search),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })));
    }*/
  }

  @override
  void initState() {
    _listado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _gSignIn = GoogleSignIn();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
      ),
      /*drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.detailsUser.photoURL),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.detailsUser.displayName,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.detailsUser.email,
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue[200],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Inicio"),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new Home(
                      detailsUser: widget.detailsUser,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_bike_sharp),
              title: Text("Amigos ciclistas"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text("Bloc ciclista"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Acerca de Seku"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Comparte con ciclistas"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.flag),
              title: Text("Políticas y privacidad"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Salir"),
              onTap: () {
                _gSignIn.signOut();
                print('Signed out');
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new View_login(),
                  ),
                );
              },
            ),
          ],
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.directions_bike_outlined),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
        child: Container(
          color: Colors.black38,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                ),
                IconButton(
                  icon: Icon(Icons.add_location_rounded),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return BlocProvider(
                            create: (BuildContext context) => MapsBloc(),
                            child: new Maps(
                              detailsUser: widget.detailsUser,
                            ),
                          );
                        },
                      ),
                    );
                    /*
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new View_map(
                          detailsUser: widget.detailsUser,
                        ),
                      ),
                    );*/
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                /*IconButton(
                  icon: Icon(Icons.contact_phone_outlined),
                  color: Colors.white,
                  onPressed: () {},
                ),*/
                Spacer(),
                /*IconButton(
                  icon: Icon(Icons.textsms_outlined),
                  color: Colors.white,
                  onPressed: () {},
                ),*/
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Home(
                          detailsUser: widget.detailsUser,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 80,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image(
                        image: AssetImage(
                          'Images/banner_6.jpg',
                        ),
                        height: 200.0,
                        width: 200.0,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      'Tus bicicletas',
                      style: new TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                        'A continuación podrás ver tus bicicletas registradas.',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                width: 300,
                child: new GridView.count(
                  crossAxisCount:
                      3, //numero de columas de la primera pagina pruebn con 1
                  mainAxisSpacing: 0.1, //espacio entre card
                  childAspectRatio: 0.700, //espacio largo de cada card
                  children: listamos,
                ),
              ),
              SizedBox(height: 1.0),
              /*Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.all(12),
                  color: Colors.blue[300],
                  child: Text('Agregar nueva bicicleta',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {},
                ),
              ),*/
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}

class Detalle extends StatelessWidget {
  final User detailsUser;
  final String nombre;
  final String imagen;
  final String deporte;
  Detalle({this.nombre, this.imagen, this.deporte, this.detailsUser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.grey,
          cardColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.red,
            centerTitle: true,
          ),
          bottomAppBarColor: Colors.teal,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.orange),
        ),
        home: DetalleP(
            detailsUser: detailsUser,
            nombre: nombre,
            imagen: imagen,
            deporte: deporte));
  }
}

//creamos el metodo detalle
//este se usa cuando pulsamos para ver segunda pantalla la descripcion del ejercicio
class DetalleP extends StatelessWidget {
  final User detailsUser;
  final String nombre;
  final String imagen;
  final String deporte;
  DetalleP({this.nombre, this.imagen, this.deporte, this.detailsUser});

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _gSignIn = GoogleSignIn();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(detailsUser.photoURL),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    detailsUser.displayName,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    detailsUser.displayName,
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue[200],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Inicio"),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new Home(
                      detailsUser: detailsUser,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_bike_sharp),
              title: Text("Amigos ciclistas"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text("Bloc ciclista"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Acerca de Seku"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Comparte con ciclistas"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.flag),
              title: Text("Políticas y privacidad"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Salir"),
              onTap: () {
                _gSignIn.signOut();
                print('Signed out');
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new View_login(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
        child: Container(
          color: Colors.black38,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Home(
                          detailsUser: detailsUser,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: Icon(Icons.contact_phone_outlined),
                  color: Colors.white,
                  onPressed: () {},
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.textsms_outlined),
                  color: Colors.white,
                  onPressed: () {},
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: Icon(Icons.add_location_rounded),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Maps(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 25,
                ),
              ],
            ),
          ),
        ),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
              height: 387.0, //tamaño de la segunda imagen
              child: new Hero(
                tag: nombre,
                child: new Material(
                  child: new InkWell(
                    child: Carousel(),
                  ),
                ),
              )),
          /*new IniciarNombre(
            nombre: nombre,
          ),*/
          new Informacion(
            deporte: deporte,
          ),
          new IniciarIcon(),
        ],
      ),
    );
  }
}

class Carousel extends StatelessWidget {
  Future getData() async {
    var parsedJson = await getImagenes("rubenchoortegon@gmail.com");
    return parsedJson;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var mydata = snapshot.data;
            return CarouselSlider(
              options: CarouselOptions(
                height: 400.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),
              ),
              items: <Widget>[
                for (var i = 1; i < 4; i++)
                  Container(
                    color: Colors.white,
                    child: Image.memory(base64Decode(mydata['Imagen$i'])),
                    margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                  ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

/*class IniciarNombre extends StatelessWidget {
  IniciarNombre({this.nombre});
  final String nombre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  nombre,
                  style: new TextStyle(fontSize: 20.0, color: Colors.blue),
                ),
                new Text(
                  "$nombre\@gmail.com",
                  style: new TextStyle(fontSize: 15.0, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          new Row(
            children: <Widget>[
              new Icon(
                //icono que agrega estrellas calificacion
                Icons.star,
                size: 30.0,
                color: Colors.red,
              ),
              new Icon(
                Icons.star,
                size: 30.0,
                color: Colors.orange,
              ),
              new Icon(
                Icons.star,
                size: 30.0,
                color: Colors.purple,
              ),
              new Text(
                "12",
                style: new TextStyle(fontSize: 18.0),
              )
            ],
          )
        ],
      ),
    );
  }
}*/

class IniciarIcon extends StatelessWidget {
  final User detailsUser;
  IniciarIcon({this.detailsUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(10.0),
      child: new Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.green,
                child: Text('Editar', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  /*Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new View_Registro()));*/
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: EdgeInsets.all(12),
                color: Colors.red,
                child: Text('Eliminar', style: TextStyle(color: Colors.white)),
                onPressed: () async {},
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text("                                           ")),
        ],
      ),
    );
  }
}

class IconTec extends StatelessWidget {
  IconTec({this.icon, this.tec});
  final IconData icon;
  final String tec;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Icon(
            icon,
            size: 50.0,
            color: Colors.blue,
          ),
          new Text(
            tec,
            style: new TextStyle(fontSize: 12.0, color: Colors.blue),
          )
        ],
      ),
    );
  }
}

class Informacion extends StatelessWidget {
  Informacion({this.deporte});
  final String deporte;

  Future getData() async {
    var parsedJson = await getRegistro("rubenchoortegon@gmail.com");
    return parsedJson;
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var mydata = snapshot.data;
            return Container(
              padding: new EdgeInsets.all(10.0),
              child: new Card(
                child: new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Text(
                    "Descripción: " + mydata['Descripcion'],
                    style: new TextStyle(fontSize: 16.0, color: Colors.blue),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
