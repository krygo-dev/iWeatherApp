import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:i_weather_app/src/models/current_weather.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:i_weather_app/src/screens/registration.dart';
import 'package:i_weather_app/src/util/constants.dart';
import 'package:i_weather_app/src/util/services.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Position _currentPosition;
  CurrentWeather _currentWeather;
  final String _iconUrl = Constants().iconUrl;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      Services.getCurrentWeatherByCoords(
              _currentPosition.latitude, _currentPosition.longitude)
          .then((value) {
        setState(() {
          _currentWeather = value;
        });
      });
    }).catchError((e) {
      print(e);
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
              'assets/png/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white38),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 70, 0, 20),
              child: _currentWeather == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Column(
                          children: [
                            Text(_currentWeather.name,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 40)),
                            Text(_currentWeather.weather[0].description,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 25)),
                            Image.network(
                              '$_iconUrl${_currentWeather.weather[0].icon}@2x.png',
                              width: 100,
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '${_currentWeather.main.temp.toInt()} \u2103',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 80)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Feel',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('Min',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('Max',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('Pressure',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('Humidity',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('Wind',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        '${_currentWeather.main.feelsLike.toInt()} \u2103',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${_currentWeather.main.tempMin.toInt()} \u2103',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${_currentWeather.main.tempMax.toInt()} \u2103',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('${_currentWeather.main.pressure} hPa',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('${_currentWeather.main.humidity}%',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                    Text('${_currentWeather.wind.speed} km/h',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 145,
                          margin: EdgeInsets.only(top: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(40, 30, 40, 0),
                                width: 150,
                                height: 45,
                                child: ElevatedButton(
                                  child: Text(
                                    "Sign In!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'RadikalMedium',
                                        fontSize: 17),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).accentColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ))),
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
                                width: 150,
                                height: 45,
                                child: ElevatedButton(
                                  child: Text(
                                    "Sign Up!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'RadikalMedium',
                                        fontSize: 17),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Theme.of(context).accentColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ))),
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
