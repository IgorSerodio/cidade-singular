import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';

class SingularityService {
  DioService dioService;

  SingularityService(this.dioService);

  Future<List<Singularity>> getSingularities(
      {Map<String, String> query = const {}}) async {
    try {
      var response = await dioService.dio.get(
        "/singularity",
        queryParameters: query,
      );

      if (response.data["error"]) {
        return [];
      } else {
        List<Singularity> sings = [];
        for (Map data in response.data["data"]) {
          sings.add(Singularity.fromMap(data));
        }
        return sings;
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
