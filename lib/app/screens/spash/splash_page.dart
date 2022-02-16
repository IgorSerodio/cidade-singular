import 'package:cidade_singular/app/screens/city/choose_city_dialog.dart';
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
    cityService.getCity().then((city) {
      if (city != null) {
        cityStore.setCity.call([city]);
        Modular.to.popAndPushNamed(HomePage.routeName);
      } else {
        showDialog(
          context: context,
          builder: (context) => ChooseCityDialog(
            onChoose: (city) {
              cityService.saveCity(city.id);
              cityStore.setCity.call([city]);
              Modular.to.popAndPushNamed(HomePage.routeName);
            },
          ),
        );
      }
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
