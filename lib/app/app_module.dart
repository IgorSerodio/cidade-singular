import 'package:cidade_singular/app/screens/home/home_page.dart';
import 'package:cidade_singular/app/screens/login/login_page.dart';
import 'package:cidade_singular/app/screens/register/register_page.dart';
import 'package:cidade_singular/app/screens/singularity/singularity_page.dart';
import 'package:cidade_singular/app/screens/spash/splash_page.dart';
import 'package:cidade_singular/app/services/city_service.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/services/review_service.dart';

import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:cidade_singular/app/services/auth_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => DioService()),
    Bind((i) => SingularityService(i.get())),
    Bind((i) => CityService(i.get())),
    Bind((i) => UserService(i.get())),
    Bind((i) => ReviewService(i.get())),
    Bind((i) => CityStore()),
    Bind((i) => AuthService(i.get())),
    Bind((i) => UserStore())
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (ctx, args) => SplashPage()),
    ChildRoute(HomePage.routeName, child: (ctx, args) => HomePage()),
    ChildRoute(SingularityPage.routeName,
        child: (ctx, args) => SingularityPage(singularity: args.data)),
    ChildRoute(
      LoginPage.routeName,
      child: (ctx, args) => LoginPage(email: args.data ?? ""),
    ),
    ChildRoute(
      RegisterPage.routeName,
      child: (ctx, args) => RegisterPage(),
    )
  ];
}
