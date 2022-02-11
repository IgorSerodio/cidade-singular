import 'package:cidade_singular/app/screens/home/home_page.dart';
import 'package:cidade_singular/app/screens/singularity/singularity_page.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => DioService()),
    Bind((i) => SingularityService(i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (ctx, args) => HomePage()),
    ChildRoute(SingularityPage.routeName,
        child: (ctx, args) => SingularityPage(singularity: args.data)),
  ];
}
