import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_weather_app/src/api_key.dart';
import 'package:i_weather_app/src/constants.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final realDB = FirebaseDatabase.instance.reference();

  bool isSearching = false, inFav = false;
  var _searchController = TextEditingController();

  String search,
      currentLocation = 'Oświęcim',
      currentLocationID = '854696',
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

  var dbSnapshot;
  Map favouritesCities;

  // ignore: non_constant_identifier_names
  final String API_KEY = APIKEY().API_KEY;
  String apiUrl = Constants().apiUrl;
  String iconUrl = Constants().iconUrl;

  void searchLocation(String locationName) {
    print(locationName);
  }

  void addToFavourites() {
    realDB.child(auth.currentUser.uid).child('favourites').update({
      '$currentLocationID' : {
        'id' : currentLocationID,
        'name' : currentLocation
      }
    });
    readUserFavourites();

    Fluttertoast.showToast(
        msg: 'Added to favourites!', toastLength: Toast.LENGTH_SHORT);

  }

  void removeFromFavourites() {
    realDB.child(auth.currentUser.uid).child('favourites').child(currentLocationID).remove();
    readUserFavourites();
    Fluttertoast.showToast(
        msg: 'Removed from favourites!', toastLength: Toast.LENGTH_SHORT);
  }

  void readUserFavourites() async {
    await realDB.child(auth.currentUser.uid).once().then((dataSnapshot) {
      dbSnapshot = dataSnapshot.value;
    });

    print(dbSnapshot['favourites']);
    favouritesCities = dbSnapshot['favourites'];

    print(favouritesCities != null ? favouritesCities.length : 'Empty');
  }

  @override
  void initState() {
    readUserFavourites();
    super.initState();
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
                cursorColor: Colors.black,
                style: TextStyle(color: Theme.of(context).accentColor),
                decoration: InputDecoration(
                    hintText: 'Search here..',
                    hintStyle: TextStyle(color: Theme.of(context).accentColor),
                    suffixIcon: IconButton(
                      onPressed: () => _searchController.clear(),
                      icon: Icon(Icons.clear,
                          color: _searchController.text.isNotEmpty
                              ? Theme.of(context).accentColor
                              : Colors.transparent),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    )),
                onSubmitted: (value) {
                  setState(() {
                    search = value.trim();
                  });
                  searchLocation(search);
                },
                onChanged: (value) {
                  setState(() {
                    search = value.trim();
                  });
                },
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.search,
              color: Theme.of(context).accentColor, size: 30),
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout,
                  color: Theme.of(context).accentColor, size: 30),
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
            //Container(
            //  decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            //),
            Image.asset(
              'assets/png/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white38),
            ),
            PageView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(currentLocation,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 40)),
                                IconButton(
                                  icon: !inFav
                                      ? Icon(Icons.favorite_border,
                                          size: 40,
                                          color: Theme.of(context).accentColor)
                                      : Icon(Icons.favorite,
                                          size: 40,
                                          color: Theme.of(context).accentColor),
                                  onPressed: () {
                                    setState(() {
                                      if (favouritesCities != null && favouritesCities.length >= 5 && !inFav) Fluttertoast.showToast(
                                          msg: "Favourites cities list is full!", toastLength: Toast.LENGTH_LONG);
                                      else {
                                        inFav = !inFav;
                                        inFav
                                            ? addToFavourites()
                                            : removeFromFavourites();
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                          Text(weatherDesc,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20)),
                          Image.network(
                            iconUrl + weatherIcon + '@2x.png',
                            width: 100,
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('${temperature.toString()} \u2103',
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
                                  Text('${feelTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${minTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${maxTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${pressure.toString()} hPa',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${humidity.toString()}%',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${wind.toString()} km/h',
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
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(currentLocation,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 40)),
                                IconButton(
                                  icon: !inFav
                                      ? Icon(Icons.favorite_border,
                                          size: 40,
                                          color: Theme.of(context).accentColor)
                                      : Icon(Icons.favorite,
                                          size: 40,
                                          color: Theme.of(context).accentColor),
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
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20)),
                          Image.network(
                            iconUrl + weatherIcon + '@2x.png',
                            width: 100,
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('${temperature.toString()} \u2103',
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
                                  Text('${feelTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${minTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${maxTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${pressure.toString()} hPa',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${humidity.toString()}%',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${wind.toString()} km/h',
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
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(currentLocation,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 40)),
                                IconButton(
                                  icon: !inFav
                                      ? Icon(Icons.favorite_border,
                                          size: 40,
                                          color: Theme.of(context).accentColor)
                                      : Icon(Icons.favorite,
                                          size: 40,
                                          color: Theme.of(context).accentColor),
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
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20)),
                          Image.network(
                            iconUrl + weatherIcon + '@2x.png',
                            width: 100,
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('${temperature.toString()} \u2103',
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
                                  Text('${feelTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${minTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${maxTemp.toString()} \u2103',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${pressure.toString()} hPa',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${humidity.toString()}%',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  Text('${wind.toString()} km/h',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
