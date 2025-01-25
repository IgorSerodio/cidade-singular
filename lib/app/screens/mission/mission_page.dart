import 'package:cidade_singular/app/models/mission.dart';
import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/services/mission_service.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

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
  List<Progress> pending = [];
  List<Progress> completed = [];

  @override
  void initState() {
    userService.addMissionsToUser(id: userStore.user!.id, cityId: cityStore.city!.id);
    getMissionProgressList();
    super.initState();
  }

  getMissionProgressList({String? curatorType}) async {
    setState(() => loading = true);
    List<Mission> missions = await missionService.getMissionsByCity(cityStore.city!.id);
    if(userStore.user!=null) {
      Map<String, Progress> userProgress = {for (Progress progress in userStore.user!.progress) progress.missionId: progress};
      for (Mission mission in missions){
        if(userProgress.containsKey(mission.id)){
          Progress? progress = userProgress[mission.id];
          Progress progressWithDescription = Progress(missionId: progress!.missionId, value: progress!.value, target: progress!.target, missionDescription: mission.description);
          if(progress!.value == progress!.target){
            completed.add(progressWithDescription);
          }else{
            pending.add(progressWithDescription);
          }
        }
      }
    } else {
      for(Mission mission in missions){
        pending.add(Progress(missionId: mission.id, value: 0, target: mission.target));
      }
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Missões"),
        leading: const BackButton(),
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
                    Progress progress = pending[index];
                    return MissionProgressWidget(
                      progress: progress,
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
                    Progress progress = completed[index];
                    return MissionProgressWidget(
                      progress: progress,
                      completed: true,
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: index == completed.length - 1 ? 20 : 10,
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