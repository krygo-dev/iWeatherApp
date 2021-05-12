import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_weather_app/src/models/current_weather.dart';
import 'package:i_weather_app/src/models/forecast_weather.dart';
import 'package:i_weather_app/src/screens/home.dart';
import 'package:i_weather_app/src/util/constants.dart';
import 'package:i_weather_app/src/util/services.dart';

class SearchScreen extends StatefulWidget {
  final String cityName;
  SearchScreen({Key key, this.cityName}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _iconUrl = Constants().iconUrl;

  bool inFav = false;

  CurrentWeather _currentWeather;
  ForecastWeather _forecastWeather;

  @override
  void initState() {
    Services.getCurrentWeatherByCityName(widget.cityName).then((value) {
      setState(() {
        _currentWeather = value;
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
            Container(
              margin: EdgeInsets.fromLTRB(0, 70, 0, 20),
              child: _currentWeather == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(_currentWeather.name,
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 40)),
                              IconButton(
                                  icon: inFav || Services.userFavouritesID.contains(_currentWeather.id)
                                      ? Icon(Icons.favorite,
                                          size: 40,
                                          color: Theme.of(context).accentColor)
                                      : Icon(Icons.favorite_border,
                                          size: 40,
                                          color: Theme.of(context).accentColor),
                                  onPressed: () {
                                    setState(() {
                                      if (Services.favouritesCitiesCurrentWeather !=
                                              null &&
                                          Services.favouritesCitiesCurrentWeather
                                                  .length >= 5 && !inFav) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Favourites cities list is full!",
                                            toastLength: Toast.LENGTH_LONG);
                                      } else {
                                        inFav = !inFav;
                                        inFav
                                            ? Services.addToFavourites(
                                                _currentWeather.id,
                                                _currentWeather.name)
                                            : Services.removeFromFavourites(
                                                _currentWeather.id);
                                      }
                                    });
                                  })
                            ],
                          ),
                        ),
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
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('Min',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('Max',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('Pressure',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('Humidity',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('Wind',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
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
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    '${_currentWeather.main.tempMin.toInt()} \u2103',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    '${_currentWeather.main.tempMax.toInt()} \u2103',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('${_currentWeather.main.pressure} hPa',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('${_currentWeather.main.humidity}%',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                                Text('${_currentWeather.wind.speed} km/h',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
