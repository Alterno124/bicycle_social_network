import 'package:bicycle_social_network/views/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TwitterSignInButton extends StatefulWidget {
  @override
  _TwitterSignInButtonState createState() => _TwitterSignInButtonState();
}

class _TwitterSignInButtonState extends State<TwitterSignInButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      minWidth: double.maxFinite,
      height: 50,
      onPressed: () async {
        FirebaseApp firebaseApp = await Firebase.initializeApp();
        TwitterLogin twitterLogin = new TwitterLogin(
          consumerKey: 'BoeaWhbx7S7VAfFOzmAUp9Ppf',
          consumerSecret: 'DzadA2N9K5eM5B9YROXWrv5VtR6gH8miU6naUllHCRtINOMV7w',
        );
        TwitterLoginResult result = await twitterLogin.authorize();
        var session = result.session;
        AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: session.token, secret: session.secret);
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User twUser = authResult.user;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Success(
              detailsUser: twUser,
            ),
          ),
        );
      },
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.twitter),
          SizedBox(width: 10),
          Text('Continuar con Twitter',
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      textColor: Colors.white,
    );
  }
}
