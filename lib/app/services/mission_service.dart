import 'dart:convert';
import 'package:cidade_singular/app/models/mission.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';

class MissionService {
  final DioService dioService;

  MissionService(this.dioService);

  Future<List<Mission>> getMissionsByCity(String cityId) async {
    try {
      var response = await dioService.dio.get("/missions/city/$cityId");

      if (response.data["error"]) {
        return [];
      } else {
        List<Mission> missions = [];
        for (var data in response.data["data"]) {
          missions.add(Mission.fromMap(data));
        }
        return missions;
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