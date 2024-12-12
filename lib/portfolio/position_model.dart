import 'dart:convert';

class PositionModel {
  int? id;
  String? securityType;
  String? destination;
  String? status;
  Security? security;
  String? securityName;
  String? securityIsin;
  String? assetClass;
  dynamic expirationDate;
  bool? featured;
  String? referenceCurrency;
  double? lastPrice;
  double? costPrice;
  String? roi;
  double? quantity;
  double? amount;
  String? allocation;
  double? fxRate;
  int? portfolioId;

  PositionModel({
    this.id,
    this.securityType,
    this.destination,
    this.status,
    this.security,
    this.securityName,
    this.securityIsin,
    this.assetClass,
    this.expirationDate,
    this.featured,
    this.referenceCurrency,
    this.lastPrice,
    this.costPrice,
    this.roi,
    this.quantity,
    this.amount,
    this.allocation,
    this.fxRate,
    this.portfolioId,
  });

  factory PositionModel.fromRawJson(String str) => PositionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PositionModel.fromJson(Map<String, dynamic> json) => PositionModel(
    id: json["id"],
    securityType: json["security_type"],
    destination: json["destination"],
    status: json["status"],
    security: Security.fromJson(json["security"]),
    securityName: json["security_name"],
    securityIsin: json["security_isin"],
    assetClass: json["asset_class"],
    expirationDate: json["expiration_date"],
    featured: json["featured"],
    referenceCurrency: json["reference_currency"],
    lastPrice: double.tryParse(json["last_price"].toString())??0.00,
    costPrice: double.tryParse(json["cost_price"].toString())??0.00,
    roi: json["roi"]?.toString()??'-',
    quantity: double.tryParse(json["quantity"].toString())??0.00,
    amount: double.tryParse(json["amount"].toString())??0.00,
    allocation: json["allocation"].toString(),
    fxRate: double.tryParse(json["fx_rate"])??0.00,
    portfolioId: json["portfolio_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "security_type": securityType,
    "destination": destination,
    "status": status,
    "security": security?.toJson(),
    "security_name": securityName,
    "security_isin": securityIsin,
    "asset_class": assetClass,
    "expiration_date": expirationDate,
    "featured": featured,
    "reference_currency": referenceCurrency,
    "last_price": lastPrice,
    "cost_price": costPrice,
    "roi": roi,
    "quantity": quantity,
    "amount": amount,
    "allocation": allocation,
    "fx_rate": fxRate,
    "portfolio_id": portfolioId,
  };
}

class Security {
  String? type;
  NoItem? noItem;
  Item? item;

  Security({
    this.type,
    this.noItem,
    this.item,
  });

  factory Security.fromRawJson(String str) => Security.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Security.fromJson(Map<String, dynamic> json) => Security(
    type: json["type"],
    noItem: json["no_item"]==null?null:NoItem.fromJson(json["no_item"]),
    item: json["item"]==null?null:Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "no_item": noItem?.toJson(),
    "item": item?.toJson(),
  };
}

class Item {
  int? id;
  String? name;
  String? currency;
  String? assetClassName;
  dynamic industry;
  String? isin;
  String? description;

  Item({
    this.id,
    this.name,
    this.currency,
    this.assetClassName,
    this.industry,
    this.isin,
    this.description,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    currency: json["currency"],
    assetClassName: json["asset_class_name"],
    industry: json["industry"],
    isin: json["isin"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "currency": currency,
    "asset_class_name": assetClassName,
    "industry": industry,
    "isin": isin,
    "description": description,
  };
}

class NoItem {
  int? id;
  String? name;
  String? currency;
  String? assetClassName;
  String? industry;
  String? isin;
  String? description;
  String? assetClass;
  bool? expried;
  dynamic incrementalAmount;
  dynamic incrementalQuantity;
  dynamic minimumAmount;
  dynamic minimumQuantity;
  String? price;
  dynamic liquidityDate;
  String? productRiskClassification;
  Esg? esg;

  NoItem({
    this.id,
    this.name,
    this.currency,
    this.assetClassName,
    this.industry,
    this.isin,
    this.description,
    this.assetClass,
    this.expried,
    this.incrementalAmount,
    this.incrementalQuantity,
    this.minimumAmount,
    this.minimumQuantity,
    this.price,
    this.liquidityDate,
    this.productRiskClassification,
    this.esg,
  });

  factory NoItem.fromRawJson(String str) => NoItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NoItem.fromJson(Map<String, dynamic> json) => NoItem(
    id: json["id"],
    name: json["name"],
    currency: json["currency"],
    assetClassName: json["asset_class_name"],
    industry: json["industry"],
    isin: json["isin"],
    description: json["description"],
    assetClass: json["asset_class"],
    expried: json["expried"],
    incrementalAmount: json["incremental_amount"],
    incrementalQuantity: json["incremental_quantity"],
    minimumAmount: json["minimum_amount"],
    minimumQuantity: json["minimum_quantity"],
    price: json["price"],
    liquidityDate: json["liquidity_date"],
    productRiskClassification: json["product_risk_classification"],
    esg: Esg.fromJson(json["esg"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "currency": currency,
    "asset_class_name": assetClassName,
    "industry": industry,
    "isin": isin,
    "description": description,
    "asset_class": assetClass,
    "expried": expried,
    "incremental_amount": incrementalAmount,
    "incremental_quantity": incrementalQuantity,
    "minimum_amount": minimumAmount,
    "minimum_quantity": minimumQuantity,
    "price": price,
    "liquidity_date": liquidityDate,
    "product_risk_classification": productRiskClassification,
    "esg": esg?.toJson(),
  };
}

class Esg {
  dynamic eEsg;
  dynamic gEsg;
  dynamic sEsg;
  dynamic esgScore;
  dynamic esgRating;

  Esg({
    this.eEsg,
    this.gEsg,
    this.sEsg,
    this.esgScore,
    this.esgRating,
  });

  factory Esg.fromRawJson(String str) => Esg.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Esg.fromJson(Map<String, dynamic> json) => Esg(
    eEsg: json["e_esg"],
    gEsg: json["g_esg"],
    sEsg: json["s_esg"],
    esgScore: json["esg_score"],
    esgRating: json["esg_rating"],
  );

  Map<String, dynamic> toJson() => {
    "e_esg": eEsg,
    "g_esg": gEsg,
    "s_esg": sEsg,
    "esg_score": esgScore,
    "esg_rating": esgRating,
  };
}
