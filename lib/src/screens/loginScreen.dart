import 'package:flutter/material.dart';
import 'package:savemycopy/src/api/backend.dart';
//import 'package:savemycopy/src/widgets/clipboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: firebaseCalls.handleGoogleSignIn,
              child: Text('Gmail'),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Facebook'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: firebaseCalls.handleGoogleLogOut,
        child: Icon(Icons.exit_to_app),
      ),
    );
  }
}
