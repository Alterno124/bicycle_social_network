import 'package:bicycle_social_network/views/View_ProfileScreen.dart';
import 'package:bicycle_social_network/views/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class FacebookSignInButton extends StatefulWidget {
  @override
  _FacebookSignInButtonState createState() => _FacebookSignInButtonState();
}

class _FacebookSignInButtonState extends State<FacebookSignInButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      minWidth: double.maxFinite,
      height: 50,
      onPressed: () async {
        FacebookLogin facebookSignIn = new FacebookLogin();
        final FacebookLoginResult result =
            await facebookSignIn.logIn(['email']);
        FirebaseApp firebaseApp = await Firebase.initializeApp();
        final FacebookAccessToken accessToken = result.accessToken;
        final FacebookAccessToken fbToken = accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken.token);
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User fbUser = authResult.user;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Success(
              detailsUser: fbUser,
            ),
          ),
        );
      },
      color: HexColor("#3b5998"),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.facebook),
          SizedBox(width: 10),
          Text('Continuar con Facebook',
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      textColor: Colors.white,
    );
  }
}
