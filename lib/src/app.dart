import 'package:flutter/material.dart';
import 'package:savemycopy/src/screens/loginScreen.dart';

class SaveMyCopy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save My Copy',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColorBrightness: Brightness.light
      ),
      home: LoginScreen(),
    );
  }
}
