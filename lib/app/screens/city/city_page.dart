import 'package:cidade_singular/app/models/city.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';

class CityPage extends StatefulWidget {
  const CityPage({Key? key}) : super(key: key);

  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  City city = City(
      id: "1",
      name: "Campina Grande",
      subtitle: "A rainha da Borburema",
      description:
          "Considerada um dos principais polos industriais da Região Nordeste bem como um dos maiores polos tecnológicos da América Latina. O município sedia variados eventos culturais, destacando-se os festejos de São João, que acontecem durante todo o mês de junho (chamado de “O Maior São João do Mundo“), o Encontro da Nova Consciência, um encontro ecumênico realizado durante o carnaval, além do Festival de Inverno e outros 20 eventos.",
      picture:
          "https://campinagrande.pb.gov.br/wp-content/uploads/2021/11/IMG-20211111-WA0017.jpg");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city.name,
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                city.subtitle,
                style: TextStyle(
                  color: Constants.primaryColor.withOpacity(.8),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(city.picture, fit: BoxFit.cover),
              ),
              SizedBox(height: 20),
              Text(
                city.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black54,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
