import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/services/mission_service.dart';
import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/models/mission.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cidade_singular/app/stores/user_store.dart';

class MissionProgressHandler {

  static void handle (List<String> tags, String userId, String cityId) async {
    UserService userService = Modular.get();
    MissionService missionService = Modular.get();
    UserStore userStore = Modular.get();

    try{
      User? user = await userService.addMissionsToUser(id: userId, cityId: cityId);
      if (user == null){
        throw Exception("Usuário com id $userId não existe");
      }

      List<Mission> missionList = missionFilter(await missionService.getMissionsByCity(cityId), tags);

      Set<String> missionIds = missionList.map((mission) => mission.id).toSet();

      List<Progress> newProgress = [];

      for(Progress missionProgress in user.progress){
        if(missionIds.contains(missionProgress.missionId) && missionProgress.target<missionProgress.value){
          newProgress.add(Progress(missionId: missionProgress.missionId, value: (missionProgress.value+1), target: missionProgress.target));
        }else{
          newProgress.add(missionProgress);
        }
      }

      User? updated = await userService.update(id: userId, progress: newProgress);

      if(updated != null) userStore.setUser(updated);
    } catch (e) {
      print(e);
    }
  }

  static List<Mission> missionFilter(List<Mission> missionList,List<String> tags){
    return missionList.where((mission) {
      return tags.every((tag) => mission.tags.contains(tag));
    }).toList();
  }
}
