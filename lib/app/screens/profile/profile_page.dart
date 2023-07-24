import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/screens/opening/opening_page.dart';

import 'package:cidade_singular/app/services/auth_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

import 'package:percent_indicator/percent_indicator.dart';

enum AccessoryType {
  head,
  torso,
  legs
}

class _AccessorySelector {
  final int HEAD = 0;
  final int TORSO = 1;
  final int LEGS = 2;

  List<String> headItems = [];
  List<String> torsoItems = [];
  List<String> legsItems = [];

  int headIdx = 0;
  int torsoIdx = 0;
  int legsIdx = 0;

  final headAccessories = <String> {'cangaceiro_hat'};
  final torsoAccessories = <String> {'green_dress', 'plaid_shirt'};
  final legsAccessories = <String> {};

  _AccessorySelector(List<String> items, List<String> equipped) {
    for(String item in items){
      if(headAccessories.contains(item)){
        headItems.add(item);
      } else if(torsoAccessories.contains(item)){
        torsoItems.add(item);
      } else if(legsAccessories.contains(item)){
        legsItems.add(item);
      }
    }
    headItems.add("none");
    torsoItems.add("none");
    legsItems.add("none");

    if(equipped.isNotEmpty) {
      headIdx = headItems.indexOf(equipped[User.HEAD]!);
      torsoIdx = torsoItems.indexOf(equipped[User.TORSO]!);
      legsIdx = legsItems.indexOf(equipped[User.LEGS]!);
    }
  }

  void _changeIdx(AccessoryType type, int value){
    switch(type){
      case AccessoryType.head: {
        headIdx = (headIdx + value)%headItems.length;
      }
      break;
      case AccessoryType.torso: {
        torsoIdx = (torsoIdx + value)%torsoItems.length;
      }
      break;
      case AccessoryType.legs: {
        legsIdx = (legsIdx + value)%legsItems.length;
      }
      break;
    }
  }

  void next(AccessoryType type){
    _changeIdx(type, 1);
  }

  void previous(AccessoryType type){
    _changeIdx(type, -1);
  }

  Widget getCurrentItem(AccessoryType type, double height, double width){
    String item;
    switch(type){
      case AccessoryType.head: {
        item = headItems.elementAt(headIdx);
      }
      break;
      case AccessoryType.torso: {
        item = torsoItems.elementAt(torsoIdx);
      }
      break;
      case AccessoryType.legs: {
        item = legsItems.elementAt(legsIdx);
      }
      break;
    }

    if(item=="none") return SizedBox.shrink();

    return SizedBox(
      height: height,
      width: width,
      child: Image.asset("assets/images/accessories/$item.png", fit: BoxFit.cover),
    );
  }

  List<String> getEquipped() {
    return [headItems.elementAt(headIdx), torsoItems.elementAt(torsoIdx), legsItems.elementAt(legsIdx)];
  }
}

/*
* _AccessorySelector(List<String> items) {
    for(String item in items){
      if(headAccessories.contains(item)){
        headItems.add(item);
      } else if(torsoAccessories.contains(item)){
        torsoItems.add(item);
      } else if(legsAccessories.contains(item)){
        legsItems.add(item);
      }
    }
    headItems.add("none");
    headIdx = headItems.indexOf(userStore.user!.equipped["head"]!);
    torsoItems.add("none");
    torsoIdx = headItems.indexOf(userStore.user!.equipped["torso"]!);
    legsItems.add("none");
    legsIdx = legsItems.indexOf(userStore.user!.equipped["legs"]!);
  }

  void _changeIdx(AccessoryType type, int value){
    switch(type){
      case AccessoryType.head: {
        headIdx = (headIdx + value)%headItems.length;
      }
      break;
      case AccessoryType.torso: {
        torsoIdx = (torsoIdx + value)%torsoItems.length;
      }
      break;
      case AccessoryType.legs: {
        legsIdx = (legsIdx + value)%legsItems.length;
      }
      break;
    }
  }

  void next(AccessoryType type){
    _changeIdx(type, 1);
  }

  void previous(AccessoryType type){
    _changeIdx(type, -1);
  }

  Widget getCurrentItem(AccessoryType type, double height, double width){
    String item;
    switch(type){
      case AccessoryType.head: {
        item = headItems.elementAt(headIdx);
      }
      break;
      case AccessoryType.torso: {
        item = torsoItems.elementAt(torsoIdx);
      }
      break;
      case AccessoryType.legs: {
        item = legsItems.elementAt(legsIdx);
      }
      break;
    }

    if(item=="none") return SizedBox.shrink();

    return SizedBox(
      height: height,
      width: width,
      child: Image.asset("assets/images/accessories/$item.png", fit: BoxFit.cover),
    );
  }

  void save() async {
    User? updated = await userService.update(id: userStore.user?.id ?? "", equipped: {"head": headItems.elementAt(headIdx),
                                                                                      "torso": torsoItems.elementAt(torsoIdx),
                                                                                      "legs": legsItems.elementAt(legsIdx)});
    if (updated != null) {
      userStore.setUser(updated);
    }
  }
}
* */

