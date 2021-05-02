import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_weather_app/src/screens/login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  bool isSearching = false;
  var _searchController = TextEditingController();
  String search;

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
                onChanged: (value) {
                  setState(() {
                    search = value.trim();
                  });
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
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
        ]),
      ),
    );
  }
}
