import 'package:cidade_singular/app/screens/city/city_page.dart';
import 'package:cidade_singular/app/screens/home/menu_page_model.dart';
import 'package:cidade_singular/app/screens/home/menu_widget.dart';
import 'package:flutter/material.dart';

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
        page: Scaffold(
          backgroundColor: Colors.amberAccent,
        ),
      ),
      MenuPageModel(
        name: "Favoritos",
        svgIconPath: "assets/images/favorite.svg",
        page: Scaffold(
          backgroundColor: Colors.blueAccent,
        ),
      ),
      MenuPageModel(
        name: "Info",
        svgIconPath: "assets/images/info.svg",
        page: Scaffold(
          backgroundColor: Colors.blueAccent,
        ),
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
              controller: pageController,
              children: pages.map((p) => p.page).toList(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 70,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(4, 4),
                      blurRadius: 5,
                      color: Colors.black26,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: menuItens,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
