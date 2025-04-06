import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/user.dart';
import '../../stores/user_store.dart';

class AvatarMarker extends StatelessWidget{

  AvatarMarker(this.globalKey, {Key? key}) : super(key: key);
  final GlobalKey globalKey;
  final UserStore userStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    double avatarHeight = 180.0;
    return RepaintBoundary(
        key: globalKey,
        child: SizedBox(
          height: avatarHeight,
          width: avatarHeight*2/3,
          child: Stack(
            children: [
              Image.asset("assets/images/avatar.png", fit: BoxFit.cover,),
              if (userStore.user != null && userStore.user!.equipped[User.LEGS] != "none") Image.asset("assets/images/accessories/${userStore.user!.equipped[User.LEGS]}.png", fit: BoxFit.cover,),
              if (userStore.user != null && userStore.user!.equipped[User.TORSO] != "none") Image.asset("assets/images/accessories/${userStore.user!.equipped[User.TORSO]}.png", fit: BoxFit.cover,),
              if (userStore.user != null && userStore.user!.equipped[User.HEAD] != "none") Image.asset("assets/images/accessories/${userStore.user!.equipped[User.HEAD]}.png", fit: BoxFit.cover,),
            ],
          ),
        )
    );
  }
}