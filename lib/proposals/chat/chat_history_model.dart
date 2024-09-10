// To parse this JSON data, do
//
//     final chatHistoryModel = chatHistoryModelFromJson(jsonString);

import 'dart:convert';

List<ChatHistoryModel> chatHistoryModelFromJson(String str) => List<ChatHistoryModel>.from(json.decode(str).map((x) => ChatHistoryModel.fromJson(x)));

String chatHistoryModelToJson(List<ChatHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatHistoryModel {
  int? id;
  String? title;
  String? comment;
  String? commentHtml;
  String? bullBear;
  dynamic category;
  Sender? sender;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatHistoryModel({
    this.id,
    this.title,
    this.comment,
    this.commentHtml,
    this.bullBear,
    this.category,
    this.sender,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) => ChatHistoryModel(
    id: json["id"],
    title: json["title"],
    comment: json["comment"],
    commentHtml: json["comment_html"],
    bullBear: json["bull_bear"],
    category: json["category"],
    sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "comment": comment,
    "comment_html": commentHtml,
    "bull_bear": bullBear,
    "category": category,
    "sender": sender?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Sender {
  int? id;
  String? name;

  Sender({
    this.id,
    this.name,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
    id: json["id"],
    name: json["name"]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}