import 'package:cidade_singular/app/models/city.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

class CityStore {
  final Observable<City> _city = Observable(City(
    id: "1",
    title: "Campina Grande",
    subtitle: "A rainha da Borburema",
    description:
        "Considerada um dos principais polos industriais da Região Nordeste bem como um dos maiores polos tecnológicos da América Latina. O município sedia variados eventos culturais, destacando-se os festejos de São João, que acontecem durante todo o mês de junho (chamado de “O Maior São João do Mundo“), o Encontro da Nova Consciência, um encontro ecumênico realizado durante o carnaval, além do Festival de Inverno e outros 20 eventos.",
    pictures: [
      "https://campinagrande.pb.gov.br/wp-content/uploads/2021/11/IMG-20211111-WA0017.jpg"
    ],
    latLng: LatLng(-7.23072, -35.8817),
    blazon:
        "https://upload.wikimedia.org/wikipedia/commons/c/c5/Brasao_campina-01.png",
  ));

  City get city => _city.value;

  late final setCity = Action((City newCity) => _city.value = newCity);
}
