// To parse this JSON data, do
//
//     final involved = involvedFromJson(jsonString);

import 'dart:convert';

Involved involvedFromJson(String str) => Involved.fromJson(json.decode(str));

String involvedToJson(Involved data) => json.encode(data.toJson());

class Involved {
  Involved({
   required this.involvedId,
   required this.name,
   required this.related,
  });

  int involvedId;
  String name;
  int related;

  factory Involved.fromJson(Map<String, dynamic> json) => Involved(
    involvedId: json["involved_id"],
    name: json["name"],
    related: json["related"],
  );

  Map<String, dynamic> toJson() => {
    "involved_id": involvedId,
    "name": name,
    "related": related,
  };
}
