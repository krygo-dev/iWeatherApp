import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_weather_app/src/api_key.dart';
import 'package:i_weather_app/src/constants.dart';
import 'package:i_weather_app/src/models/current_weather.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:i_weather_app/src/services.dart';
import 'package:i_weather_app/src/widgets/single_city.dart';
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
      currentLocationID = '3089658',
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
  List favCitiesIDs;
  CurrentWeather curr;

  List<CurrentWeather> favCitiesWeather = [];

  // ignore: non_constant_identifier_names
  final String API_KEY = APIKEY().API_KEY;
  String apiUrl = Constants().apiUrl;
  String iconUrl = Constants().iconUrl;

  void searchLocation(String locationName) {
    print(locationName);
  }

  void addToFavourites() {
    realDB.child(auth.currentUser.uid).child('favourites').update({
      '$currentLocationID': {'id': currentLocationID, 'name': currentLocation}
    });
    readUserFavourites();

    Fluttertoast.showToast(
        msg: 'Added to favourites!', toastLength: Toast.LENGTH_SHORT);
  }

  void removeFromFavourites() {
    realDB
        .child(auth.currentUser.uid)
        .child('favourites')
        .child(currentLocationID)
        .remove();
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
    favCitiesIDs = favouritesCities.keys.toList();

    favCitiesIDs.forEach((id) {
      Services.getCurrentWeatherByCityID(id.toString()).then((value) {
        setState(() {
          favCitiesWeather.add(value);
        });
      });
    });

    print(favouritesCities != null ? favouritesCities.keys.toList() : 'Empty');
  }

  @override
  void initState() {
    readUserFavourites();
    Services.getCurrentWeatherByCityID('3089658').then((value) {
      setState(() {
        curr = value;
      });
    });
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
            Container(
              margin: EdgeInsets.only(top: 90, left: 20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    child: Text(curr != null ? curr.name : 'Null'),
                  )
                ],
              ),
            ),
            PageView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, i) => SingleCity(i)
            )
          ],
        ),
      ),
    );
  }
}
