import 'dart:async';

import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/screens/map/filter_type_widget.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:cidade_singular/app/util/mission_progress_utils.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:cidade_singular/app/screens/singularity/singularity_page.dart';
import 'package:cidade_singular/app/services/user_service.dart';
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

import '../../models/creative_economy_type.dart';
import '../singularity_request/singularity_request_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  createState() => _MapPageState();
}

class _SingularityTitle extends StatelessWidget{

  const _SingularityTitle(this.name, this.globalKey);
  final GlobalKey globalKey;
  final String name;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: globalKey,
        child:Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black87.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
    );
  }
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
  UserService userService = Modular.get();
  CityStore cityStore = Modular.get();
  UserStore userStore = Modular.get();
  bool loading = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  List<Singularity> singularities = [];
  Map<String, GlobalKey> singularityTitleKeys = {};
  Set<Marker> markers = {};
  final GlobalKey globalKey = GlobalKey();

  @override
  initState() {
    super.initState();
    getSingularities();
    loadSingularityMarkers();
    Timer.periodic(const Duration(seconds: 1), (Timer _) {
      if(mounted) updateAvatar();
    });
  }

  getSingularities({CreativeEconomyType? type}) async {
    singularities = await service.getSingularities(query: {
      "city": cityStore.city.id,
      if (type != null) "type": type.name,
    });

    singularityTitleKeys.clear();
    for (final sing in singularities) {
      singularityTitleKeys[sing.id] = GlobalKey();
    }
  }

  loadSingularityMarkers() async {
    setState(() => loading = true);
    var icons = await loadBitmapIcons();
    Set<Marker> newMarkers = {};
    for (Singularity sing in singularities){
      Marker marker = Marker(
        markerId: MarkerId(sing.id),
        position: sing.latLng,
        icon: icons[sing.type.name] ?? BitmapDescriptor.defaultMarker,
        onTap: () {
          handleVisit(sing);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SingularityPage(singularity: sing)),);
        },
      );
      Marker markerTitle = Marker(
        markerId: MarkerId("${sing.id}-t"),
        position: sing.latLng,
        icon: await MarkerIcon.widgetToIcon(singularityTitleKeys[sing.id]!),
      );
      newMarkers.addAll([marker, markerTitle]);
    }
    if(avatar!=null) newMarkers.add(avatar!);
    setState(() {
      markers = newMarkers;
      loading = false;
    });
  }

  void addCustomIcon() async {
    BitmapDescriptor icon = await MarkerIcon.widgetToIcon(globalKey);
    if(icon!=null) markerIcon = icon;
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
          ...singularities.map((sing) {
            return _SingularityTitle(sing.title, singularityTitleKeys[sing.id]!);
          }),
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
                getSingularities(type: type);
                loadSingularityMarkers();
              },
            ),
          ),
          if (userStore.user != null && userStore.user!.type == UserType.VISITOR)
            Positioned(
              top: 16,
              right: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Modular.to.push(
                    MaterialPageRoute(builder: (context) => SingularityRequestPage()));
                },
                child: const Text(
                  "É empreendedor?\n Cadastre sua singularidade!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget selectTypeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: CreativeEconomyType.values
          .map(
            (type) => GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Constants.getColor(type.name),
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type.value),
                    SvgPicture.asset(
                        "assets/images/${type.name}.svg",
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
    getUserCurrentLocation().then((value) {
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

  void handleVisit(Singularity sing) async {
    const minDistance = 50;
    if(userStore.user!=null){
      getUserCurrentLocation().then((userPosition) {
        double distance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          sing.latLng.latitude,
          sing.latLng.longitude,
        );
        if(distance<=minDistance) {
          userService.increaseProgress(
              id: userStore.user!.id,
              cityId: cityStore.city!.id,
              tags: [sing.id, TaskType.VISIT.name, sing.type.name] + sing.tags,
              source: MissionProgressUtils.formatSource(sing.id),
          );
        }
      });
    }
  }
}
