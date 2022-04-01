
import 'dart:convert';

ErrorResponseModel errorResponseModelFromJson(String str) => ErrorResponseModel.fromJson(json.decode(str));

String errorResponseModelToJson(ErrorResponseModel data) => json.encode(data.toJson());

class ErrorResponseModel {
  ErrorResponseModel({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
  });

  String? type;
  String? title;
  int? status;
  String? detail;
  String? instance;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => ErrorResponseModel(
    type: json["type"],
    title: json["title"],
    status: json["status"],
    detail: json["detail"],
    instance: json["instance"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "status": status,
    "detail": detail,
    "instance": instance,
  };
}
