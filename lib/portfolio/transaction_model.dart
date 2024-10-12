import 'dart:convert';

class TransactionModel {
  int? id;
  double? openPrice;
  String? openRate;
  String? quantity;
  String? amount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? transactionDatetime;
  String? statusView;
  DateTime? accountingDatetime;
  String? transactionStatus;
  String? transactionType;
  String? portfolioName;
  PortfolioSecurity? portfolioSecurity;

  TransactionModel({
    this.id,
    this.openPrice,
    this.openRate,
    this.quantity,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.transactionDatetime,
    this.statusView,
    this.accountingDatetime,
    this.transactionStatus,
    this.transactionType,
    this.portfolioName,
    this.portfolioSecurity,
  });

  factory TransactionModel.fromRawJson(String str) => TransactionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    id: json["id"],
    openPrice: double.tryParse(json["open_price"]?.toString()??'0.0')??0.0,
    openRate: json["open_rate"],
    quantity: json["quantity"],
    amount: json["amount"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    transactionDatetime: json["transaction_datetime"],
    statusView: json["status_view"],
    accountingDatetime: DateTime.parse(json["accounting_datetime"]),
    transactionStatus: json["transaction_status"],
    transactionType: json["transaction_type"],
    portfolioName: json["portfolio_name"],
    portfolioSecurity: PortfolioSecurity.fromJson(json["portfolio_security"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "open_price": openPrice,
    "open_rate": openRate,
    "quantity": quantity,
    "amount": amount,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
    "transaction_datetime": transactionDatetime,
    "status_view": statusView,
    // "accounting_datetime": accountingDatetime.toIso8601String(),
    "transaction_status": transactionStatus,
    "transaction_type": transactionType,
    "portfolio_name": portfolioName,
    "portfolio_security": portfolioSecurity?.toJson(),
  };
}

class PortfolioSecurity {
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
  String? costPrice;
  dynamic roi;
  String? quantity;
  double? amount;
  String? allocation;
  String? fxRate;
  int? portfolioId;

  PortfolioSecurity({
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

  factory PortfolioSecurity.fromRawJson(String str) => PortfolioSecurity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PortfolioSecurity.fromJson(Map<String, dynamic> json) => PortfolioSecurity(
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
    lastPrice: json["last_price"]?.toDouble()??0.0,
    costPrice: json["cost_price"].toString(),
    roi: json["roi"],
    quantity: json["quantity"].toString(),
    amount: json["amount"].toDouble(),
    allocation: json["allocation"],
    fxRate: json["fx_rate"],
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
  int? id;
  dynamic userId;
  int? companyId;
  String? name;
  String? isin;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? marketPlaceName;
  String? ticker;
  String? price;
  int? referenceCurrencyId;
  int? countryId;
  int? assetClassId;
  String? datetimePrice;
  String? lastModifiedBy;
  dynamic deletedAt;
  String? inhouseIdentifier;
  String? isoMic;
  String? figi;
  dynamic maturityDate;
  bool? absoluteImpact;
  dynamic contractNumber;
  dynamic priceCurrencyId;
  dynamic strike;
  dynamic securityYield;
  String? description;
  dynamic callableDate;
  String? firstYearPrice;
  String? securityType;
  String? dataSource;
  String? status;
  String? issuer;
  String? issuerRating;
  dynamic issueDate;
  dynamic strikeDate;
  Pipelines? pipelines;
  dynamic pricingFactor;
  bool? mandatoryKycFieldsPresent;
  CustomFields? customFields;
  String? sharedFolderIds;
  Pipelines? pipelinesForecastedValues;
  List<ResourcePipeline>? resourcePipelines;
  String? minimumAmount;
  String? incrementalAmount;
  String? minimumQuantity;
  String? incrementalQuantity;
  bool? featured;
  String? lastKeyInformationDocument;
  dynamic lastKeyInformationDate;
  bool? benchmark;
  dynamic imageUid;
  dynamic imageName;
  dynamic marginPct;
  String? datetimeMarginPct;
  String? destination;
  dynamic startPublishingDate;
  dynamic finishPublishingDate;
  dynamic expirationDate;
  int? creatorId;
  int? lastModifierId;
  String? counterparty;
  dynamic notionalAmount;
  dynamic fixedRate;
  String? indexReference;
  String? underlyingAsset;
  dynamic contractSize;
  dynamic tickSize;
  dynamic tickValue;
  String? optionStyle;
  String? optionType;
  dynamic premium;
  List<dynamic>? resourcePipelinesLocked;
  String? barcode;
  dynamic countryOfOriginId;
  String? stockKeepingUnit;
  String? harmonizedSystemCode;
  bool? isAvailableQuantity;
  dynamic settlementId;
  int? available;
  bool? benchmarkEsg;
  dynamic featuredAt;
  bool? showClientPortal;
  bool? showMember;
  dynamic liquidityDate;
  int? followBenchmarkId;
  String? videoUid;
  String? videoName;
  List<dynamic>? tagList;
  String? assetClassType;
  String? currentPrice;
  String? quandlCode;
  dynamic idcIdNotation;
  dynamic marketPlaceId;
  dynamic officialName;
  bool? restrictedAccess;
  bool? obsolete;
  dynamic idInstrument;
  dynamic referenceIdNotation;
  dynamic priceFactor;

  Security({
    this.id,
    this.userId,
    this.companyId,
    this.name,
    this.isin,
    this.createdAt,
    this.updatedAt,
    this.marketPlaceName,
    this.ticker,
    this.price,
    this.referenceCurrencyId,
    this.countryId,
    this.assetClassId,
    this.datetimePrice,
    this.lastModifiedBy,
    this.deletedAt,
    this.inhouseIdentifier,
    this.isoMic,
    this.figi,
    this.maturityDate,
    this.absoluteImpact,
    this.contractNumber,
    this.priceCurrencyId,
    this.strike,
    this.securityYield,
    this.description,
    this.callableDate,
    this.firstYearPrice,
    this.securityType,
    this.dataSource,
    this.status,
    this.issuer,
    this.issuerRating,
    this.issueDate,
    this.strikeDate,
    this.pipelines,
    this.pricingFactor,
    this.mandatoryKycFieldsPresent,
    this.customFields,
    this.sharedFolderIds,
    this.pipelinesForecastedValues,
    this.resourcePipelines,
    this.minimumAmount,
    this.incrementalAmount,
    this.minimumQuantity,
    this.incrementalQuantity,
    this.featured,
    this.lastKeyInformationDocument,
    this.lastKeyInformationDate,
    this.benchmark,
    this.imageUid,
    this.imageName,
    this.marginPct,
    this.datetimeMarginPct,
    this.destination,
    this.startPublishingDate,
    this.finishPublishingDate,
    this.expirationDate,
    this.creatorId,
    this.lastModifierId,
    this.counterparty,
    this.notionalAmount,
    this.fixedRate,
    this.indexReference,
    this.underlyingAsset,
    this.contractSize,
    this.tickSize,
    this.tickValue,
    this.optionStyle,
    this.optionType,
    this.premium,
    this.resourcePipelinesLocked,
    this.barcode,
    this.countryOfOriginId,
    this.stockKeepingUnit,
    this.harmonizedSystemCode,
    this.isAvailableQuantity,
    this.settlementId,
    this.available,
    this.benchmarkEsg,
    this.featuredAt,
    this.showClientPortal,
    this.showMember,
    this.liquidityDate,
    this.followBenchmarkId,
    this.videoUid,
    this.videoName,
    this.tagList,
    this.assetClassType,
    this.currentPrice,
    this.quandlCode,
    this.idcIdNotation,
    this.marketPlaceId,
    this.officialName,
    this.restrictedAccess,
    this.obsolete,
    this.idInstrument,
    this.referenceIdNotation,
    this.priceFactor,
  });

  factory Security.fromRawJson(String str) => Security.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Security.fromJson(Map<String, dynamic> json) => Security(
    id: json["id"],
    userId: json["user_id"],
    companyId: json["company_id"],
    name: json["name"],
    isin: json["isin"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    marketPlaceName: json["market_place_name"],
    ticker: json["ticker"],
    price: json["price"],
    referenceCurrencyId: json["reference_currency_id"],
    countryId: json["country_id"],
    assetClassId: json["asset_class_id"],
    datetimePrice: json["datetime_price"],
    lastModifiedBy: json["last_modified_by"],
    deletedAt: json["deleted_at"],
    inhouseIdentifier: json["inhouse_identifier"],
    isoMic: json["iso_mic"],
    figi: json["figi"],
    maturityDate: json["maturity_date"],
    absoluteImpact: json["absolute_impact"],
    contractNumber: json["contract_number"],
    priceCurrencyId: json["price_currency_id"],
    strike: json["strike"],
    securityYield: json["yield"],
    description: json["description"],
    callableDate: json["callable_date"],
    firstYearPrice: json["first_year_price"],
    securityType: json["security_type"],
    dataSource: json["data_source"],
    status: json["status"],
    issuer: json["issuer"],
    issuerRating: json["issuer_rating"],
    issueDate: json["issue_date"],
    strikeDate: json["strike_date"],
    pipelines: json["pipelines"]==null?null:Pipelines.fromJson(json["pipelines"]),
    pricingFactor: json["pricing_factor"],
    mandatoryKycFieldsPresent: json["mandatory_kyc_fields_present"],
    customFields: json["custom_fields"]==null?null:CustomFields.fromJson(json["custom_fields"]),
    sharedFolderIds: json["shared_folder_ids"],
    pipelinesForecastedValues: json["pipelines_forecasted_values"]==null?null:Pipelines.fromJson(json["pipelines_forecasted_values"]),
    resourcePipelines: json["resource_pipelines"]==null?[]:List<ResourcePipeline>.from(json["resource_pipelines"].map((x) => ResourcePipeline.fromJson(x))),
    minimumAmount: json["minimum_amount"],
    incrementalAmount: json["incremental_amount"],
    minimumQuantity: json["minimum_quantity"],
    incrementalQuantity: json["incremental_quantity"],
    featured: json["featured"],
    lastKeyInformationDocument: json["last_key_information_document"],
    lastKeyInformationDate: json["last_key_information_date"],
    benchmark: json["benchmark"],
    imageUid: json["image_uid"],
    imageName: json["image_name"],
    marginPct: json["margin_pct"],
    datetimeMarginPct: json["datetime_margin_pct"],
    destination: json["destination"],
    startPublishingDate: json["start_publishing_date"],
    finishPublishingDate: json["finish_publishing_date"],
    expirationDate: json["expiration_date"],
    creatorId: json["creator_id"],
    lastModifierId: json["last_modifier_id"],
    counterparty: json["counterparty"],
    notionalAmount: json["notional_amount"],
    fixedRate: json["fixed_rate"],
    indexReference: json["index_reference"],
    underlyingAsset: json["underlying_asset"],
    contractSize: json["contract_size"],
    tickSize: json["tick_size"],
    tickValue: json["tick_value"],
    optionStyle: json["option_style"],
    optionType: json["option_type"],
    premium: json["premium"],
    resourcePipelinesLocked: json["resource_pipelines_locked"]==null?[]:List<dynamic>.from(json["resource_pipelines_locked"].map((x) => x)),
    barcode: json["barcode"],
    countryOfOriginId: json["country_of_origin_id"],
    stockKeepingUnit: json["stock_keeping_unit"],
    harmonizedSystemCode: json["harmonized_system_code"],
    isAvailableQuantity: json["is_available_quantity"],
    settlementId: json["settlement_id"],
    available: json["available"],
    benchmarkEsg: json["benchmark_esg"],
    featuredAt: json["featured_at"],
    showClientPortal: json["show_client_portal"],
    showMember: json["show_member"],
    liquidityDate: json["liquidity_date"],
    followBenchmarkId: json["follow_benchmark_id"],
    videoUid: json["video_uid"],
    videoName: json["video_name"],
    tagList: List<dynamic>.from(json["tag_list"].map((x) => x)),
    assetClassType: json["asset_class_type"],
    currentPrice: json["current_price"],
    quandlCode: json["quandl_code"],
    idcIdNotation: json["idc_id_notation"],
    marketPlaceId: json["market_place_id"],
    officialName: json["official_name"],
    restrictedAccess: json["restricted_access"],
    obsolete: json["obsolete"],
    idInstrument: json["id_instrument"],
    referenceIdNotation: json["reference_id_notation"],
    priceFactor: json["price_factor"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "company_id": companyId,
    "name": name,
    "isin": isin,
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
    "market_place_name": marketPlaceName,
    "ticker": ticker,
    "price": price,
    "reference_currency_id": referenceCurrencyId,
    "country_id": countryId,
    "asset_class_id": assetClassId,
    "datetime_price": datetimePrice,
    "last_modified_by": lastModifiedBy,
    "deleted_at": deletedAt,
    "inhouse_identifier": inhouseIdentifier,
    "iso_mic": isoMic,
    "figi": figi,
    "maturity_date": maturityDate,
    "absolute_impact": absoluteImpact,
    "contract_number": contractNumber,
    "price_currency_id": priceCurrencyId,
    "strike": strike,
    "yield": securityYield,
    "description": description,
    "callable_date": callableDate,
    "first_year_price": firstYearPrice,
    "security_type": securityType,
    "data_source": dataSource,
    "status": status,
    "issuer": issuer,
    "issuer_rating": issuerRating,
    "issue_date": issueDate,
    "strike_date": strikeDate,
    "pipelines": pipelines?.toJson(),
    "pricing_factor": pricingFactor,
    "mandatory_kyc_fields_present": mandatoryKycFieldsPresent,
    "custom_fields": customFields?.toJson(),
    "shared_folder_ids": sharedFolderIds,
    "pipelines_forecasted_values": pipelinesForecastedValues?.toJson(),
    "resource_pipelines": resourcePipelines==null?[]:List<dynamic>.from(resourcePipelines!.map((x) => x.toJson())),
    "minimum_amount": minimumAmount,
    "incremental_amount": incrementalAmount,
    "minimum_quantity": minimumQuantity,
    "incremental_quantity": incrementalQuantity,
    "featured": featured,
    "last_key_information_document": lastKeyInformationDocument,
    "last_key_information_date": lastKeyInformationDate,
    "benchmark": benchmark,
    "image_uid": imageUid,
    "image_name": imageName,
    "margin_pct": marginPct,
    "datetime_margin_pct": datetimeMarginPct,
    "destination": destination,
    "start_publishing_date": startPublishingDate,
    "finish_publishing_date": finishPublishingDate,
    "expiration_date": expirationDate,
    "creator_id": creatorId,
    "last_modifier_id": lastModifierId,
    "counterparty": counterparty,
    "notional_amount": notionalAmount,
    "fixed_rate": fixedRate,
    "index_reference": indexReference,
    "underlying_asset": underlyingAsset,
    "contract_size": contractSize,
    "tick_size": tickSize,
    "tick_value": tickValue,
    "option_style": optionStyle,
    "option_type": optionType,
    "premium": premium,
    "resource_pipelines_locked": resourcePipelinesLocked==null?[]:List<dynamic>.from(resourcePipelinesLocked!.map((x) => x)),
    "barcode": barcode,
    "country_of_origin_id": countryOfOriginId,
    "stock_keeping_unit": stockKeepingUnit,
    "harmonized_system_code": harmonizedSystemCode,
    "is_available_quantity": isAvailableQuantity,
    "settlement_id": settlementId,
    "available": available,
    "benchmark_esg": benchmarkEsg,
    "featured_at": featuredAt,
    "show_client_portal": showClientPortal,
    "show_member": showMember,
    "liquidity_date": liquidityDate,
    "follow_benchmark_id": followBenchmarkId,
    "video_uid": videoUid,
    "video_name": videoName,
    "tag_list": tagList==null?[]:List<dynamic>.from(tagList!.map((x) => x)),
    "asset_class_type": assetClassType,
    "current_price": currentPrice,
    "quandl_code": quandlCode,
    "idc_id_notation": idcIdNotation,
    "market_place_id": marketPlaceId,
    "official_name": officialName,
    "restricted_access": restrictedAccess,
    "obsolete": obsolete,
    "id_instrument": idInstrument,
    "reference_id_notation": referenceIdNotation,
    "price_factor": priceFactor,
  };
}

class CustomFields {
  String? finsaClassification;
  String? productRiskClassification;

  CustomFields({
    this.finsaClassification,
    this.productRiskClassification,
  });

  factory CustomFields.fromRawJson(String str) => CustomFields.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomFields.fromJson(Map<String, dynamic> json) =>
      CustomFields(
        finsaClassification: json["FINSA Classification"],
        productRiskClassification: json["Product Risk Classification"],
      );

  Map<String, dynamic> toJson() =>
      {
        "FINSA Classification": finsaClassification,
        "Product Risk Classification": productRiskClassification,
      };
}

class Pipelines {
  Pipelines();

  factory Pipelines.fromRawJson(String str) => Pipelines.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pipelines.fromJson(Map<String, dynamic> json) => Pipelines(
  );

  Map<String, dynamic> toJson() => {
  };
}

class ResourcePipeline {
  String? days;
  String? name;
  String? stage;
  String? status;
  String? isExpired;
  DateTime? updatedAt;
  String? description;
  String? probability;
  String? forecastedValue;
  int? lastModifierId;
  String? activeMonitoring;
  dynamic onlyBusinessDays;
  String? isFirstNotifSent;
  String? triggerContactReport;
  dynamic lockStageAfterCallReport;

  ResourcePipeline({
    this.days,
    this.name,
    this.stage,
    this.status,
    this.isExpired,
    this.updatedAt,
    this.description,
    this.probability,
    this.forecastedValue,
    this.lastModifierId,
    this.activeMonitoring,
    this.onlyBusinessDays,
    this.isFirstNotifSent,
    this.triggerContactReport,
    this.lockStageAfterCallReport,
  });

  factory ResourcePipeline.fromRawJson(String str) => ResourcePipeline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResourcePipeline.fromJson(Map<String, dynamic> json) => ResourcePipeline(
    days: json["days"],
    name: json["name"],
    stage: json["stage"],
    status: json["status"],
    isExpired: json["is_expired"],
    updatedAt: DateTime.parse(json["updated_at"]),
    description: json["description"],
    probability: json["probability"],
    forecastedValue: json["forecasted_value"].toString(),
    lastModifierId: json["last_modifier_id"],
    activeMonitoring: json["active_monitoring"],
    onlyBusinessDays: json["only_business_days"],
    isFirstNotifSent: json["is_first_notif_sent"],
    triggerContactReport: json["trigger_contact_report"],
    lockStageAfterCallReport: json["lock_stage_after_call_report"],
  );

  Map<String, dynamic> toJson() => {
    "days": days,
    "name": name,
    "stage": stage,
    "status": status,
    "is_expired": isExpired,
    // "updated_at": updatedAt.toIso8601String(),
    "description": description,
    "probability": probability,
    "forecasted_value": forecastedValue,
    "last_modifier_id": lastModifierId,
    "active_monitoring": activeMonitoring,
    "only_business_days": onlyBusinessDays,
    "is_first_notif_sent": isFirstNotifSent,
    "trigger_contact_report": triggerContactReport,
    "lock_stage_after_call_report": lockStageAfterCallReport,
  };
}
