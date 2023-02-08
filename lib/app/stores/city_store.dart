import 'package:cidade_singular/app/models/city.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

class CityStore {
  final Observable<City> _city = Observable(City(
    id: "63b966519dd239f46a501cb2",
		title: "Campina Grande",
		blazon: "https://p-cidade-singular.s3.sa-east-1.amazonaws.com/test-imgs/campina-grande-150px.jpg",
		subtitle: "Rainha da Borborema",
		description: "Campina Grande é um município brasileiro no estado da Paraíba. Considerada um dos principais polos industriais da Região Nordeste, foi fundada em 1 de dezembro de 1697. De acordo com estimativas do IBGE de 2020, sua população era de 411 807 habitantes, sendo a segunda cidade mais populosa da Paraíba, e sua região metropolitana, formada por dezenove municípios, possui uma população estimada em 638 017 habitantes.\n\nO município sedia ainda variados eventos culturais, destacando-se os festejos de São João, que acontecem durante todo o mês de junho (chamado de \"O Maior São João do Mundo\"), Festival Internacional de Música (FIMUS), Festival Internacional de Jazz (FIMUS Jazz), encontros religiosos como o Encontro da Nova Consciência (ecumênico), o Encontro para a Consciência Cristã (cristão) e o CRESCER (Encontro da Família Católica[16]) realizados durante o carnaval, além do Festival de Inverno e mais de 20 outros eventos.",
		latLng: LatLng(-7.220696174671216,-35.891240390117936),
		pictures: [
			"https://p-cidade-singular.s3.sa-east-1.amazonaws.com/test-imgs/campina-grande-150px.jpg",
			"https://p-cidade-singular.s3.sa-east-1.amazonaws.com/test-imgs/campina-grande.png"
		]
  ));

  City get city => _city.value;

  late final setCity = Action((City newCity) => _city.value = newCity);
}
