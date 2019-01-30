import 'package:flutter/material.dart';

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 300.0,
        width: 300.0,
        child: FlutterLogo(),
      ),
    );
  }
}

void main() {
  runApp(LogoApp());
}

