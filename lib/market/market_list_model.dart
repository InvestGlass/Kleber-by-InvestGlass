import 'dart:convert';

List<MarketListModel> marketListModelFromJson(String str) => List<MarketListModel>.from(json.decode(str).map((x) => MarketListModel.fromJson(x)));

String marketListModelToJson(List<MarketListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarketListModel {
  int? id;
  int? companyId;
  String? industry;
  String? currencyName;
  String? isin;
  String? name;
  String? description;
  String? imageUrl;
  String? videoUrl;
  String? assetClass;
  String? assetClassName;
  bool? expried;
  dynamic country;
  String? price;

  MarketListModel({
    this.id,
    this.companyId,
    this.industry,
    this.currencyName,
    this.isin,
    this.name,
    this.description,
    this.imageUrl,
    this.videoUrl,
    this.assetClass,
    this.assetClassName,
    this.expried,
    this.country,
    this.price,
  });

  factory MarketListModel.fromRawJson(String str) => MarketListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MarketListModel.fromJson(Map<String, dynamic> json) => MarketListModel(
    id: json["id"],
    companyId: json["company_id"],
    industry: json["industry"],
    currencyName: json["currency_name"],
    isin: json["isin"],
    name: json["name"],
    description: json["description"],
    imageUrl: json["image_url"],
    videoUrl: json["video_url"],
    assetClass: json["asset_class"],
    assetClassName: json["asset_class_name"],
    expried: json["expried"],
    country: json["country"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "industry": industry,
    "currency_name": currencyName,
    "isin": isin,
    "name": name,
    "description": description,
    "image_url": imageUrl,
    "video_url": videoUrl,
    "asset_class": assetClass,
    "asset_class_name": assetClassName,
    "expried": expried,
    "country": country,
    "price": price,
  };
}
