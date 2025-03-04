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

  String selectedFilter = "all";

  @override
  void initState() {
    if (userStore.user != null) {
      getMissionProgressList();
    }
    super.initState();
  }

  getMissionProgressList() async {
    setState(() => loading = true);
    User? user = await userService.addMissionsToUser(
        id: userStore.user!.id, cityId: cityStore.city!.id);

    if (user != null) userStore.setUser(user);

    List<Mission> missions =
        await missionService.getMissionsByCity(cityStore.city!.id);
    Map<String, Progress> userProgress = {
      for (Progress progress in userStore.user!.progress)
        progress.missionId: progress
    };

    pending.clear();
    completed.clear();

    for (Mission mission in missions) {
      if (userProgress.containsKey(mission.id)) {
        Progress progress = userProgress[mission.id]!;
        if (progress.value == progress.target) {
          completed.add(MapEntry(progress, mission));
        } else {
          pending.add(MapEntry(progress, mission));
        }
      }
    }

    setState(() => loading = false);
  }

  List<MapEntry<Progress, Mission>> filterMissions(
      List<MapEntry<Progress, Mission>> missions) {
    if (selectedFilter == "sponsored") {
      return missions.where((entry) => entry.value.sponsor != null).toList();
    } else if (selectedFilter == "general") {
      return missions.where((entry) => entry.value.sponsor == null).toList();
    }
    return missions;
  }

  @override
  Widget build(BuildContext context) {
    return userStore.user == null
        ? Scaffold(
            appBar: AppBar(
              leading: Container(),
              actions: [
                InkWell(
                  onTap: () =>
                      Modular.to.popAndPushNamed(OpeningPage.routeName),
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
            body: Align(
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
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Missões"),
            ),
            body: loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildFilterButtons(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Missões em andamento",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filterMissions(pending).length,
                          itemBuilder: (context, index) {
                            MapEntry<Progress, Mission> missionProgress =
                                filterMissions(pending)[index];
                            return MissionProgressWidget(
                              missionProgress: missionProgress,
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom:
                                    index == filterMissions(pending).length - 1
                                        ? 20
                                        : 10,
                              ),
                            );
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Missões Concluídas",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filterMissions(completed).length,
                          itemBuilder: (context, index) {
                            MapEntry<Progress, Mission> missionProgress =
                                filterMissions(completed)[index];
                            return MissionProgressWidget(
                              missionProgress: missionProgress,
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: index ==
                                        filterMissions(completed).length - 1
                                    ? 20
                                    : 10,
                              ),
                              onTap: () => giveReward(
                                  missionProgress.key, missionProgress.value),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _filterButton("Todas", "all"),
          _filterButton("Patrocinadas", "sponsored"),
          _filterButton("Gerais", "general"),
        ],
      ),
    );
  }

  Widget _filterButton(String text, String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == filter
            ? Constants.primaryColor
            : Colors.grey[300],
        foregroundColor: selectedFilter == filter ? Colors.white : Colors.black,
      ),
      child: Text(text),
    );
  }

  void giveReward(Progress progress, Mission mission) async {
    User? updated = await userService.giveReward(
        id: userStore.user!.id, missionId: progress.missionId);
    if (updated != null) {
      setState(() {
        userStore.setUser(updated);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recompensa coletada!")),
        );
      });
    }
  }
}
