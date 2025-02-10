import 'package:cidade_singular/app/models/mission.dart';
import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/services/mission_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import '../../models/progress.dart';
import '../../util/colors.dart';
import '../opening/opening_page.dart';
import 'mission_widget.dart';



class MissionPage extends StatefulWidget {

  const MissionPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  UserService userService = Modular.get();
  MissionService missionService = Modular.get();

  UserStore userStore = Modular.get();
  CityStore cityStore = Modular.get();

  bool loading = false;
  List<MapEntry<Progress, Mission>> pending = [];
  List<MapEntry<Progress, Mission>> completed = [];

  @override
  void initState() {
    if(userStore.user != null) {
      getMissionProgressList();
    }
    super.initState();
  }

  getMissionProgressList() async {
    setState(() => loading = true);
    await userService.addMissionsToUser(id: userStore.user!.id, cityId: cityStore.city!.id);
    List<Mission> missions = await missionService.getMissionsByCity(cityStore.city!.id);
    Map<String, Progress> userProgress = {for (Progress progress in userStore.user!.progress) progress.missionId: progress};
    for (Mission mission in missions){
      if(userProgress.containsKey(mission.id)){
        Progress? progress = userProgress[mission.id];
        if(progress!.value == progress!.target){
          completed.add(MapEntry(progress, mission));
        }else{
          pending.add(MapEntry(progress, mission));
        }
      }
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return userStore.user == null
        ? Scaffold(
            appBar: AppBar(
              leading: Container(),
              actions: [
                InkWell(
                  onTap: () => Modular.to.popAndPushNamed(OpeningPage.routeName),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Login"),
                      SizedBox(width: 5),
                      Icon(Icons.login),
                    ],
                  ),
                )
              ],
            ),
            body:Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Faça login para ter acesso a todas as funcionalidades!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
        )
        :Scaffold(
          appBar: AppBar(
            title: const Text("Missões"),
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Missões em andamento",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pending.length,
                      itemBuilder: (context, index) {
                        MapEntry<Progress, Mission> missionProgress = pending[index];
                        return MissionProgressWidget(
                          missionProgress: missionProgress,
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: index == pending.length - 1 ? 20 : 10,
                          ),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Missões Concluídas",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: completed.length,
                      itemBuilder: (context, index) {
                        MapEntry<Progress, Mission> missionProgress = completed[index];
                        return MissionProgressWidget(
                          missionProgress: missionProgress,
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: index == completed.length - 1 ? 20 : 10,
                          ),
                          onTap: () {
                            if (missionProgress.key.target == missionProgress.key.value && !userStore.user!.accessories.contains(missionProgress.value.reward)) {
                              setState(() async {
                                User? updated = await userService.giveReward(id: userStore.user!.id, missionId: missionProgress.key.missionId);
                                if(updated != null) userStore.setUser(updated);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Recompensa coletada: ${missionProgress.value.reward}")),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
        );
  }
}