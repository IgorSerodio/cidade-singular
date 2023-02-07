import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/screens/home/home_page.dart';
import 'package:cidade_singular/app/screens/login/login_page.dart';
import 'package:cidade_singular/app/screens/login/recovery_dialog.dart';
import 'package:cidade_singular/app/screens/register/register_page.dart';
import 'package:cidade_singular/app/services/auth_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../services/city_service.dart';
import '../../stores/city_store.dart';
import '../city/choose_city_dialog.dart';

class OpeningPage extends StatefulWidget {
  String email;
  OpeningPage({Key? key, this.email = ""}) : super(key: key);

  static String routeName = "/login";

  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                )
              ],
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Bem vindo ao \nCidade Singular",
                  style: TextStyle(
                    fontSize: 34,
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                Text(
                  "seu app de divulgação de atividades, bens e serviços culturais!",
                  style: TextStyle(
                    fontSize: 26,
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "Faça login para usufruir ao máximo da experiencia gamificada, por meio dela é possível empreender na Economia Criativa de sua cidade! Ganhe moedas virtuais (Crias) ao avaliar uma singularidade ou  compartilhar em suas redes sociais.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Align(
                  child: InkWell(
                    onTap: () =>
                        Modular.to.popAndPushNamed(LoginPage.routeName),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Constants.primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white38,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Login/Cadastrar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )),
                  ),
                  // ),
                ),
                Align(
                  child: InkWell(
                    onTap: () =>
                        Modular.to.popAndPushNamed(HomePage.routeName),
                    child: Column(
                      children: [
                        Text(
                          "Entrar sem login",
                          style: TextStyle(
                            fontSize: 14,
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
