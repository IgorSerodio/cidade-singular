import 'dart:ui';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class GeolocatorService{
  final Location location = Location();
  LocationData? currentLocation;

  GeolocatorService(){
    getUserLocation();
  }

  getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.requestPermission();
    if (permissionGranted == PermissionStatus.denied) {
      return;
    }
  }

  setOnLocationChange(VoidCallback onLocationChange){
    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      onLocationChange();
    });
  }

  double getDistanceFromUser(double latitude, double longitude){
    double userLat = currentLocation?.latitude ?? 0.0;
    double userLon = currentLocation?.longitude ?? 0.0;
    double distance = Geolocator.distanceBetween(
      userLat,
      userLon,
      latitude,
      longitude,
    );
    return distance;
  }
}