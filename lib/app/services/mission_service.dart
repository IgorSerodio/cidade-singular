import 'package:cidade_singular/app/models/mission.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';

class MissionService {
  final DioService dioService;

  MissionService(this.dioService);

  Future<List<Mission>> getMissionsByCity(String cityId) async {
    try {
      var response = await dioService.dio.get("/mission/city/$cityId");

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

  Future<bool> create(Mission newMission) async {
    try {
      var response = await dioService.dio.post(
        "/mission",
        data: newMission.toMap(),
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future<List<Mission>> getBySponsor(String sponsorId) async {
    try {
      var response = await dioService.dio.get("/mission/sponsor/$sponsorId");

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
        print("Erro ao buscar missões por patrocinador: ${e.message}");
      } else {
        print("Erro inesperado: $e");
      }
      return [];
    }
  }

  Future<bool> update(Mission mission) async {
    try {
      var response = await dioService.dio.put(
        "/mission/${mission.id}",
        data: mission.toMap(),
      );
      return !(response.data["error"] ?? true);
    } catch (e) {
      print("Erro ao atualizar missão: $e");
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      var response = await dioService.dio.delete("/mission/$id");
      return !(response.data["error"] ?? true);
    } catch (e) {
      print("Erro ao deletar missão: $e");
      return false;
    }
  }
}
