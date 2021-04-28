import 'package:flutter/material.dart';
import 'package:i_weather_app/src/screens/startup.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iWeather',
      theme: ThemeData(
        accentColor: Colors.amber,
        primarySwatch: Colors.blue
      ),
      home: StartScreen(),
    );
  }

}