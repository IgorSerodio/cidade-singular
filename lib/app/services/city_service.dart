import 'package:cidade_singular/app/models/city.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityService {
  DioService dioService;

  CityService(this.dioService);

  Future<List<City>> getCities() async {
    try {
      var response = await dioService.dio.get("/city");

      if (response.data["error"]) {
        return [];
      } else {
        List<City> cities = [];
        for (Map data in response.data["data"]) {
          cities.add(City.fromMap(data));
        }
        return cities;
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
      } else {
        print(e);
      }
      return [];
    }
  }

  Future<City?> getCity() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cityId = prefs.getString('cityId');

      if (cityId == null) return null;

      var response = await dioService.dio.get("/city/$cityId");

      if (response.data["error"]) {
        return null;
      } else {
        return City.fromMap(response.data["city"]);
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
      } else {
        print(e);
      }
      return null;
    }
  }

  Future<void> saveCity(String cityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cityId", cityId);
  }
}
