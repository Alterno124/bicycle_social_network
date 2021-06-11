import 'package:bicycle_social_network/views/View_Registro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfileScreen extends StatelessWidget {
  final User detailsUser;

  ProfileScreen({Key key, @required this.detailsUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _gSignIn = GoogleSignIn();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image(
                image: AssetImage(
                  'Images/banner_4.jpg',
                ),
                height: 300.0,
                width: 300.0,
              ),
            ),
            SizedBox(height: 30.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '¡Hola ' + detailsUser.displayName + "!",
                  style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(color: HexColor("00B1EB"), fontSize: 28),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      "Registraremos tu bicicleta para ofrecerte una mejor seguridad.",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Center(
                  child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new View_Registro(
                            ),
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(500.0))),
                    label: Text(
                      'Registrar',
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
