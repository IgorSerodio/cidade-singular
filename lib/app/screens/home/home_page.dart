import 'package:cidade_singular/app/screens/city/city_page.dart';
import 'package:cidade_singular/app/screens/curators/curators_page.dart';
import 'package:cidade_singular/app/screens/home/menu_page_model.dart';
import 'package:cidade_singular/app/screens/home/menu_widget.dart';
import 'package:cidade_singular/app/screens/map/map_page.dart';
import 'package:flutter/material.dart';

import 'package:cidade_singular/app/screens/profile/profile_page.dart';
import 'package:cidade_singular/app/screens/mission/mission_page.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  static String routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    pageController.addListener(() {
      int next = pageController.page?.round() ?? 0;
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<MenuPageModel> pages = [
      MenuPageModel(
        name: "Cidade",
        svgIconPath: "assets/images/city.svg",
        page: CityPage(),
      ),
      MenuPageModel(
        name: "Mapa",
        svgIconPath: "assets/images/places.svg",
        page: MapPage(),
      ),
      MenuPageModel(
        name: "Info",
        svgIconPath: "assets/images/info.svg",
        page: CuratorsPage(),
      ),
      MenuPageModel(
        name: "Missões",
        svgIconPath: "assets/images/mission.svg",
        page: MissionPage(),
      ),
      MenuPageModel(
        name: "Perfil",
        svgIconPath: "assets/images/icon-person.svg",
        page: ProfilePage(),
      ),
    ];

    List<Widget> menuItens = [];
    for (int i = 0; i < pages.length; i++) {
      MenuPageModel page = pages[i];
      menuItens.add(MenuWidget(
        selected: currentPage == i,
        title: page.name,
        icon: page.icon,
        svgIconPath: page.svgIconPath,
        onPressed: () => pageController.jumpToPage(i),
      ));
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: pages.map((p) => p.page).toList(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Row(
                  children: [
                    Image(
                        image: AssetImage("assets/images/board_edge.png"),
                        height: 70,
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/board_mid_sec.png"),
                              fit: BoxFit.fill,
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: menuItens,
                        ),
                      )
                    ),
                    Transform.flip(
                      flipX: true,
                      child: Image(
                        image: AssetImage("assets/images/board_edge.png"),
                        height: 70
                      )
                    )
                  ]
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
