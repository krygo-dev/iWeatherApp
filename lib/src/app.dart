import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_weather_app/src/screens/home.dart';
import 'package:i_weather_app/src/screens/startup.dart';

class App extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final Map<int, Color> primaryColor =
  {
    50:Color.fromRGBO(248, 208, 108, .1),
    100:Color.fromRGBO(248, 208, 108, .2),
    200:Color.fromRGBO(248, 208, 108, .3),
    300:Color.fromRGBO(248, 208, 108, .4),
    400:Color.fromRGBO(248, 208, 108, .5),
    500:Color.fromRGBO(248, 208, 108, .6),
    600:Color.fromRGBO(248, 208, 108,.7),
    700:Color.fromRGBO(248, 208, 108, .8),
    800:Color.fromRGBO(248, 208, 108, .9),
    900:Color.fromRGBO(248, 208, 108, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iWeather',
      theme: ThemeData(
          accentColor: Color.fromARGB(255, 42, 82, 97),
          primarySwatch: MaterialColor(0xFFf8d06c, primaryColor)
      ),
      home: auth.currentUser != null ? HomeScreen() : StartScreen(),
    );
  }
}
