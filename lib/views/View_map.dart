import 'dart:async';
import 'package:bicycle_social_network/servicio_mapa/map/maps.dart';
import 'package:bicycle_social_network/views/View_Bikes.dart';
import 'package:bicycle_social_network/views/View_home.dart';
import 'package:bicycle_social_network/views/View_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class View_map extends StatelessWidget {
  final User detailsUser;
  View_map({Key key, @required this.detailsUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.grey,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.red,
          centerTitle: true,
        ),
        bottomAppBarColor: Colors.grey,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.orange),
      ),
      home: Map(
        detailsUser: detailsUser,
      ),
    );
  }
}

class Map extends StatefulWidget {
  final GoogleSignIn _gSignIn = GoogleSignIn();
  final User detailsUser;
  Map({Key key, @required this.detailsUser}) : super(key: key);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final reference = FirebaseDatabase.instance.reference();
  final GoogleSignIn _gSignIn = GoogleSignIn();
  Completer<GoogleMapController> controller1;
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = Coordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      //print('${placemark[0].name}');
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
              title: "Pizza Parlour",
              snippet: "This is a snippet",
              onTap: () {}),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              leading: Icon(Icons.pedal_bike_sharp),
              title: Text("Mis bicicletas"),
              onTap: () {
                /*Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new View_Bikes(
                      detailsUser: widget.detailsUser,
                    ),
                  ),
                );*/
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new Home(detailsUser: widget.detailsUser,),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_location_rounded),
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
                          detailsUser: widget.detailsUser,
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
                        builder: (context) => new Maps(detailsUser: widget.detailsUser,),
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
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: const Color(0xffffffff),
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'Estamos cargando tu ubicación....',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Container(
              child: Stack(
                children: <Widget>[
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 812.0),
                    size: Size(375.0, 812.0),
                    pinLeft: true,
                    pinRight: true,
                    pinTop: true,
                    pinBottom: true,
                    child:
                        // Adobe XD layer: 'map' (shape)
                        Container(
                      child: GoogleMap(
                        markers: _markers,
                        mapType: _currentMapType,
                        initialCameraPosition: CameraPosition(
                          target: _initialPosition,
                          zoom: 14.4746,
                        ),
                        onMapCreated: _onMapCreated,
                        zoomGesturesEnabled: true,
                        onCameraMove: _onCameraMove,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        myLocationButtonEnabled: true,
                      ),
                    ),
                  ),
                  /*Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            mapButton(_onAddMarkerButtonPressed,
                                Icon(Icons.add_location), Colors.blue),
                            mapButton(
                                _onMapTypeButtonPressed,
                                Icon(
                                  IconData(0xf473,
                                      fontFamily: CupertinoIcons.iconFont,
                                      fontPackage:
                                          CupertinoIcons.iconFontPackage),
                                ),
                                Colors.green),
                          ],
                        )),
                  ),*/
                  Pinned.fromSize(
                    bounds: Rect.fromLTWH(65.0, 680.0, 200.0, 50.0),
                    size: Size(375.0, 812.0),
                    pinBottom: true,
                    fixedWidth: true,
                    fixedHeight: true,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              reference.child("1").set({
                                'id': 'ID1',
                                'data': 'This is a sample Data'
                              });
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new Home(
                                    detailsUser: widget.detailsUser,
                                    alerta: "activo",
                                  ),
                                ),
                              );
                            },
                            child: Text(' Reportar perdida '),
                            color: Colors.deepOrange,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
    );
  }
}
