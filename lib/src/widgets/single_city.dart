import 'package:flutter/material.dart';
import 'package:i_weather_app/src/constants.dart';
import 'package:i_weather_app/src/screens/home.dart';
import 'package:i_weather_app/src/services.dart';

class SingleCity extends StatelessWidget {
  final int index;
  SingleCity(this.index);

  final _iconUrl = Constants().iconUrl;
  final cities = Services.favouritesCitiesCurrentWeather;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(cities[index].name,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 40)),
                    IconButton(
                        icon: Icon(Icons.favorite,
                            size: 40, color: Theme.of(context).accentColor),
                        onPressed: () {
                          Services.removeFromFavourites(cities[index].id);
                        })
                  ],
                ),
              ),
              Text(cities[index].weather[0].description,
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 20)),
              Image.network(
                '$_iconUrl${cities[index].weather[0].icon}@2x.png',
                width: 100,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('${cities[index].main.temp.toInt()} \u2103',
                    style: TextStyle(
                        color: Theme.of(context).accentColor, fontSize: 70)),
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
                      Text('${cities[index].main.feelsLike.toInt()} \u2103',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('${cities[index].main.tempMin.toInt()} \u2103',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('${cities[index].main.tempMax.toInt()} \u2103',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('${cities[index].main.pressure} hPa',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('${cities[index].main.humidity}%',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('${cities[index].wind.speed} km/h',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(40, 80, 40, 0),
                width: 250,
                height: 45,
                child: ElevatedButton(
                  child: Text(
                    "Get 7 days forecast!",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'RadikalMedium',
                        fontSize: 17),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).accentColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                  onPressed: () {
                    print("Button clicked!");
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
