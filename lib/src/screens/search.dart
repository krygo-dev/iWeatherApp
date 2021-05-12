import 'package:flutter/material.dart';
import 'package:i_weather_app/src/models/current_weather.dart';
import 'package:i_weather_app/src/models/forecast_weather.dart';
import 'package:i_weather_app/src/screens/startup.dart';
import 'package:i_weather_app/src/services.dart';

class SearchScreen extends StatefulWidget {
  final String cityName;
  SearchScreen({Key key, this.cityName}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  CurrentWeather _currentWeather;
  ForecastWeather _forecastWeather;

  @override
  void initState() {
    Services.getCurrentWeatherByCityName(widget.cityName).then((value) {
      _currentWeather = value;
    });
    
    super.initState();
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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => StartScreen()));
          },
          icon: Icon(
            Icons.arrow_back,
            size: 25,
            color: Theme.of(context).accentColor,
          ),
        ),
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
          ],
        ),
      ),
    );
  }
}
