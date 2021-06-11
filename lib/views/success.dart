import 'package:bicycle_social_network/views/View_ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Success extends StatelessWidget {
  User detailsUser;

  Success({this.detailsUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SuccessApp(
        detailsUser: detailsUser,
      ),
    );
  }
}

class SuccessApp extends StatelessWidget {
  User detailsUser;

  SuccessApp({this.detailsUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("Images/success.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 285),
              Text(
                'Acceso Exitoso',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, fontSize: 28),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: RaisedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(detailsUser: detailsUser),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(500.0))),
                  label: Text(
                    'Continuar',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: HexColor("00B1EB"),
                  color: HexColor("00B1EB"),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
