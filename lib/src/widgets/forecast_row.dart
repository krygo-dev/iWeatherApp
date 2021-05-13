import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_weather_app/src/util/constants.dart';

class ForecastRow extends StatelessWidget {

  final String date;
  final String icon;
  final double temp;
  ForecastRow(this.date, this.icon, this.temp);

  final _iconUrl = Constants().iconUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        children: [
          Text(date,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                  Theme.of(context).accentColor)),
          Image.network(
              '$_iconUrl$icon@2x.png',
              width: 60,
              height: 60),
          Text('${temp.toInt()} \u2103',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor))
        ],
      ),
    );
  }

}