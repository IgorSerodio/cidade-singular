import 'package:cidade_singular/app/models/city.dart';
import 'package:cidade_singular/app/models/progress.dart';
import 'package:cidade_singular/app/models/owned_ticket.dart';
import 'package:cidade_singular/app/models/singularity.dart';

import 'criative_economy_type.dart';

class User {
  static const HEAD = 0;
  static const TORSO = 1;
  static const LEGS = 2;

  String id;
  String email;
  String name;
  String description;
  UserType type;
  CriativeEconomyType? curatorType;
  String picture;
  City? city;
  List<String> accessories;
  List<String> equipped;
  List<String> titles;
  List<OwnedTicket> tickets;
  List<Progress> progress;
  int xp;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.city,
    this.description = "",
    this.type = UserType.VISITOR,
    this.curatorType,
    this.picture = "",
    required this.accessories,
    required this.equipped,
    required this.titles,
    required this.tickets,
    required this.progress,
    required this.xp,
  });

  User.fromMap(Map map)
      : id = map["_id"],
        email = map["email"],
        name = map["name"],
        description = map["description"] ?? "",
        type = UserType._from[map["type"]],
        curatorType = map["curator_type"] != null ? CriativeEconomyType.from[map["curator_type"]] : null,
        picture = map["picture"] ?? "",
        accessories = List<String>.from(map["accessories"] ?? []),
        equipped = List<String>.from(map["equipped"] ?? ["none", "none", "none"]),
        titles = List<String>.from(map["titles"] ?? []),
        tickets = List<OwnedTicket>.from(map["tickets"]?.map((item) => OwnedTicket.fromMap(item)) ?? []),
        progress = List<Progress>.from(map["progress"]?.map((item) => Progress.fromMap(item)) ?? []),
        xp = map["xp"] ?? 0;
}

enum UserType {
  _from,
  ADMIN,
  MANAGER,
  CURATOR,
  ENTREPRENEUR,
  VISITOR,
}

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.ADMIN:
        return "Administrador";
      case UserType.MANAGER:
        return "Ponto focal";
      case UserType.CURATOR:
        return "Curador";
      case UserType.ENTREPRENEUR:
        return "Empreendedor";
      case UserType.VISITOR:
        return "Visitante";
      default:
        return "Não definido";
    }
  }

  operator [](String key) => (name) {
    switch (name) {
      case 'ADMIN':
        return UserType.ADMIN;
      case 'MANAGER':
        return UserType.MANAGER;
      case 'CURATOR':
        return UserType.CURATOR;
      case 'ENTREPRENEUR':
        return UserType.ENTREPRENEUR;
      case 'VISITOR':
        return UserType.VISITOR;
      default:
        return null;
    }
  }(key);
}


