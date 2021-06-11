import 'dart:io';

import 'package:adobe_xd/adobe_xd.dart';
import 'package:bicycle_social_network/servicio_mapa/map/fixed_gps_icon.dart';
import 'package:bicycle_social_network/servicio_mapa/map/location_user.dart';
import 'package:bicycle_social_network/servicio_mapa/map/map_option.dart';
import 'package:bicycle_social_network/servicio_mapa/map/range_radius.dart';
import 'package:bicycle_social_network/servicio_mapa/map/search_place.dart';
import 'package:bicycle_social_network/views/View_Bikes.dart';
import 'package:bicycle_social_network/views/View_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'bloc/maps_bloc.dart';
import 'bloc/maps_event.dart';
import 'bloc/maps_state.dart';

class Maps extends StatefulWidget {
  final GoogleSignIn _gSignIn = GoogleSignIn();
  final User detailsUser;
  Maps({Key key, @required this.detailsUser}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MapState();
  }
}

class _MapState extends State<Maps> {
  DatabaseReference _ref;
  GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final Set<Circle> _circle = {};
  double _radius = 100.0;
  double _zoom = 18.0;
  bool _showFixedGpsIcon = false;
  bool _isRadiusFixed = false;
  String error;
  static LatLng _center;
  MapType _currentMapType = MapType.normal;
  LatLng _lastMapPosition;
  MapsBloc _mapsBloc;

  Widget _googleMapsWidget(MapsState state) {
    return GoogleMap(
      onTap: (LatLng location) {
        if (_isRadiusFixed) {
          _mapsBloc.add(GenerateMarkerToCompareLocation(
              mapPosition: location,
              radiusLocation: _lastMapPosition,
              radius: _radius));
        }
      },
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: _zoom,
      ),
      circles: _circle,
      markers: _markers,
      onCameraMove: _onCameraMove,
      onCameraIdle: () {
        if (_isRadiusFixed != true)
          _mapsBloc.add(
            GenerateMarkerWithRadius(
                lastPosition: _lastMapPosition, radius: _radius),
          );
      },
      mapType: _currentMapType,
    );
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = Coordinates(position.latitude, position.longitude);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _lastMapPosition = LatLng(position.latitude, position.longitude);
      //print('${placemark[0].name}');
    });
  }

  void _onAddMarkerButtonPressed() {
    _ref.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      int idMarket = 0;
      for (var v in values.values) {
        print(v['latitude']);
        _markers.add(Marker(
          markerId: MarkerId((idMarket++).toString()),
          position:
              LatLng(double.parse(v["latitude"]), double.parse(v["longitude"])),
          infoWindow: InfoWindow(
            title: v["nombre"],
            //snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      }
    });
    setState(() {
      _markers;
    });
  }

  @override
  void initState() {
    _center = null;
    super.initState();
    _ref = FirebaseDatabase.instance.reference().child('Localizacion');
    _onAddMarkerButtonPressed();
    _getUserLocation();
    _mapsBloc = BlocProvider.of<MapsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  width: 80,
                ),
                IconButton(
                  icon: Icon(Icons.directions_bike_outlined),
                  color: Colors.white,
                  onPressed: () async{
                    FirebaseApp firebaseApp =
                                await Firebase.initializeApp();
                            String imagen;
                            FirebaseFirestore.instance
                                .collection("UsersBikes")
                                .doc(widget.detailsUser.displayName)
                                .get()
                                .then((value) {
                              imagen = value.data()["imagen_Bicicleta_1"];
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new View_Bikes(
                                    detailsUser: widget.detailsUser,
                                    imagen: imagen,
                                  ),
                                ),
                              );
                            });
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
      body: _center == null
          ? Container(
              child: Center(
                child: Text(
                  'Estamos cargando tu ubicación....',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : BlocListener(
              bloc: _mapsBloc,
              listener: (BuildContext context, MapsState state) {
                if (state is LocationUserfound) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _lastMapPosition =
                      LatLng(state.locationModel.lat, state.locationModel.long);
                  _animateCamera();
                }
                if (state is MarkerWithRadius) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _showFixedGpsIcon = false;

                  if (_markers.isNotEmpty) {
                    //_markers.clear();
                  }
                  if (_circle.isNotEmpty) {
                    _circle.clear();
                  }
                  //_markers.add(state.raidiusModel.marker);
                  _circle.add(state.raidiusModel.circle);
                }

                if (state is RadiusFixedUpdate) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _isRadiusFixed = state.radiusFixed;
                }

                if (state is MapTypeChanged) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _currentMapType = state.mapType;
                }
                if (state is RadiusUpdate) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _radius = state.radius;
                  _zoom = state.zoom;
                  _animateCamera();
                }
                if (state is MarkerWithSnackbar) {
                  //_markers.add(state.marker);
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(state.snackBar);
                }
                if (state is LocationFromPlaceFound) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _lastMapPosition =
                      LatLng(state.locationModel.lat, state.locationModel.long);
                }
                if (state is Failure) {
                  print('Failure');
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Error'), Icon(Icons.error)],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
                if (state is Loading) {
                  print('loading');
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Cargando'),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                }
              },
              child: BlocBuilder(
                  bloc: _mapsBloc,
                  builder: (BuildContext context, MapsState state) {
                    return Scaffold(
                      body: Stack(
                        children: <Widget>[
                          _googleMapsWidget(state),
                          FixedLocationGps(showFixedGpsIcon: _showFixedGpsIcon),
                          MapOption(mapType: _currentMapType),
                          LocationUser(),
                          SearchPlace(onPressed: _animateCamera),
                          Pinned.fromSize(
                            bounds: Rect.fromLTWH(65.0, 600.0, 250.0, 135.0),
                            size: Size(375.0, 812.0),
                            pinBottom: true,
                            fixedWidth: true,
                            fixedHeight: true,
                            child: RangeRadius(
                              isRadiusFixed: _isRadiusFixed,
                              detailsUser: widget.detailsUser,
                              radLoc: _center,
                              mapPos: _lastMapPosition,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onCameraMove(CameraPosition position) {
    if (!_isRadiusFixed) _lastMapPosition = position.target;
    if (_showFixedGpsIcon != true && _isRadiusFixed != true) {
      setState(() {
        _showFixedGpsIcon = true;
        if (_markers.isNotEmpty) {
          //_markers.clear();
          _circle.clear();
        }
      });
    }
  }

  void _animateCamera() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _lastMapPosition,
          zoom: _zoom,
        ),
      ),
    );
  }
}
