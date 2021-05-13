import 'package:flutter/material.dart';
import 'package:i_weather_app/src/models/forecast_weather.dart';
import 'package:i_weather_app/src/screens/home.dart';
import 'package:i_weather_app/src/util/services.dart';
import 'package:i_weather_app/src/widgets/forecast_row.dart';
import 'package:intl/intl.dart';

class ForecastScreen extends StatefulWidget {
  final String cityName;
  final double lat;
  final double lon;
  ForecastScreen({Key key, this.cityName, this.lat, this.lon}) : super(key: key);

  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {

  ForecastWeather _forecastWeather;

  @override
  void initState() {
    Services.getSevenDaysForecastByCoords(widget.lat, widget.lon).then((value) {
      setState(() {
        _forecastWeather = value;
      });
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
                MaterialPageRoute(builder: (context) => HomeScreen()));
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
            _forecastWeather == null
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(widget.cityName,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 40)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          for (int i = 1;
                              i < _forecastWeather.daily.length;
                              i++)
                            ForecastRow(
                                DateFormat.MMMd().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _forecastWeather.daily[i].dt * 1000)),
                                _forecastWeather.daily[i].weather[0].icon,
                                _forecastWeather.daily[i].temp.day)
                        ],
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
