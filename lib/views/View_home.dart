import 'package:bicycle_social_network/views/View_Bikes.dart';
import 'package:bicycle_social_network/views/View_login.dart';
import 'package:bicycle_social_network/views/categories.dart';
import 'package:bicycle_social_network/views/header.dart';
import 'package:bicycle_social_network/servicio_mapa/map/maps.dart';
import 'package:bicycle_social_network/views/portfolio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_social_network/servicio_mapa/map/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatelessWidget {
  final User detailsUser;
  String alerta;
  String datos;
  bool valida;
  String id_robo;
  String imagen;
  String descripcion;

  Home(
      {Key key,
      @required this.detailsUser,
      this.alerta,
      this.datos,
      this.valida,
      this.id_robo,
      this.imagen,
      this.descripcion})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.grey,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: alerta == "activo" ? Colors.red : Colors.blue[200],
          centerTitle: true,
        ),
        bottomAppBarColor: alerta == "activo" ? Colors.red : Colors.blue[900],
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.orange[400]),
      ),
      home: HomeP(
        detailsUser: detailsUser,
        alerta: alerta,
        datos: datos,
        valida: valida,
        id_robo: id_robo,
        imagen: imagen,
        descripcion: descripcion,
      ),
      debugShowCheckedModeBanner: true,
    );
  }
}

class HomeP extends StatefulWidget {
  bool valida;
  final User detailsUser;
  String datos;
  String alerta;
  String id_robo;
  String imagen;
  String descripcion;

  HomeP(
      {Key key,
      @required this.detailsUser,
      this.alerta,
      this.datos,
      this.valida,
      this.id_robo,
      this.imagen,
      this.descripcion})
      : super(key: key);
  @override
  _HomePState createState() => _HomePState(alerta: alerta);
}

class _HomePState extends State<HomeP> {
  bool _initialized = false;
  bool _error = false;
  final reference = FirebaseDatabase.instance.reference();
  String alerta;
  _HomePState({this.alerta});
  String _location = "Obteniendo ubicación...";
  DatabaseReference _ref;
  String ubicacion;
  String uid = FirebaseAuth.instance.currentUser.uid;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance.reference().child('Localizacion');
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      setState(() {
        _location = location.coords.latitude.toString() +
            " | " +
            location.coords.longitude.toString();
        _ref.once().then((DataSnapshot snapshot) async {
          Map<dynamic, dynamic> values = snapshot.value;
          if (values == null) {
            reference.child("Localizacion").child(uid).set({
              "nombre": widget.detailsUser.displayName,
              "token": await FirebaseMessaging.instance.getToken(),
              "alerta": 'vacio',
              "latitude": location.coords.latitude.toString(),
              "longitude": location.coords.longitude.toString()
            });
          } else {
            reference.child('Localizacion').child(uid).update({
              "nombre": widget.detailsUser.displayName,
              "token": await FirebaseMessaging.instance.getToken(),
              "alerta": 'vacio',
              "latitude": location.coords.latitude.toString(),
              "longitude": location.coords.longitude.toString()
            });
          }
        });
      });
      Fluttertoast.showToast(
          msg: "Obteniendo ubicación",
          toastLength: Toast.LENGTH_SHORT,
          //gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          //backgroundColor: Colors.red,
          //textColor: Colors.white,
          fontSize: 16.0);
      //print('[location] - $location');
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      setState(() {
        _location = location.coords.latitude.toString() +
            " | " +
            location.coords.longitude.toString();
      });
      Fluttertoast.showToast(
          msg: "Ubicación obtenida",
          toastLength: Toast.LENGTH_SHORT,
          //gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          //backgroundColor: Colors.red,
          //textColor: Colors.white,
          fontSize: 16.0);
      //print('[location] - $location');
    });
    //print('[motionchange] - $location');

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      Fluttertoast.showToast(
          msg: "Ubicación guardada",
          toastLength: Toast.LENGTH_SHORT,
          //gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          //backgroundColor: Colors.red,
          //textColor: Colors.white,
          fontSize: 16.0);
      //print('[location] - $location');
    });

    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
            notification:
                bg.Notification(title: "Seku", text: "Ubicación activada"),
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: true,
            startOnBoot: true,
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE))
        .then((bg.State state) {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              "Seku",
              style: TextStyle(color: Colors.white),
            ),
            //leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => View_login(),
                    ),
                  );
                },
              )
            ],
          ),
          Header(
            detailsUser: widget.detailsUser,
            alerta: alerta,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 25,
              margin: EdgeInsets.only(
                left: 20,
                right: 0,
              ),
              child: Container(
                width: 90,
                height: 90,
                child: Text(
                  "Servicios",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          /*SliverToBoxAdapter(
            child: Container(
              height: 500,
              margin: EdgeInsets.only(
                left: 20,
                right: 0,
              ),
              child: Container(
                width: 90,
                height: 90,
                child: Flexible(
                  child: new FirebaseAnimatedList(
                      query: _ref,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return new ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _ref.child(snapshot.key).remove(),
                          ),
                          title:
                              new Text(ubicacion = snapshot.value['latitude']),
                        );
                      }),
                ),
              ),
            ),
          ),*/
          Categories(
            detailsUser: widget.detailsUser,
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 20,
            ),
          ),
          widget.id_robo != null
              ? SliverToBoxAdapter(
                  child: Container(
                    height: 25,
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 0,
                    ),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Text(
                        "¡Alertas de robo!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    height: 25,
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 0,
                    ),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Text(
                        "",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
          Portfolio(
            id_robo: widget.id_robo,
            imagen: widget.imagen,
            descripcion: widget.descripcion,
          )
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.home),
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
                  width: 80,
                ),
                IconButton(
                  icon: Icon(Icons.directions_bike_outlined),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new View_Bikes(
                          detailsUser: widget.detailsUser,
                        ),
                      ),
                    );
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
                  width: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
