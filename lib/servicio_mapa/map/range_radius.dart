import 'package:bicycle_social_network/servicio_mapa/map/bloc/maps_bloc.dart';
import 'package:bicycle_social_network/servicio_mapa/map/bloc/bloc.dart';
import 'package:bicycle_social_network/views/View_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RangeRadius extends StatefulWidget {
  bool isRadiusFixed;
  User detailsUser;
  LatLng radLoc;
  LatLng mapPos;

  RangeRadius(
      {@required this.isRadiusFixed,
      this.radLoc,
      this.detailsUser,
      this.mapPos});

  @override
  _RangeRadiusState createState() => _RangeRadiusState();
}

class _RangeRadiusState extends State<RangeRadius> {
  double _radius = 100;
  MapsBloc _mapsBloc;
  @override
  void initState() {
    super.initState();
    _mapsBloc = BlocProvider.of<MapsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _mapsBloc,
      listener: (context, state) {
        if (state is RadiusUpdate) {
          _radius = state.radius;
        }
      },
      child: Positioned(
        bottom: 20.0,
        left: 10.0,
        right: 10.0,
        child: Card(
            child: BlocBuilder(
          bloc: _mapsBloc,
          builder: (context, state) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Text('Radio de busqueda: ' +
                    _radius.toInt().toString() +
                    ' Mtrs'),
                Slider(
                  max: 700,
                  min: 100,
                  value: _radius,
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey,
                  divisions: 12,
                  onChanged: (double value) {
                    if (!widget.isRadiusFixed) {
                      _mapsBloc.add(UpdateRangeValues(radius: value));
                    }
                  },
                ),
                FlatButton(
                  child: Text(widget.isRadiusFixed != true
                      ? 'Reportar Perdida'
                      : 'Cancelar'),
                  onPressed: () {
                    _mapsBloc.add(IsRadiusFixedPressed(
                        isRadiusFixed: widget.isRadiusFixed));
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Home(
                          detailsUser: widget.detailsUser,
                          alerta: "activo",
                        ),
                      ),
                    );
                    _mapsBloc.add(GenerateMarkerToCompareLocation(
                        mapPosition: widget.mapPos,
                        radiusLocation: widget.radLoc,
                        radius: _radius));
                  },
                  color:
                      widget.isRadiusFixed != true ? Colors.red : Colors.green,
                  textColor: Colors.white,
                )
              ],
            );
          },
        )),
      ),
    );
  }
}
