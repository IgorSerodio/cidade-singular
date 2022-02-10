import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(-7.23072, -35.8817),
          zoom: 13,
        ),
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(200, 200)),
            "assets/images/music.png",
          );
          setState(() {
            markers = {
              Marker(
                markerId: MarkerId('lab'),
                icon: icon,
                position: LatLng(-7.235174, -35.901573),
                infoWindow: InfoWindow(
                  onTap: () {
                    print("Tapped");
                  },
                  title: "laboratorio de música 2",
                  snippet:
                      "Rua Damasco, 658 - Santa Rosa, Campina Grande - PB, Brasil",
                ),
              ),
            };
          });
        },
        markers: markers,
      ),
    );
  }
}
