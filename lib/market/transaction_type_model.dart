// To parse this JSON data, do
//
//     final transactionTypeModel = transactionTypeModelFromJson(jsonString);

import 'dart:convert';

List<TransactionTypeModel> transactionTypeModelFromJson(String str) => List<TransactionTypeModel>.from(json.decode(str).map((x) => TransactionTypeModel.fromJson(x)));

String transactionTypeModelToJson(List<TransactionTypeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionTypeModel {
  int? id;
  String? name;

  TransactionTypeModel({
    this.id,
    this.name,
  });

  factory TransactionTypeModel.fromJson(Map<String, dynamic> json) => TransactionTypeModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
