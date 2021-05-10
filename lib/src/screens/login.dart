import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_weather_app/src/screens/home.dart';
import 'package:i_weather_app/src/screens/startup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;

  var _controllerEmail = TextEditingController();
  var _controllerPassword = TextEditingController();
  String email, password;
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => StartScreen()));
          },
          icon: Icon(
            Icons.arrow_back,
            size: 25,
            color: Theme.of(context).accentColor,
          ),
        ),
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
              margin: EdgeInsets.fromLTRB(0, 90, 0, 20),
              child: Column(
                children: [
                  SvgPicture.asset('assets/svg/logo_name.svg'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
                    child: TextField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Theme.of(context).accentColor),
                      keyboardType: TextInputType.emailAddress,
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Theme.of(context).accentColor),
                          suffixIcon: IconButton(
                            onPressed: () => _controllerEmail.clear(),
                            icon: Icon(Icons.clear,
                                color: _controllerEmail.text.isNotEmpty
                                    ? Theme.of(context).accentColor
                                    : Colors.transparent),
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).accentColor)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).accentColor),
                          )),
                      onChanged: (value) {
                        setState(() {
                          email = value.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: TextField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Theme.of(context).accentColor),
                      controller: _controllerPassword,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Theme.of(context).accentColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: _controllerPassword.text.isNotEmpty
                                    ? Theme.of(context).accentColor
                                    : Colors.transparent),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).accentColor)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).accentColor),
                          )),
                      onChanged: (value) {
                        setState(() {
                          password = value.trim();
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                      child: Text(
                        "Sign In!",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'RadikalMedium',
                            fontSize: 17),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).accentColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))),
                      onPressed: () {
                        signIn(email, password);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      //if (!auth.currentUser.emailVerified) throw ('Verify your email please.');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
          msg: error.message, toastLength: Toast.LENGTH_LONG);
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }
}
