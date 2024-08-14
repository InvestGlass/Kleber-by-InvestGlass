// To parse this JSON data, do
//
//     final homeNewsModel = homeNewsModelFromJson(jsonString);

import 'dart:convert';

List<HomeNewsModel> homeNewsModelFromJson(String str) => List<HomeNewsModel>.from(json.decode(str).map((x) => HomeNewsModel.fromJson(x)));

String homeNewsModelToJson(List<HomeNewsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HomeNewsModel {
  String? title;
  DateTime? date;
  String? link;
  String? description;
  String? imageUrl;

  HomeNewsModel({
    this.title,
    this.date,
    this.link,
    this.description,
    this.imageUrl,
  });

  factory HomeNewsModel.fromJson(Map<String, dynamic> json) => HomeNewsModel(
    title: json["title"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    link: json["link"],
    description: json["description"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "date": date?.toIso8601String(),
    "link": link,
    "description": description,
    "image_url": imageUrl,
  };
}
