import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatefulWidget {
  String id_robo;
  String imagen;
  String descripcion;

  Portfolio({Key key, this.id_robo, this.imagen, this.descripcion})
      : super(key: key);
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    int items = 10;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return widget.id_robo != null
        ? SliverToBoxAdapter(
            child: Container(
              height: 400,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        height: 400,
                        width: 200,
                        margin: EdgeInsets.only(
                          left: 5,
                          right: index == items ? 20 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                      'Propietario: ' + widget.id_robo + "."),
                                  subtitle: Text('Descripcion: ' + widget.descripcion),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.memory(base64Decode(widget.imagen)),
                                ),
                                RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: EdgeInsets.all(12),
                                    color: Colors.orange,
                                    child: Text('¡La he visto!',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () async {},
                                  ),
                              ],
                            ),
                          ),
                          /*Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: ListView(
                              children: [
                                Text(
                                  widget.id_robo
                                ),
                                Image.network(
                                  'https://placeimg.com/640/480/any',
                                  fit: BoxFit.fill,
                                )
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                          ),*/
                          /*Card(
                            color: Colors.orange[400],
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text(widget.id_robo,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: EdgeInsets.all(12),
                                    color: Colors.white,
                                    child: Text('¡La he visto!',
                                        style: TextStyle(color: Colors.black)),
                                    onPressed: () async {},
                                  ),
                                ],
                              ),
                            ),
                            elevation: 3,
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(45),
                                  bottomRight: Radius.circular(45),
                                  topLeft: Radius.circular(45),
                                  topRight: Radius.circular(45)),
                            ),
                          ),*/
                        ),
                      ),
                      /*Positioned(
                  height: 200,
                  width: 200,
                  child: GestureDetector(
                    onTap:(){
                    },
                    child: Image.network('https://picsum.photos/250?image=9'),
                  ),
                )*/
                    ],
                  );
                },
              ),
            ),
          )
        : SliverToBoxAdapter(
            child: Container(
              height: queryData.size.height / 4,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        height: queryData.size.height / 0.1,
                        width: queryData.size.width / 2,
                        margin: EdgeInsets.only(
                          left: 5,
                          right: index == items ? 20 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                        ),
                      ),
                      /*Positioned(
                  height: 200,
                  width: 200,
                  child: GestureDetector(
                    onTap:(){
                    },
                    child: Image.network('https://picsum.photos/250?image=9'),
                  ),
                )*/
                    ],
                  );
                },
              ),
            ),
          );
  }
}
