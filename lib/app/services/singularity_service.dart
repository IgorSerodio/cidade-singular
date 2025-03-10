import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/criative_economy_type.dart';

class SingularityService {
  DioService dioService;

  SingularityService(this.dioService);

  Future<bool> create({
    required String title,
    required String visitingHours,
    required String address,
    required city,
    required CriativeEconomyType type,
    required String description,
    required String creator,
    required LatLng location,
    List<String> photos = const [],
    List<String> tags = const [],
  }) async {
    try {
      var response = await dioService.dio.post(
        "/singularity",
        data: {
          "title": title,
          "visitingHours": visitingHours,
          "address": address,
          "city": city,
          "type": type.name,
          "description": description,
          "creator": creator,
          "latitude": location.latitude,
          "longitude": location.longitude,
          "photos": photos,
          "tags": tags,
        },
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

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

  Future<List<Singularity>> getByCreator(String creatorId) async {
    try {
      var response = await dioService.dio.get("/singularity/$creatorId");

      if (response.data["error"] == true) {
        return [];
      }

      return (response.data["data"] as List)
          .map((data) => Singularity.fromMap(data))
          .toList();
    } catch (e) {
      if (e is DioError) {
        print("Erro ao buscar singularidades do criador: ${e.response?.data ?? e.message}");
      } else {
        print("Erro desconhecido: $e");
      }
      return [];
    }
  }
}
