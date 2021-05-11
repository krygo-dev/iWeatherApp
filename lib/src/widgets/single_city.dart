import 'package:flutter/material.dart';
import 'package:i_weather_app/src/constants.dart';

class SingleCity extends StatelessWidget {

  final int index;
  SingleCity(this.index);

  final iconUrl = Constants().iconUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 90),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Oświecim',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 40)),
                  ],
                ),
              ),
              Text('Clear sky',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20)),
              Image.network(
                iconUrl + '02d' + '@2x.png',
                width: 100,
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('23 \u2103',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 70)),
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
                      Text('20 \u2103',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('21 \u2103',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('25 \u2103',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('1013 hPa',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('88%',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('3.5 km/h',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ],
              ),
              Divider(
                  color: Theme.of(context).accentColor,
                  thickness: 2,
                  height: 60,
                  indent: 40,
                  endIndent: 40),
            ],
          ),
        ),
      ],
    );
  }
}