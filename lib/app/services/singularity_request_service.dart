import 'package:cidade_singular/app/models/criative_economy_type.dart';
import 'package:cidade_singular/app/models/singularity_request.dart';
import 'package:cidade_singular/app/services/dio_service.dart';

class SingularityRequestService {
  final DioService dioService;

  SingularityRequestService(this.dioService);

  Future<bool> create(SingularityRequest request) async {
    try {
      var response = await dioService.dio.post(
        "/singularity-request",
        data: request.toMap(),
      );
      return response.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> update(String id, SingularityRequest request) async {
    try {
      var response = await dioService.dio.put(
        "/singularity-request/$id",
        data: request.toMap(),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<SingularityRequest>> getByType(CriativeEconomyType type) async {
    try {
      var response = await dioService.dio.get(
        "/singularity-request/filter",
        queryParameters: {"type": type.name},
      );

      if (response.data["error"]) return [];

      return (response.data["data"] as List)
          .map((data) => SingularityRequest.fromMap(data))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<SingularityRequest>> getByCreator(String creator) async {
    try {
      var response = await dioService.dio.get(
        "/singularity-request/filter",
        queryParameters: {"creator": creator},
      );

      if (response.data["error"]) return [];

      return (response.data["data"] as List)
          .map((data) => SingularityRequest.fromMap(data))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> delete(String id) async {
    try {
      var response = await dioService.dio.delete(
        "/singularity-request/$id",
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
