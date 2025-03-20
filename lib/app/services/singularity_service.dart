import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/creative_economy_type.dart';

class SingularityService {
  DioService dioService;

  SingularityService(this.dioService);

  Future<bool> create(Singularity singularity, {bool fromRequest = false}) async {
    try {
      var response = await dioService.dio.post(
        "/singularity",
        queryParameters: {"fromRequest": fromRequest},
        data: singularity.toMap(),
      );

      return !(response.data["error"] ?? true);
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> update(Singularity singularity, {List<String>? newPhotos}) async {
    try {
      Map<String, dynamic> data = singularity.toMap();
      if(newPhotos!=null)data["newPhotos"] = newPhotos;
      var response = await dioService.dio.put(
        "/singularity/${singularity.id}",
        data: data,
      );
      return !response.data["error"];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      var response = await dioService.dio.delete(
        "/singularity/$id",
      );
      return !response.data["error"];
    } catch (e) {
      print(e);
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
}