class ProfilePage extends StatefulWidget {
  _AccessorySelector? accessorySelector;

  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  AuthService authService = Modular.get();

  UserService userService = Modular.get();

  UserStore userStore = Modular.get();

  TextEditingController userTypeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  bool editingDescription = false;
  bool editingName = false;

  bool loadingPhoto = false;
  bool loadingName = false;
  bool loadingDescription = false;

  final double avatarHeight = 300.0;

  logout() async {
    await authService.logout();
    Modular.to.popAndPushNamed(OpeningPage.routeName);
  }

  final ImagePicker picker = ImagePicker();

  void pickImage() async {
    setState(() => loadingPhoto = true);
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      User? updated =
          await userService.update(id: userStore.user?.id ?? "", photo: image);
      if (updated != null) {
        userStore.setUser(updated);
      }
    }
    setState(() => loadingPhoto = false);
  }

  void updateUserDescription() async {
    setState(() => loadingDescription = true);
    User? updated = await userService.update(
        id: userStore.user?.id ?? "", description: descriptionController.text);
    if (updated != null) {
      userStore.setUser(updated);
    }
    setState(() => editingDescription = false);
    setState(() => loadingDescription = false);
  }

  void updateUserName() async {
    setState(() => loadingName = true);
    User? updated = await userService.update(
        id: userStore.user?.id ?? "", name: userNameController.text);
    if (updated != null) {
      userStore.setUser(updated);
    }
    setState(() => editingName = false);
    setState(() => loadingName = false);
  }

  void updateEquipped() async {
    User? updated = await userService.update(
        id: userStore.user?.id ?? "", equipped: widget.accessorySelector!.getEquipped());
    if (updated != null) {
      userStore.setUser(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          InkWell(
            onTap: logout,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(userStore.user == null ? "Login": "Sair"),
                SizedBox(width: 5),
                Icon(userStore.user == null ? Icons.login : Icons.logout_outlined),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Observer(builder: (context) {
          User? user = userStore.user;
          List<String> accessories = ['cangaceiro_hat', 'green_dress', 'plaid_shirt'];
          widget.accessorySelector ??= _AccessorySelector(accessories, (user!=null)? user.equipped: []);
          return user == null
              ? Align(
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: double.infinity),
                    Center(
                      child: loadingPhoto
                          ? CircularProgressIndicator()
                          : Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  foregroundImage: NetworkImage(user.picture),
                                  onForegroundImageError: (_, __) {},
                                  child: Text(
                                    user.name[0],
                                    style: TextStyle(fontSize: 38),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: pickImage,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Constants.primaryColor,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 20),
                    getWidgetNivel(user.xp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        editingName
                            ? Expanded(
                                child: buildField(
                                    title: 'Nome',
                                    controller: userNameController
                                      ..text = user.name,
                                    readOnly: false),
                              )
                            : Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Constants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        if (editingName)
                          loadingName
                              ? CircularProgressIndicator()
                              : IconButton(
                                  onPressed: updateUserName,
                                  icon: Icon(Icons.task_alt),
                                  color: Colors.green,
                                ),
                        if (!loadingName)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                editingName = !editingName;
                              });
                            },
                            icon: Icon(editingName ? Icons.close : Icons.edit),
                            color: editingName
                                ? Colors.red
                                : Constants.primaryColor,
                          )
                      ],
                    ),
                    SizedBox(height: 30),
                    buildField(
                        controller: TextEditingController(text: user.email),
                        title: "Email"),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: buildField(
                              title: "Descrição",
                              readOnly: !editingDescription,
                              controller: descriptionController
                                ..text = user.description),
                        ),
                        if (editingDescription)
                          loadingDescription
                              ? CircularProgressIndicator()
                              : IconButton(
                                  onPressed: updateUserDescription,
                                  icon: Icon(Icons.task_alt),
                                  color: Colors.green,
                                ),
                        if (!loadingDescription)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                editingDescription = !editingDescription;
                              });
                            },
                            icon: Icon(
                                editingDescription ? Icons.close : Icons.edit),
                            color: editingDescription
                                ? Colors.red
                                : Constants.primaryColor,
                          )
                      ],
                    ),
                    SizedBox(height: 20),
                    buildField(
                        title: "Usuário",
                        controller: userTypeController
                          ..text = user.type.value +
                              ((user.type == UserType.CURATOR &&
                                      user.curatorType != null)
                                  ? " de ${user.curatorType?.value ?? ""}"
                                  : "")),
                    SizedBox(height: 20),
                    Center(
                      child: Text("Avatar"),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: avatarHeight,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        widget.accessorySelector!.previous(AccessoryType.head);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_back_ios)
                                ),
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        widget.accessorySelector!.previous(AccessoryType.torso);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_back_ios)
                                ),
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        widget.accessorySelector!.previous(AccessoryType.legs);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_back_ios)
                                )
                              ],
                            ),
                            Stack(
                              children: [
                                SizedBox(
                                    height: avatarHeight,
                                    width: avatarHeight*2.0/3.0,
                                    child: Image.asset("assets/images/avatar.png"),
                                ),
                                widget.accessorySelector!.getCurrentItem(AccessoryType.legs, avatarHeight, avatarHeight*2.0/3.0),
                                widget.accessorySelector!.getCurrentItem(AccessoryType.torso, avatarHeight, avatarHeight*2.0/3.0),
                                widget.accessorySelector!.getCurrentItem(AccessoryType.head, avatarHeight, avatarHeight*2.0/3.0),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        widget.accessorySelector!.next(AccessoryType.head);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)
                                ),
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        widget.accessorySelector!.next(AccessoryType.torso);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)
                                ),
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        widget.accessorySelector!.next(AccessoryType.legs);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios)
                                )
                              ],
                            ),
                          ],
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          updateEquipped();
                        },
                        child: Text("Salvar"),
                      ),
                    ),
                    SizedBox(height: 90)
                  ],
                );
        }),
      ),
    );
  }

  Widget buildField(
      {required String title,
      required TextEditingController controller,
      bool readOnly = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Constants.primaryColor,
          ),
        ),
        SizedBox(height: 2),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          textAlign: TextAlign.justify,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  readOnly ? BorderSide.none : BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.all(10),
            hintText: "",
            counterText: "",
            helperMaxLines: 0,
            filled: true,
            fillColor: Constants.grey,
          ),
        ),
      ],
    );
  }

  int calculaXpDoNivel(int value) {
    if (value < 1000) return value;

    var strValue = value.toString();
    var len = strValue.length;

    var xp = strValue.substring(len - 3);
    return int.parse(xp);
  }

  Widget getWidgetNivel(int crias) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          getUserTitle(crias),
          style: TextStyle(
            fontSize: 16,
            color: Constants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        LinearPercentIndicator(
          lineHeight: 20.0,
          percent: crias / getRange(crias),
          progressColor: Constants.primaryColor,
          backgroundColor: Constants.grey,
          curve: Curves.linear,
        ),
        Text(
          "$crias/${getRange(crias)}",
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w800,
              color: Constants.primaryColor),
        ),
      ],
    );
  }

  String getUserTitle(int crias) {
    if (crias >= 5000) return 'Vice-Curador';
    if (crias >= 1001) return 'Visitante Criativo';
    if (crias >= 101) return 'Visitante Singular';
    return 'Visitante Descobridor';
  }

  int getRange(int crias) {
    if (crias >= 5000) return crias;
    if (crias >= 1001) return 5000;
    if (crias >= 101) return 1001;
    return 101;
  }
}
