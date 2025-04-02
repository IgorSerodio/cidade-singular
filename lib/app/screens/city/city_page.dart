import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/screens/city/choose_city_dialog.dart';
import 'package:cidade_singular/app/services/city_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:cidade_singular/app/util/URLImage.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CityPage extends StatefulWidget {
  const CityPage({Key? key}) : super(key: key);

  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  CityStore cityStore = Modular.get();
  CityService cityService = Modular.get();
  UserStore userStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cidade:",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Constants.textColor2,
                  ),
                ),
                SizedBox(height: 2),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ChooseCityDialog(
                        onChoose: (city) {
                          cityStore.setCity.call([city]);
                          cityService.saveCity(city.id);
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(500),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1, 2),
                            blurRadius: 4,
                            color: Colors.black26,
                          )
                        ]),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cityStore.city.title,
                          style: TextStyle(),
                        ),
                        SizedBox(width: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox.square(dimension: 20.0, child: URLImage(cityStore.city.blazon),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  isCurator()
                      ?"Bem vindo, curador de ${cityStore.city.title}"
                      :cityStore.city.title,
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(!isCurator())...[
                  Text(
                    cityStore.city.subtitle,
                    style: TextStyle(
                      color: Constants.primaryColor.withOpacity(.8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return SizedBox(
                          width: constraints.maxWidth/2,
                          height: constraints.maxWidth/2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: URLImage(cityStore.city.pictures.first),
                          ),
                        );
                      }
                  ),
                ],
                SizedBox(height: 20),
                Text(
                  isCurator()
                      ? "Caro Curador.\n"
                      "Você tem duas funções no Cidade Singular:\n"
                      "a) avaliador da maturidade de empreendimentos de Economia Criativa e Capacitador de empreendimento para aumentar essa maturidade.Como Avaliador você usa um conjunto de critérios de maturidade comprovados pelo empreendedor para avaliar o cadastro do empreendimento ou obra, com base na 1) visita in loco do curador ao empreendimento, 2) com base na sua consulta dos comentários e sugestões dos visitantes, e 3) com base na verificação das comprovações fornecidas pelo empreendedor. Em seguida você registra na régua medidora de maturidade o nível de maturidade do empreendimento e, se este nível for maior que 1, você autoriza a publicação do cadastro do empreendedor no app Cidade Singular.\n"
                      "b) Como Capacitador você pode oferecer cursos, consultoria, mentoria e assessorias ao empreendimentos para que eles aumentem sua maturidade. Você pode preparar, cadastrar e oferecer seus serviços de capacitador no seu perfil de capacitador que será disponibilizado em breve para todos os empreendedores no app Cidade Singular."
                      :cityStore.city.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isCurator(){
    return userStore.user!=null
        && userStore.user!.type == UserType.CURATOR
        && userStore.user!.city != null
        && userStore.user!.city!.id == cityStore.city.id;
  }
}
