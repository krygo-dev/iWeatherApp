import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:i_weather_app/src/screens/home.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  final realDB = FirebaseDatabase.instance.reference();
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
      ),
      body: Container(
        child: Stack(children: [
          Image.asset('assets/png/bg.png'),
          Container(
            decoration: BoxDecoration(color: Colors.white38),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 90, 0, 20),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/logo_name.svg',
                  height: 80,
                  width: 283,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 180, 40, 0),
                  child: Center(
                    child: Text(
                      'An email has been sent to ${user.email}, please verify!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      await realDB.child(auth.currentUser.uid).set({
        'uid': auth.currentUser.uid,
        'email': auth.currentUser.email,
        'favourites' : {}
      });
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
