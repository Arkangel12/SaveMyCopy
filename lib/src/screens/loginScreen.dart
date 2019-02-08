import 'package:flutter/material.dart';
import 'package:savemycopy/src/api/backend.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:savemycopy/src/screens/clipboardScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile>(
        stream: firebaseCalls.userProfileStream,
        builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
          userProfile = snapshot.data;
          return Material(
            child: userProfile != null
                ? ClipboardScreen(userProfile: userProfile)
                : _login(),
          );
        });
  }

  Container _login() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/smcLogo.png'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
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
                  onTap: () async {
                    userProfile = await firebaseCalls.handleGoogleSignIn();
                  },
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
                  onTap: () async {
                    userProfile = await firebaseCalls.handleFacebookSignIn();
                  },
                ),
              ],
            ),
          )
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
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 2))
            ]),
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[icon],
        ),
      ),
    );
  }
}
