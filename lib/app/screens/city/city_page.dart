import 'package:cidade_singular/app/screens/city/choose_city_dialog.dart';
import 'package:cidade_singular/app/services/city_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
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
                  cityStore.city.title,
                  style: TextStyle(
                    color: Constants.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

                SizedBox(height: 20),
                Text(
                  cityStore.city.description,
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
}
