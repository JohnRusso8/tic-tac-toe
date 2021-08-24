import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'splash.dart';

void main() {
  runApp(new MaterialApp(
      home: new MyApp(),
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primaryColor: Colors.blue)));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text(
        'John Russo' + '\n\n\n\n' + 'Midterm' + '\n\n\n\n' + '3/19/2021',
        textAlign: TextAlign.center,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      backgroundColor: Colors.blue, //ANY COLOR YOU CHOOSE
      styleTextUnderTheLoader: new TextStyle(),
      loaderColor: Colors.amber, //ANY COLOR YOU CHOOSE
      loadingText: new Text('Starting Midterm'),
    );
  }
}
