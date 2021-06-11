import 'dart:math';
import 'dart:ui';
import 'package:bicycle_social_network/views/View_home.dart';
import 'package:bicycle_social_network/views/View_map.dart';
import 'package:bicycle_social_network/servicio_mapa/map/maps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final reference = FirebaseDatabase.instance.reference();
  final User detailsUser;
  String alerta;
  Header({Key key, @required this.detailsUser, this.alerta}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    String url;
    bool twitter = false;
    UserInfo photo = detailsUser.providerData[0];
    if (photo.photoURL.contains("_normal")) {
      url = photo.photoURL.replaceAll("_normal", "");
      twitter = true;
    } else {
      url = photo.photoURL;
    }
    return SliverList(
        delegate: SliverChildListDelegate(
      [
        Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: size.height / 5,
                  decoration: BoxDecoration(
                      color: alerta == "activo" ? Colors.red : Colors.blue[200],
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(45),
                      ),
                      boxShadow: [BoxShadow(blurRadius: 2)]),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white70,
                              radius: 35,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(url),
                                radius: 30,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                Text(
                                  detailsUser.displayName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: queryData.size.width / 22),
                                ),
                                twitter ? Container(
                                  padding: EdgeInsets.all(4),
                                  child: Text(""),
                                ) : Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black54),
                                  child: Text(
                                    detailsUser.email,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: queryData.size.width / 30),
                                  ),
                                ),
                                alerta == "activo"
                                    ? RaisedButton(
                                        onPressed: () {
                                          String uid = FirebaseAuth
                                              .instance.currentUser.uid;
                                          reference
                                              .child('Localizacion')
                                              .child(uid)
                                              .update({
                                            "alerta": 'vacio',
                                          });
                                          Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                              builder: (context) => new Home(
                                                detailsUser: detailsUser,
                                                alerta: "vacio",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(' Cancelar localización '),
                                        color: Colors.black,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
                                        ),
                                      )
                                    : Text(""),
                              ],
                            ),
                            Spacer(),
                            Text(
                              alerta == "activo" ? "Alertando" : "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            SizedBox(
                              height: 35,
                              width: queryData.size.width / 15,
                              child: alerta == "activo"
                                  ? WaterRipplePage()
                                  : Text(""),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            /*Positioned(
              bottom: 0,
              child: Container(
                height: 50,
                width: size.width,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "What does your belly want to eat?",
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(left: 20)
                    ),
                  ),
                ),
              ),
            )*/
          ],
        ),
      ],
    ));
  }
}

class WaterRipplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaterRipple();
  }
}

class WaterRipple extends StatefulWidget {
  final int count;
  final Color color;

  const WaterRipple(
      {Key key, this.count = 3, this.color = const Color(0xFF0080ff)})
      : super(key: key);

  @override
  _WaterRippleState createState() => _WaterRippleState();
}

class _WaterRippleState extends State<WaterRipple>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WaterRipplePainter(_controller.value,
              count: widget.count, color: Colors.black),
        );
      },
    );
  }
}

class WaterRipplePainter extends CustomPainter {
  final double progress;
  final int count;
  final Color color;

  Paint _paint = Paint()..style = PaintingStyle.fill;

  WaterRipplePainter(this.progress,
      {this.count = 3, this.color = const Color(0xFF0080ff)});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width / 2, size.height / 2);

    for (int i = count; i >= 0; i--) {
      final double opacity = (1.0 - ((i + progress) / (count + 1)));
      final Color _color = color.withOpacity(opacity);
      _paint..color = _color;

      double _radius = radius * ((i + progress) / (count + 1));

      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), _radius, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
