import 'dart:async';

import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/screens/map/filter_type_widget.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:cidade_singular/app/screens/singularity/singularity_page.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  createState() => _MapPageState();
}

class _AvatarMarker extends StatelessWidget{

  _AvatarMarker(this.globalKey);
  final GlobalKey globalKey;
  final UserStore userStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    double avatarHeight = 180.0;
    return RepaintBoundary(
      key: globalKey,
      child: SizedBox(
        height: avatarHeight,
        width: avatarHeight*2/3,
        child: Stack(
          children: [
            Image.asset("assets/images/avatar.png", fit: BoxFit.cover,),
            if (userStore.user != null && userStore.user!.equipped[User.LEGS] != "none") Image.asset("assets/images/accessories/${userStore.user!.equipped[User.LEGS]}.png", fit: BoxFit.cover,),
            if (userStore.user != null && userStore.user!.equipped[User.TORSO] != "none") Image.asset("assets/images/accessories/${userStore.user!.equipped[User.TORSO]}.png", fit: BoxFit.cover,),
            if (userStore.user != null && userStore.user!.equipped[User.HEAD] != "none") Image.asset("assets/images/accessories/${userStore.user!.equipped[User.HEAD]}.png", fit: BoxFit.cover,),
          ],
        ),
      )
    );
  }
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  SingularityService service = Modular.get();
  CityStore cityStore = Modular.get();
  bool loading = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final GlobalKey globalKey = GlobalKey();

  @override
  initState() {
    super.initState();
    getSingularites();
    Timer.periodic(const Duration(seconds: 1), (Timer _) => updateAvatar());
  }

  Set<Marker> markers = {};

  List<Singularity> singularities = [];

  getSingularites({CuratorType? type}) async {
    setState(() => loading = true);
    singularities = await service.getSingularities(query: {
      "city": cityStore.city.id,
      if (type != null) "type": type.toString().split(".").last,
    });
    var icons = await loadBitmapIcons();
    Set<Marker> newMarkers = singularities.map((sing) {
      MarkerId markerId = MarkerId(sing.id);
      return Marker(
        markerId: markerId,
        position: sing.latLng,
        icon: icons[sing.type] ?? BitmapDescriptor.defaultMarker,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingularityPage(singularity: sing)),),
      );
    }).toSet();
    if(avatar!=null) newMarkers.add(avatar!);
    setState(() {
      markers = newMarkers;
      loading = false;
    });
  }

  void addCustomIcon() async {
    BitmapDescriptor temp = await MarkerIcon.widgetToIcon(globalKey);
    if(temp!=null) markerIcon = temp;
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  changeMapMode() {
      getJsonFile("assets/images/mapMode.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _AvatarMarker(globalKey),
          GoogleMap(
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              liteModeEnabled: false,
              rotateGesturesEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: cityStore.city.latLng,
                zoom: 13,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                changeMapMode();
                setState(() {});
              },
              markers: markers,
          ),
          if (loading)
            Container(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(
                  color: Constants.primaryColor,
                ),
              ),
            ),
          Positioned.fill(
            top: 0,
            bottom: 86,
            child: FilterTypeWidget(
              onChoose: (type) {
                getSingularites(type: type);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget selectTypeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: CuratorType.values
          .map(
            (type) => GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Constants.getColor(type.toString().split(".").last),
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type.value),
                    SvgPicture.asset(
                        "assets/images/${type.toString().split(".").last}.svg",
                        width: 20)
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<Map<String, BitmapDescriptor>> loadBitmapIcons() async {
    return {
      "MUSIC": BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/music.png", 50)
      ),
      "ARTS":  BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/art.png", 50)
      ),
      "CRAFTS":  BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/crafts.png", 50)
      ),
      "FILM":  BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/film.png", 50)
      ),
      "GASTRONOMY":  BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/gastronomy.png", 50)
      ),
      "LITERATURE":  BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/book.png", 50)
      ),
      "DESIGN":  BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/design.png", 50)
      ),
    };
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Marker? avatar;

  void updateAvatar() {
    getUserCurrentLocation().then((value) async {
      if(markerIcon == BitmapDescriptor.defaultMarker) addCustomIcon();
      setState(() {
        avatar = Marker(
            markerId: const MarkerId("main"),
            position: LatLng(value.latitude, value.longitude),
            draggable: false,
            icon: markerIcon
        );
        markers.remove(avatar);
        markers.add(avatar!);
      });
    });
  }
}
