import 'package:flutter/material.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:i_weather_app/src/screens/registration.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String currentLocation = 'Katowice';
  String weatherIcon = 'assets/sunny.png';
  String weatherDesc = 'Clear sky';
  int temperature = 25;
  int feelTemp = 20;
  int minTemp = 17;
  int maxTemp = 28;
  int pressure = 1000;
  int humidity = 100;
  int wind = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 70, 0, 20),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(currentLocation,
                          style: TextStyle(color: Colors.white, fontSize: 40)),
                      Text(weatherDesc,
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      Image.asset(
                        weatherIcon,
                        height: 100,
                        width: 100,
                      ),
                      Text('${temperature.toString()} \u2103',
                          style: TextStyle(color: Colors.white, fontSize: 70)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Feel',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('Min',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('Max',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('Pressure',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('Humidity',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('Wind',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${feelTemp.toString()} \u2103',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('${minTemp.toString()} \u2103',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('${maxTemp.toString()} \u2103',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('${pressure.toString()} hPa',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('${humidity.toString()}%',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25)),
                              Text('${wind.toString()} km/h',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 100,
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Text('Sign in!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                        ),
                        TextButton(
                          child: Text('Sign up!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationScreen()));
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
