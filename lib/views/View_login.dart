import 'package:bicycle_social_network/api_login/facebook_sign_in_button.dart';
import 'package:bicycle_social_network/api_login/twitter_sign_in_button.dart';
import 'package:bicycle_social_network/utilities/authentication.dart';
import 'package:bicycle_social_network/api_login/google_sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class View_login extends StatelessWidget {
  final Color primaryColor = HexColor("00B1EB");
  final Color secondaryColor = Colors.white;

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: primaryColor,
        body: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(
                    height: 150.0,
                    width: 150.0,
                    image: AssetImage('Images/logo_1.png')),
                Text(
                  '¡Bienvenido!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Bienvenido a Seku accede con alguna de tus cuentas para estar al tanto de tus amigos ciclistas y nuevas funcionalidades.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                //_buildTextField(nameController, Icons.account_circle, 'Username'),
                //SizedBox(height: 20),
                //_buildTextField(passwordController, Icons.lock, 'Password'),
                //SizedBox(height: 30),
                /*MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () {},
                  color: logoGreen,
                  child: Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),*/
                Text(
                  '¿Cómo quieres continuar?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle:
                        TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return GoogleSignInButton();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return FacebookSignInButton();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return TwitterSignInButton();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    );
                  },
                ),
                SizedBox(height: 100),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/tgd_white.png',
          height: 40,
        ),
        /*Text('Seku 2021',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),*/
      ],
    );
  }

  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.blue[900])),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.blue[900]),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.blue[900]),
            icon: Icon(
              icon,
              color: Colors.blue[900],
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }
}
