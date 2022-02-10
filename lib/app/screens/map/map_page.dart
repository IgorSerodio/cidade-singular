import 'dart:async';

import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  SingularityService service = Modular.get();

  @override
  initState() {
    super.initState();
    getSingularites();
  }

  Set<Marker> markers = {};

  List<Singularity> singularities = [];

  getSingularites() async {
    singularities = await service.getSingularities();
    var icons = await loadBitmapIcons();
    Set<Marker> newMarkers = singularities
        .map(
          (sing) => Marker(
            markerId: MarkerId(sing.id),
            position: sing.latLng,
            icon: icons[sing.type] ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              onTap: () {},
              title: sing.title,
              snippet: sing.address,
            ),
          ),
        )
        .toSet();
    setState(() => markers = newMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        liteModeEnabled: false,
        rotateGesturesEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(-7.23072, -35.8817),
          zoom: 13,
        ),
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
        },
        markers: markers,
      ),
    );
  }

  Future<Map<String, BitmapDescriptor>> loadBitmapIcons() async {
    return {
      "MUSIC": await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/music.png",
      ),
      "ARTS": await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/art.png",
      ),
      "CRAFTS": await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/crafts.png",
      ),
      "FILM": await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/film.png",
      ),
      "GASTRONOMY": await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/gastronomy.png",
      ),
      "LITERATURE": await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/book.png",
      ),
      "DESIGN": await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(200, 200)),
        "assets/images/design.png",
      ),
    };
  }
}
