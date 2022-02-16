import 'package:cidade_singular/app/screens/home/home_page.dart';
import 'package:cidade_singular/app/services/city_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  CityStore cityStore = Modular.get();
  CityService cityService = Modular.get();

  bool loading = true;
  @override
  void initState() {
    cityService.getCities().then((cities) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Escolha uma cidade para continuar"),
            content: SingleChildScrollView(
              child: Column(
                children: cities
                    .map(
                      (city) => ListTile(
                        onTap: () {
                          cityStore.setCity.call([city]);
                          Modular.to.popAndPushNamed(HomePage.routeName);
                        },
                        leading: SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.network(
                              city.pictures.isNotEmpty
                                  ? city.pictures.first
                                  : "https://via.placeholder.com/150",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(city.title),
                        subtitle: Text(city.subtitle),
                      ),
                    )
                    .toList(),
              ),
            )),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
