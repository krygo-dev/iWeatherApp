import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_weather_app/src/screens/home.dart';
import 'package:i_weather_app/src/screens/startup.dart';

class App extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final Map<int, Color> primaryColor =
  {
    50:Color.fromRGBO(42, 82, 97, .1),
    100:Color.fromRGBO(42, 82, 97, .2),
    200:Color.fromRGBO(42, 82, 97, .3),
    300:Color.fromRGBO(42, 82, 97, .4),
    400:Color.fromRGBO(42, 82, 97, .5),
    500:Color.fromRGBO(42, 82, 97, .6),
    600:Color.fromRGBO(42, 82, 97,.7),
    700:Color.fromRGBO(42, 82, 97, .8),
    800:Color.fromRGBO(42, 82, 97, .9),
    900:Color.fromRGBO(42, 82, 97, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iWeather',
      theme: ThemeData(
          accentColor: Color.fromARGB(255, 248, 208, 108),
          primarySwatch: MaterialColor(0xFF2A5261, primaryColor)
      ),
      home: auth.currentUser != null ? HomeScreen() : StartScreen(),
    );
  }
}
