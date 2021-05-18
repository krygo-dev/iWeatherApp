import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:i_weather_app/src/util/api_key.dart';
import 'package:i_weather_app/src/models/current_weather.dart';
import 'package:http/http.dart' as http;
import 'package:i_weather_app/src/models/forecast_weather.dart';
import 'package:i_weather_app/src/util/constants.dart';

class Services {
  static final auth = FirebaseAuth.instance;
  static final realDB = FirebaseDatabase.instance.reference();
  static final _apiURL = Constants().apiUrl;
  // ignore: non_constant_identifier_names
  static final _API_KEY = APIKEY().API_KEY;

  // Current user data from database
  static var _userData;
  static Map _userFavourites;
  static List userFavouritesID;
  static List<CurrentWeather> favouritesCitiesCurrentWeather = [];

  static Future<CurrentWeather> getCurrentWeatherByCityID(String cityID) async {
    try {
      final response = await http.get(Uri.parse(
          '${_apiURL}weather?id=$cityID&units=metric&lang=en&appid=$_API_KEY'));

      if (response.statusCode == 200) {
        final CurrentWeather currentWeather =
            currentWeatherFromJson(response.body);
        return currentWeather;
      } else {
        return CurrentWeather();
      }
    } catch (error) {
      return CurrentWeather();
    }
  }

  static Future<CurrentWeather> getCurrentWeatherByCoords(
      double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse(
          '${_apiURL}weather?lat=$lat&lon=$lon&units=metric&lang=en&appid=$_API_KEY'));

      if (response.statusCode == 200) {
        final CurrentWeather currentWeather =
            currentWeatherFromJson(response.body);
        return currentWeather;
      } else {
        return CurrentWeather();
      }
    } catch (error) {
      return CurrentWeather();
    }
  }

  static Future<CurrentWeather> getCurrentWeatherByCityName(
      String cityName) async {
    try {
      final response = await http.get(Uri.parse(
          '${_apiURL}weather?q=$cityName&units=metric&lang=en&appid=$_API_KEY'));

      if (response.statusCode == 200) {
        final CurrentWeather currentWeather =
            currentWeatherFromJson(response.body);
        return currentWeather;
      } else {
        return CurrentWeather();
      }
    } catch (error) {
      return CurrentWeather();
    }
  }

  static Future<ForecastWeather> getSevenDaysForecastByCoords(
      double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse(
          '${_apiURL}onecall?lat=$lat&lon=$lon&exclude=current,hourly,minutely,alerts&units=metric&lang=en&appid=$_API_KEY'));

      if (response.statusCode == 200) {
        final ForecastWeather forecastWeather = forecastWeatherFromJson(response.body);
        return forecastWeather;
      } else {
        return ForecastWeather();
      }
    } catch (error) {
      return ForecastWeather();
    }
  }

  static void getUserData() async {
    _userData = null;
    _userFavourites = null;
    userFavouritesID = [];
    favouritesCitiesCurrentWeather = [];

    await realDB.child(auth.currentUser.uid).once().then((dataSnapshot) {
      _userData = dataSnapshot.value;
    });

    print(_userData['favourites']);
    _userFavourites = _userData['favourites'];
    userFavouritesID = _userFavourites != null ? _userFavourites.keys.toList() : [];

    userFavouritesID.forEach((id) {
      Services.getCurrentWeatherByCityID(id.toString()).then((value) {
        favouritesCitiesCurrentWeather.add(value);
      });
    });

    print(_userFavourites != null ? _userFavourites.keys.toList() : 'Empty');
  }

  static void addToFavourites(int cityID, String cityName) {
    realDB.child(auth.currentUser.uid).child('favourites').update({
      '$cityID': {'id': cityID, 'name': cityName}
    });
    getUserData();

    Fluttertoast.showToast(
        msg: 'Added to favourites!', toastLength: Toast.LENGTH_SHORT);
  }

  static void removeFromFavourites(int cityID) {
    realDB
        .child(auth.currentUser.uid)
        .child('favourites')
        .child(cityID.toString())
        .remove();
    getUserData();
    Fluttertoast.showToast(
        msg: 'Removed from favourites!', toastLength: Toast.LENGTH_SHORT);
  }
}
