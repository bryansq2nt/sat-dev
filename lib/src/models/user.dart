// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
   required this.userId,
    this.name,
    this.userName = "",
    this.position,
    this.email,
     this.gender,
     this.phone,
    required this.roles,
    required this.modules,
  });

  int userId;
  String? name = "";
  String userName;
  String? position;
  String? email;
  String? gender;
  String? phone;
  List<Role> roles;
  List<Module> modules;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: int.parse(json["user_id"]),
    name: json["name"],
    userName: json["user_name"],
    position: json["position"],
    email: json["email"],
    gender: json["gender"],
    phone: json["phone"],
    roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
    modules: List<Module>.from(json["modules"].map((x) => Module.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "user_name": userName,
    "position": position,
    "email": email,
    "gender": gender,
    "phone": phone,
    "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
    "modules": List<dynamic>.from(modules.map((x) => x.toJson())),
  };
}

class Module {
  Module({
   required this.moduleId,
    required this.name,
  });

  int moduleId;
  String name;

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    moduleId: json["module_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "module_id": moduleId,
    "name": name,
  };
}

class Role {
  Role({
    required this.roleId,
    required  this.name,
  });

  int roleId;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    roleId: json["role_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "role_id": roleId,
    "name": name,
  };
}
