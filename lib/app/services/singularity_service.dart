import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingularityService {
  DioService dioService;

  SingularityService(this.dioService);

  /*Future<List<Singularity>> getSingularities(
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
  }*/
  Future<List<Singularity>> getSingularities(
      {Map<String, String> query = const {}}) async {
    List<Singularity> sings = [];
    sings.add(Singularity(
        id: "1",
        address: "",
        description: "",
        title: "Cinema Manoel",
        type: "FILM",
        visitingHours: "",
        photos: [],
        latLng: LatLng(-7.237516, -35.873240)));
    sings.add(Singularity(
        id: "2",
        address: "",
        description: "",
        title: "Bar da Macaxeira",
        type: "GASTRONOMY",
        visitingHours: "",
        photos: [],
        latLng: LatLng(-7.238155, -35.878379)));
    sings.add(Singularity(
        id: "3",
        address: "",
        description: "",
        title: "Maseu da Pedra",
        type: "ARTS",
        visitingHours: "",
        photos: [],
        latLng: LatLng(-7.229543, -35.883473)));
    if (query.containsKey("type")){
      List<Singularity> temp = [];
      for(Singularity sing in sings){
        if(query["type"]==sing.type){
          temp.add(sing);
        }
      }
      sings = temp;
    }
    return sings;
  }
}
