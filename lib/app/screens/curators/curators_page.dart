import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/screens/curators/curator_widget.dart';
import 'package:cidade_singular/app/screens/curators/type_filter.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CuratorsPage extends StatefulWidget {
  const CuratorsPage({Key? key}) : super(key: key);

  @override
  _CuratorsPageState createState() => _CuratorsPageState();
}

class _CuratorsPageState extends State<CuratorsPage> {
  UserService service = Modular.get();

  CityStore cityStore = Modular.get();

  bool loading = false;
  List<User> curators = [];

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  getUsers({String? curatorType}) async {
    setState(() => loading = true);
    curators = await service.getUsers(query: {
      "type": UserType.CURATOR.toString().split(".").last,
      "city": cityStore.city.id,
      if (curatorType != null) "curator_type": curatorType
    });
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Curadores"),
        leading: Container(),
      ),
      body: Column(
        children: [
          TypeFilter(
            onSelect: (type) => getUsers(curatorType: type),
          ),
          SizedBox(height: 20),
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: curators.length,
                    itemBuilder: (context, index) {
                      User user = curators[index];
                      return CuratorWidget(
                        user: user,
                        margin: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: index == curators.length - 1 ? 140 : 10,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
