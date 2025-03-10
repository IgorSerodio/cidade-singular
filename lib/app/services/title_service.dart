import 'package:dio/dio.dart';
import 'package:cidade_singular/app/models/title.dart';
import 'package:cidade_singular/app/services/dio_service.dart';

class TitleService {
  final DioService dioService;

  TitleService(this.dioService);

  Future<bool> create(Title title) async {
    try {
      var response = await dioService.dio.post(
        "/title",
        data: title.toMap(),
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> update(Title title) async {
    try {
      var response = await dioService.dio.put(
        "/title/${title.id}",
        data: title.toMap(),
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future<List<Title>> getByCreator(String creatorId) async {
    try {
      var response = await dioService.dio.get(
        "/title/$creatorId",
      );

      if (response.data["error"] ?? true) {
        return [];
      }

      return (response.data["data"] as List)
          .map((title) => Title.fromMap(title))
          .toList();
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return [];
    }
  }

  Future<bool> delete(String id) async {
    try {
      var response = await dioService.dio.delete(
        "/title/$id",
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }
}
