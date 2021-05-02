import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:i_weather_app/src/api_key.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:i_weather_app/src/screens/registration.dart';
import 'package:http/http.dart' as http;

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String currentLocation, weatherIcon, weatherDesc;
  int temperature, feelTemp, minTemp, maxTemp, pressure, humidity, wind;

  Position _currentPosition;
  // ignore: non_constant_identifier_names
  final String API_KEY = Constants().API_KEY;
  String apiUrl = 'https://api.openweathermap.org/data/2.5';
  String iconUrl = 'https://openweathermap.org/img/wn/';

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      getWeatherInCurrentLocation();
    }).catchError((e) {
      print(e);
    });
  }

  getWeatherInCurrentLocation() async {
    var apiCall = apiUrl +
        '/weather?lat=' +
        _currentPosition.latitude.toString() +
        '&lon=' +
        _currentPosition.longitude.toString() +
        '&units=metric&appid=' +
        API_KEY;
    var locationResult = await http.get(Uri.parse(apiCall));
    var result = json.decode(locationResult.body);
    print(result);

    var weather = result['weather'][0];
    var main = result['main'];

    setState(() {
      currentLocation = result['name'];
      wind = (result['wind']['speed'] * 3.6).round();
      weatherIcon = weather['icon'];
      weatherDesc = weather['main'];
      temperature = main['temp'].round();
      feelTemp = main['feels_like'].round();
      minTemp = main['temp_min'].round();
      maxTemp = main['temp_max'].round();
      pressure = main['pressure'].round();
      humidity = main['humidity'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                child: temperature == null
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Column(
                            children: [
                              Text(currentLocation,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 40)),
                              Text(weatherDesc,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              Image.network(
                                iconUrl + weatherIcon + '@2x.png',
                                width: 100,
                                height: 100,
                              ),
                              Text('${temperature.toString()} \u2103',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 70)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Feel',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('Min',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('Max',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('Pressure',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('Humidity',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('Wind',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25))
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('${feelTemp.toString()} \u2103',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('${minTemp.toString()} \u2103',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('${maxTemp.toString()} \u2103',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('${pressure.toString()} hPa',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('${humidity.toString()}%',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25)),
                                      Text('${wind.toString()} km/h',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25))
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 145,
                            margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(40, 30, 40, 15),
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  child: ElevatedButton(
                                    child: Text(
                                      "Sign In!",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'RadikalMedium',
                                          fontSize: 17),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).accentColor)),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 40),
                                  width: MediaQuery.of(context).size.width,
                                  height: 45,
                                  child: ElevatedButton(
                                    child: Text(
                                      "Sign Up!",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'RadikalMedium',
                                          fontSize: 17),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).accentColor)),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrationScreen()));
                                    },
                                  ),
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
