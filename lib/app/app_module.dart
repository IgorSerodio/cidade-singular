import 'package:cidade_singular/app/screens/home/home_page.dart';
import 'package:cidade_singular/app/screens/singularity/singularity_page.dart';
import 'package:cidade_singular/app/screens/spash/splash_page.dart';
import 'package:cidade_singular/app/services/city_service.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => DioService()),
    Bind((i) => SingularityService(i.get())),
    Bind((i) => CityService(i.get())),
    Bind((i) => UserService(i.get())),
    Bind((i) => CityStore())
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (ctx, args) => SplashPage()),
    ChildRoute(HomePage.routeName, child: (ctx, args) => HomePage()),
    ChildRoute(SingularityPage.routeName,
        child: (ctx, args) => SingularityPage(singularity: args.data)),
  ];
}
