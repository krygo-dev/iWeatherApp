import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_weather_app/src/screens/login.dart';
import 'package:i_weather_app/src/screens/search.dart';
import 'package:i_weather_app/src/util/buildin_transform.dart';
import 'package:i_weather_app/src/util/services.dart';
import 'package:i_weather_app/src/widgets/single_city.dart';
import 'package:i_weather_app/src/widgets/single_dot.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PageView variables
  int _currentPage = 0;

  // Firebase reference
  final auth = FirebaseAuth.instance;

  // Search functionality
  bool isSearching = false;
  String _search;
  var _searchController = TextEditingController();

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void initState() {
    if (Services.favouritesCitiesCurrentWeather.isEmpty) Services.getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Delay aby dane zostały pobrane
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      setState(() {});
    });
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

                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              SearchScreen(cityName: _search)));
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
            Services.favouritesCitiesCurrentWeather.isEmpty
                ? Center(child: CircularProgressIndicator())
                : TransformerPageView(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: _onPageChanged,
                    transformer: ScaleAndFadeTransformer(),
                    viewportFraction: 0.8,
                    loop: false,
                    itemCount: Services.favouritesCitiesCurrentWeather.length,
                    itemBuilder: (ctx, i) => SingleCity(i))
          ],
        ),
      ),
    );
  }
}
