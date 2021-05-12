import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:i_weather_app/src/screens/search.dart';
import 'package:i_weather_app/src/services.dart';
import 'package:i_weather_app/src/widgets/single_city.dart';
import 'package:i_weather_app/src/widgets/single_dot.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PageView variables
  int _currentPage = 0;
  var pageViewController = PageController();

  // Firebase reference
  final auth = FirebaseAuth.instance;
  final realDB = FirebaseDatabase.instance.reference();

  // Search functionality
  bool isSearching = false;
  String _search;
  var _searchController = TextEditingController();

  //var date = DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(1631463245 * 1000));

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void initState() {
    Services.getUserData();
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
                    _search = value.trim();
                  });

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SearchScreen(cityName: _search)));
                },
                onChanged: (value) {
                  setState(() {
                    _search = value.trim();
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
                  for (int i = 0;
                      i < Services.favouritesCitiesCurrentWeather.length;
                      i++)
                    if (i == _currentPage) SingleDot(true) else SingleDot(false)
                ],
              ),
            ),
            PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: _onPageChanged,
                controller: pageViewController,
                itemCount: Services.favouritesCitiesCurrentWeather.length,
                itemBuilder: (ctx, i) => SingleCity(i))
          ],
        ),
      ),
    );
  }
}
