import 'package:cidade_singular/app/models/city.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';

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
}
