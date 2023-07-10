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
        id: "2",
        address: "R. Dr. Severino Cruz, 771 - Centro, Campina Grande - PB, 58045-010",
        description: "Fast-food, coquetéis e cerveja servida em um restaurante tranquilo com mesas ao ar livre e vista para o lago.",
        title: "Bar do Cuscuz",
        type: "GASTRONOMY",
        visitingHours: "11:00 às 01:00 de segunda à sábado e 11:00 às 22:00 domingo",
        photos: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOCwtRtvmVxbZDv00SCDRS7C66brae4hp8O_W7h94wXQ&s",
                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2iHVnZ5jgPX-x99UCdaJkLvW8DnBhR-wiW0MWubLSKg&s",
                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWX1zI9o7q79cwpe7w3xeTiSKghBY9VIIzkM7oSy4G8A&s",
                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJyDjN-Wqa-zcu8DtPbVXccKeFcpO72Ri8G1YgareITw&s"],
        latLng: LatLng(-7.222849272936453, -35.87790826032338)));
    sings.add(Singularity(
        id: "3",
        address: "R. Dr. Severino Cruz, s/n - Centro, Campina Grande - PB, 58400-258",
        description: "O Museu de Arte Popular da Paraíba, também conhecido como Museu dos Três Pandeiros, está localizado às margens do Açude Velho na cidade brasileira de Campina Grande, estado da Paraíba. Projetado pelo arquiteto Oscar Niemeyer, sendo sua última obra, o museu faz parte da Universidade Estadual da Paraíba.",
        title: "Museu de Arte Popular da Paraíba",
        type: "ARTS",
        visitingHours: "10:00 às 19:00 de terça à sexta e 14:00 às 19:00 nos finais de semana",
        photos: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSBIcpACozAreO4ym02jTDxdJFaV6eyGOcCaVDi4-PcA&s",
                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY9ZOou0rIbUD4xQIwuYWxBEG6hRmCucY8LKQyzs1vjQ&s",
                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROIA8goidUSZ6-YAONgWWi_9qIbK8pKmcC-iE7ewE6qg&s"],
        latLng: LatLng(-7.223787864851387, -35.87892025701705)));
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
