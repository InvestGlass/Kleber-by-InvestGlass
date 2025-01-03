// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

// String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  List<Datum>? data;

  DataModel({
    this.data,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    data: json["data"]==null?[]:List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  /*Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };*/
}

class Datum {
  int? id;
  String? name;

  Datum({
    this.id,
    this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
