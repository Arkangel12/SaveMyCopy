import 'package:flutter/material.dart';
import 'package:savemycopy/src/api/backend.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savemycopy/src/widgets/clipboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var authenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: authenticated ? Clipboard() : _login(),
    );
  }

  Container _login(){
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          customLoginButton(
            width: 80,
            height: 50,
            icon: Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            loginFrom: 'Gmail',
            onTap: firebaseCalls.handleGoogleSignIn,
          ),
          SizedBox(
            height: 20,
          ),
          customLoginButton(
            width: 80,
            height: 50,
            icon: Icon(
              FontAwesomeIcons.facebookF,
              color: Colors.white,
            ),
            backgroundColor: Colors.blueAccent,
            loginFrom: 'Facebook',
            onTap: firebaseCalls.handleFacebookSignIn,
          ),
        ],
      ),
    );
  }

  Widget customLoginButton({
    double width,
    double height,
    Icon icon,
    String loginFrom,
    Color backgroundColor,
    Function onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon
          ],
        ),
      ),
    );
  }

}
