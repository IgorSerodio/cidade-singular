import 'package:cidade_singular/app/models/city.dart';
import 'package:cidade_singular/app/services/city_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChooseCityDialog extends StatefulWidget {
  const ChooseCityDialog({Key? key, required this.onChoose}) : super(key: key);
  final void Function(City) onChoose;

  @override
  _ChooseCityDialogState createState() => _ChooseCityDialogState();
}

class _ChooseCityDialogState extends State<ChooseCityDialog> {
  CityService cityService = Modular.get();
  CityStore cityStore = Modular.get();

  List<City> cities = [];

  bool loading = true;

  @override
  void initState() {
    cityService.getCities().then((newCities) {
      setState(() {
        cities = newCities;
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Escolha uma cidade para continuar"),
      content: loading
          ? SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                children: cities
                    .map(
                      (city) => ListTile(
                        onTap: () {
                          widget.onChoose.call(city);
                          Modular.to.pop();
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
            ),
    );
  }
}
