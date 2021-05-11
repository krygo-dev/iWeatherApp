import 'package:i_weather_app/src/api_key.dart';
import 'package:i_weather_app/src/constants.dart';
import 'package:i_weather_app/src/models/current_weather.dart';
import 'package:http/http.dart' as http;

class Services {
  static final _apiURL = Constants().apiUrl;
  // ignore: non_constant_identifier_names
  static final _API_KEY = APIKEY().API_KEY;

  static Future<CurrentWeather> getCurrentWeatherByCityID(String cityID) async {
    try {
      final response = await http.get(Uri.parse(
          '${_apiURL}weather?id=$cityID&units=metric&appid=$_API_KEY'));

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
          '${_apiURL}weather?lat=$lat&lon=$lon&units=metric&appid=$_API_KEY'));

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
}
