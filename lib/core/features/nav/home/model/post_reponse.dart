// To parse this JSON data, do
//
//     final productReponseModel = productReponseModelFromJson(jsonString);

import 'dart:convert';

List<PostReponseModel> productReponseModelFromJson(String str) => List<PostReponseModel>.from(json.decode(str).map((x) => PostReponseModel.fromJson(x)));

String productReponseModelToJson(List<PostReponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostReponseModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  PostReponseModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory PostReponseModel.fromJson(Map<String, dynamic> json) => PostReponseModel(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
