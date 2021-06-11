import 'package:bicycle_social_network/servicio_mapa/map/bloc/bloc.dart';
import 'package:bicycle_social_network/views/View_Bikes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bicycle_social_network/servicio_mapa/map/maps.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categories extends StatefulWidget {
  final User detailsUser;
  Categories({Key key, @required this.detailsUser}) : super(key: key);
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int currentSelectedItem = 0;
  @override
  Widget build(BuildContext context) {
    int items = 2;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items,
          itemBuilder: (context, index) => Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    margin: EdgeInsets.only(
                      //left: 10,
                      left: queryData.size.width / 5.5,
                      right: 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() async {
                          currentSelectedItem = index;
                          if (index == 0) {
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
                          }
                          if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return BlocProvider(
                                    create: (BuildContext context) =>
                                        MapsBloc(),
                                    child: new Maps(
                                      detailsUser: widget.detailsUser,
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          if (index == 2) {}
                          if (index == 3) {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => new Maps(
                                  detailsUser: widget.detailsUser,
                                ),
                              ),
                            );
                          }
                        });
                      },
                      child: Card(
                        color: index == currentSelectedItem
                            ? Colors.blue
                            : Colors.white,
                        child: Icon(
                          index == 0
                              ? Icons.directions_bike_outlined
                              : index == 1
                                  ? Icons.add_location_alt_rounded
                                  : index == 2
                                      ? Icons.textsms_outlined
                                      : index == 3
                                          ? Icons.add_location_rounded
                                          : "",
                          color: index == currentSelectedItem
                              ? Colors.white
                              : Colors.black.withOpacity(0.7),
                        ),
                        elevation: 3,
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(
                    //left: index == 0 ? 20 : 0,
                    //left: 10,
                    left: queryData.size.width / 5.5,
                    right: 0,
                  ),
                  width: 90,
                  child: Row(
                    children: [
                      Spacer(),
                      Text(index == 0
                          ? "Bicicletas"
                          : index == 1
                              ? "Reportar"
                              : index == 2
                                  ? "Bloc"
                                  : index == 3
                                      ? "Reportar"
                                      : ""),
                      Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
