import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/services/mission_service.dart';
import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/models/mission.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MissionProgressHandler {
  static UserService userService = Modular.get();
  static MissionService missionService = Modular.get();

  static void handle (List<String> tags, String userId, String cityId) async {
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

      userService.update(id: userId, progress: newProgress);
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
