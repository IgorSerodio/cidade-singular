import 'package:cidade_singular/app/models/city.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CityPage extends StatefulWidget {
  const CityPage({Key? key}) : super(key: key);

  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  CityStore cityStore = Modular.get();

  @override
  initState() {
    setState(() {
      city = cityStore.city;
    });

    super.initState();
  }

  late City city;
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
                city.title,
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
                child: Image.network(city.pictures.first, fit: BoxFit.cover),
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
