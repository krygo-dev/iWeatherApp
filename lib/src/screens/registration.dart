import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_weather_app/src/screens/startup.dart';
import 'package:i_weather_app/src/screens/verify.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final auth = FirebaseAuth.instance;

  var _controllerEmail = TextEditingController();
  var _controllerPassword = TextEditingController();
  var _controllerPasswordRepeat = TextEditingController();
  String email, password, passwordRepeat;
  bool passwordVisible = false;
  bool passwordRepeatVisible = false;

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
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.black54),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 90, 0, 20),
              child: Column(
                children: [
                  SvgPicture.asset('assets/logo_name.svg'),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
                    child: TextField(
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(color: Colors.white),
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            onPressed: () => _controllerEmail.clear(),
                            icon: Icon(Icons.clear,
                                color: _controllerEmail.text.isNotEmpty
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
                          email = value.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: TextField(
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(color: Colors.white),
                      controller: _controllerPassword,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
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
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          )),
                      onChanged: (value) {
                        setState(() {
                          password = value.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: TextField(
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(color: Colors.white),
                      controller: _controllerPasswordRepeat,
                      obscureText: !passwordRepeatVisible,
                      decoration: InputDecoration(
                        hintText: 'Repeat password',
                        hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                              passwordRepeatVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: _controllerPasswordRepeat.text.isNotEmpty
                                  ? Theme.of(context).accentColor
                                  : Colors.transparent),
                          onPressed: () {
                            setState(() {
                              passwordRepeatVisible = !passwordRepeatVisible;
                            });
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          passwordRepeat = value.trim();
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: ElevatedButton(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'RadikalMedium',
                            fontSize: 17),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor)
                      ),
                      onPressed: () {
                        signUp(email, password, passwordRepeat);
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

  void signUp(String email, String password, String passwordRepeat) async {
    try {
      if (passwordRepeat.isEmpty)
        throw ("Repeat password field can't be empty.");
      else if (passwordRepeat != password)
        throw ("Passwords must be the same.");
      else {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => VerifyScreen()));
      }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
          msg: error.message, toastLength: Toast.LENGTH_LONG);
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }
}
