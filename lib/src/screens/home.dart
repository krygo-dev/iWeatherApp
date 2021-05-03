import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_weather_app/src/api_key.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  bool isSearching = false, inFav = false;
  var _searchController = TextEditingController();

  String search,
      currentLocation = 'Oświęcim',
      weatherIcon = '04d',
      weatherDesc = 'Cloud';

  int temperature = 23,
      feelTemp = 20,
      minTemp = 21,
      maxTemp = 25,
      pressure = 1000,
      humidity = 78,
      wind = 4;

  var date = DateFormat.yMMMd()
      .format(DateTime.fromMillisecondsSinceEpoch(1631463245 * 1000));

  // ignore: non_constant_identifier_names
  final String API_KEY = Constants().API_KEY;
  String apiUrl = 'https://api.openweathermap.org/data/2.5';
  String iconUrl = 'https://openweathermap.org/img/wn/';

  void searchLocation(String locationName) {
    print(locationName);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: !isSearching
            ? Text('')
            : TextField(
                autofocus: true,
                controller: _searchController,
                cursorColor: Theme.of(context).accentColor,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Search here..',
                    hintStyle: TextStyle(color: Colors.white),
                    suffixIcon: IconButton(
                      onPressed: () => _searchController.clear(),
                      icon: Icon(Icons.clear,
                          color: _searchController.text.isNotEmpty
                              ? Theme.of(context).accentColor
                              : Colors.transparent),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )),
                onSubmitted: (value) {
                  setState(() {
                    search = value.trim();
                  });
                  searchLocation(search);
                },
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.white, size: 30),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                auth.signOut().then((value) => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginScreen())));
              })
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            PageView(
              children: [
                ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(currentLocation,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 40)),
                                    IconButton(
                                      icon: !inFav
                                          ? Icon(Icons.favorite_border,
                                              size: 40,
                                              color:
                                                  Theme.of(context).accentColor)
                                          : Icon(Icons.favorite,
                                              size: 40,
                                              color:
                                                  Theme.of(context).accentColor),
                                      onPressed: () {
                                        setState(() {
                                          inFav = !inFav;
                                        });
                                        inFav
                                            ? Fluttertoast.showToast(
                                                msg: 'Added to favourite!',
                                                toastLength: Toast.LENGTH_SHORT)
                                            : Fluttertoast.showToast(
                                                msg: 'Removed from favourite!',
                                                toastLength: Toast.LENGTH_SHORT);
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Text(weatherDesc,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              Image.network(
                                iconUrl + weatherIcon + '@2x.png',
                                width: 100,
                                height: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text('${temperature.toString()} \u2103',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 70)),
                              ),
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
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  thickness: 2,
                                  height: 60,
                                  indent: 40,
                                  endIndent: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20))
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(currentLocation,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 40)),
                                  IconButton(
                                    icon: !inFav
                                        ? Icon(Icons.favorite_border,
                                            size: 40,
                                            color:
                                                Theme.of(context).accentColor)
                                        : Icon(Icons.favorite,
                                            size: 40,
                                            color:
                                                Theme.of(context).accentColor),
                                    onPressed: () {
                                      setState(() {
                                        inFav = !inFav;
                                      });
                                      inFav
                                          ? Fluttertoast.showToast(
                                              msg: 'Added to favourite!',
                                              toastLength: Toast.LENGTH_SHORT)
                                          : Fluttertoast.showToast(
                                              msg: 'Removed from favourite!',
                                              toastLength: Toast.LENGTH_SHORT);
                                    },
                                  )
                                ],
                              ),
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
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  thickness: 2,
                                  height: 60,
                                  indent: 40,
                                  endIndent: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20))
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(currentLocation,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 40)),
                                  IconButton(
                                    icon: !inFav
                                        ? Icon(Icons.favorite_border,
                                            size: 40,
                                            color:
                                                Theme.of(context).accentColor)
                                        : Icon(Icons.favorite,
                                            size: 40,
                                            color:
                                                Theme.of(context).accentColor),
                                    onPressed: () {
                                      setState(() {
                                        inFav = !inFav;
                                      });
                                      inFav
                                          ? Fluttertoast.showToast(
                                              msg: 'Added to favourite!',
                                              toastLength: Toast.LENGTH_SHORT)
                                          : Fluttertoast.showToast(
                                              msg: 'Removed from favourite!',
                                              toastLength: Toast.LENGTH_SHORT);
                                    },
                                  )
                                ],
                              ),
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
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  thickness: 2,
                                  height: 60,
                                  indent: 40,
                                  endIndent: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20))
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              ),
                              Divider(
                                  color: Theme.of(context).accentColor,
                                  indent: 50,
                                  endIndent: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(date,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  Image.network(
                                    iconUrl + weatherIcon + '@2x.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  Text('${temperature.toString()} \u2103',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
