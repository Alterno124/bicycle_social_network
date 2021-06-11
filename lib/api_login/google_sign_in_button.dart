import 'package:bicycle_social_network/utilities/authentication.dart';
import 'package:bicycle_social_network/views/View_home.dart';
import 'package:bicycle_social_network/views/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  bool valida = false;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      minWidth: double.maxFinite,
      height: 50,
      onPressed: () async {
        setState(() {
          _isSigningIn = true;
        });
        User user = await Authentication.signInWithGoogle(context: context);
        setState(() {
          _isSigningIn = false;
        });
        if (user != null) {
          FirebaseFirestore.instance
              .collection("UsersBikes")
              .doc(user.displayName)
              .get()
              .then((value) {
            if (value.data()["email"] != null) {
              valida = true;
            }
          });
          if (valida == true) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Home(
                  detailsUser: user,
                ),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Success(
                  detailsUser: user,
                ),
              ),
            );
          }
        }
      },
      color: HexColor("#4c8bf5"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.google),
          SizedBox(width: 10),
          Text('Continuar con Google',
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      textColor: Colors.white,
    );
  }
}
