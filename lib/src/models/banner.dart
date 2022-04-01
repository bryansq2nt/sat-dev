// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

import 'package:sat/src/providers/api.dart';

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  BannerModel({
   required this.id,
    required this.title,
    required this.body,
    required this.url,
  });

  int id;
  String title;
  String body;
  String url;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    url: ApiProvider().bucket + json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "url": url,
  };
}
