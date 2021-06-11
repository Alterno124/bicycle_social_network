import 'package:bicycle_social_network/views/View_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyMainPage(),
  ));
}

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogged = false;

  User myUser;

  Future<User> _loginWithTwitter() async {
    var twitterLogin = TwitterLogin(
      consumerKey: 'BoeaWhbx7S7VAfFOzmAUp9Ppf',
      consumerSecret: 'DzadA2N9K5eM5B9YROXWrv5VtR6gH8miU6naUllHCRtINOMV7w',
    );

    TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        AuthCredential credential = TwitterAuthProvider.credential(
            accessToken: session.token, secret: session.secret);
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User twUser = authResult.user;
        return twUser;
        break;
      case TwitterLoginStatus.cancelledByUser:
        debugPrint(result.status.toString());
        return null;
        break;
      case TwitterLoginStatus.error:
        debugPrint(result.errorMessage.toString());
        return null;
        break;
    }
    return null;
  }

  void _logOut() async {
    await _auth.signOut().then((response) {
      isLogged = false;
      setState(() {});
    });
  }

  void _logInTwitter() {
    _loginWithTwitter().then((response) {
      if (response != null) {
        myUser = response;
        isLogged = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogged ? Home(detailsUser: myUser) : Scaffold(
      appBar: AppBar(
        title: Text(isLogged ? "Profile Page" : "Facebook Loing Example"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30.0),
            FloatingActionButton(
              backgroundColor: Color(0xff00aced),
              child: Icon(FontAwesomeIcons.twitter),
              onPressed: _logInTwitter,
            ),
          ],
        ),
      ),
    );
  }
}
