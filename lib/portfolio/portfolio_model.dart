import 'dart:convert';

class PortfolioModel {
  int? id;
  String? title;
  dynamic? userId;
  ClientPreference? clientPreference;
  dynamic? strategy;
  Concentration? concentration;
  CashFlowDistribution? cashFlowDistribution;
  String? netValue;
  String? portfolioValue;
  String? amountInvested;
  String? cashAvailable;
  List<PerformanceChart>? performanceChart;
  List<SChart>? assetClassChart;
  List<SChart>? currenciesChart;
  String? sectionName;
  Appropriateness? appropriateness;
  Appropriateness? suitability;

  PortfolioModel({
    this.id,
    this.title,
    this.userId,
    this.clientPreference,
    this.strategy,
    this.concentration,
    this.cashFlowDistribution,
    this.netValue,
    this.portfolioValue,
    this.amountInvested,
    this.cashAvailable,
    this.performanceChart,
    this.assetClassChart,
    this.currenciesChart,
    this.appropriateness,
    this.suitability,
    this.sectionName,
  });

  factory PortfolioModel.fromRawJson(String str) => PortfolioModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
    id: json["id"],
    title: json["title"],
    userId: json["user_id"],
    clientPreference: ClientPreference.fromJson(json["client_preference"]),
    strategy: json["strategy"],
    concentration: Concentration.fromJson(json["concentration"]),
    cashFlowDistribution: CashFlowDistribution.fromJson(json["cash_flow_distribution"]),
    netValue: json["net_value"]??'',
    portfolioValue: json["portfolio_value"],
    amountInvested: json["amount_invested"],
    cashAvailable: json["cash_available"],
    performanceChart: List<PerformanceChart>.from(json["performance_chart"].map((x) => PerformanceChart.fromJson(x))),
    assetClassChart: List<SChart>.from(json["asset_class_chart"].map((x) => SChart.fromJson(x))),
    currenciesChart: List<SChart>.from(json["currencies_chart"].map((x) => SChart.fromJson(x))),
    appropriateness: Appropriateness.fromJson(json["appropriateness"]),
    suitability: Appropriateness.fromJson(json["suitability"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "user_id": userId,
    "client_preference": clientPreference?.toJson(),
    "strategy": strategy,
    "concentration": concentration?.toJson(),
    "cash_flow_distribution": cashFlowDistribution?.toJson(),
    "net_value": netValue,
    "portfolio_value": portfolioValue,
    "amount_invested": amountInvested,
    "cash_available": cashAvailable,
    "performance_chart": performanceChart==null?[]:List<dynamic>.from(performanceChart!.map((x) => x.toJson())),
    "asset_class_chart": assetClassChart==null?[]:List<dynamic>.from(assetClassChart!.map((x) => x.toJson())),
    "currencies_chart": currenciesChart==null?[]:List<dynamic>.from(currenciesChart!.map((x) => x.toJson())),
    "appropriateness": appropriateness?.toJson(),
    "suitability": suitability?.toJson(),
  };
}

class Appropriateness {
  String? status;
  List<String>? listDetails;

  Appropriateness({
    this.status,
    this.listDetails,
  });

  factory Appropriateness.fromRawJson(String str) => Appropriateness.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Appropriateness.fromJson(Map<String, dynamic> json) => Appropriateness(
    status: json["status"],
    listDetails: List<String>.from(json["list_details"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "list_details": listDetails==null?[]:List<dynamic>.from(listDetails!.map((x) => x)),
  };
}

class SChart {
  String? assetClass;
  double? amount1;
  double? amount2;
  double? amount3;

  SChart({
    this.assetClass,
    this.amount1,
    this.amount2,
    this.amount3,
  });

  factory SChart.fromRawJson(String str) => SChart.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SChart.fromJson(Map<String, dynamic> json) => SChart(
    assetClass: json["asset_class"],
    amount1: json["amount_1"]?.toDouble()??0.0,
    amount2: json["amount_2"]?.toDouble()??0.0,
    amount3: json["amount_3"]?.toDouble()??0.0,
  );

  Map<String, dynamic> toJson() => {
    "asset_class": assetClass,
    "amount_1": amount1,
    "amount_2": amount2,
    "amount_3": amount3,
  };
}

class CashFlowDistribution {
  List<List<dynamic>>? table;
  List<Chart>? chart;

  CashFlowDistribution({
    this.table,
    this.chart,
  });

  factory CashFlowDistribution.fromRawJson(String str) => CashFlowDistribution.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashFlowDistribution.fromJson(Map<String, dynamic> json) => CashFlowDistribution(
    table: List<List<dynamic>>.from(json["table"].map((x) => List<dynamic>.from(x.map((x) => x)))),
    chart: List<Chart>.from(json["chart"].map((x) => Chart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "table": table==null?[]:List<dynamic>.from(table!.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "chart": chart==null?[]:List<dynamic>.from(chart!.map((x) => x.toJson())),
  };
}

class Chart {
  String? year;
  String? principal;
  String? coupon;

  Chart({
    this.year,
    this.principal,
    this.coupon,
  });

  factory Chart.fromRawJson(String str) => Chart.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Chart.fromJson(Map<String, dynamic> json) => Chart(
    year: json["year"].toString(),
    principal: json["principal"].toString(),
    coupon: json["coupon"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "principal": principal,
    "coupon": coupon,
  };
}

class ClientPreference {
  dynamic preferedStopLoss;
  dynamic preferedTakeProfit;
  dynamic maximumSecurityAllocation;
  dynamic minimumSecuritiesPerPortfolio;
  dynamic maxIssuerConcentration;
  dynamic maximumProductParticipation;
  dynamic maximumSrri;
  dynamic preferredYearlyVolatility;
  dynamic maximumDrawdown;
  dynamic minBondRating;
  dynamic minimumCashAllocation;
  dynamic maxTop5Pct;
  bool? shortSelling;
  bool? spotAbove10Pct;
  bool? authToSendTrade;
  bool? nigthShift;
  bool? mifidOptout;
  bool? lsfinOptout;
  dynamic mifidOptoutDescription;
  dynamic lsfinOptoutDescription;
  List<dynamic>? preferredStrategyIndustries;
  List<dynamic>? preferredStrategyAssetClasses;
  List<dynamic>? preferredStrategyCurrencies;
  List<dynamic>? preferredStrategyCountries;

  ClientPreference({
    this.preferedStopLoss,
    this.preferedTakeProfit,
    this.maximumSecurityAllocation,
    this.minimumSecuritiesPerPortfolio,
    this.maxIssuerConcentration,
    this.maximumProductParticipation,
    this.maximumSrri,
    this.preferredYearlyVolatility,
    this.maximumDrawdown,
    this.minBondRating,
    this.minimumCashAllocation,
    this.maxTop5Pct,
    this.shortSelling,
    this.spotAbove10Pct,
    this.authToSendTrade,
    this.nigthShift,
    this.mifidOptout,
    this.lsfinOptout,
    this.mifidOptoutDescription,
    this.lsfinOptoutDescription,
    this.preferredStrategyIndustries,
    this.preferredStrategyAssetClasses,
    this.preferredStrategyCurrencies,
    this.preferredStrategyCountries,
  });

  factory ClientPreference.fromRawJson(String str) => ClientPreference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClientPreference.fromJson(Map<String, dynamic> json) => ClientPreference(
    preferedStopLoss: json["prefered_stop_loss"],
    preferedTakeProfit: json["prefered_take_profit"],
    maximumSecurityAllocation: json["maximum_security_allocation"],
    minimumSecuritiesPerPortfolio: json["minimum_securities_per_portfolio"],
    maxIssuerConcentration: json["max_issuer_concentration"],
    maximumProductParticipation: json["maximum_product_participation"],
    maximumSrri: json["maximum_srri"],
    preferredYearlyVolatility: json["preferred_yearly_volatility"],
    maximumDrawdown: json["maximum_drawdown"],
    minBondRating: json["min_bond_rating"],
    minimumCashAllocation: json["minimum_cash_allocation"],
    maxTop5Pct: json["max_top_5_pct"],
    shortSelling: json["short_selling"],
    spotAbove10Pct: json["spot_above_10_pct"],
    authToSendTrade: json["auth_to_send_trade"],
    nigthShift: json["nigth_shift"],
    mifidOptout: json["mifid_optout"],
    lsfinOptout: json["lsfin_optout"],
    mifidOptoutDescription: json["mifid_optout_description"],
    lsfinOptoutDescription: json["lsfin_optout_description"],
    preferredStrategyIndustries: List<dynamic>.from(json["preferred_strategy_industries"].map((x) => x)),
    preferredStrategyAssetClasses: List<dynamic>.from(json["preferred_strategy_asset_classes"].map((x) => x)),
    preferredStrategyCurrencies: List<dynamic>.from(json["preferred_strategy_currencies"].map((x) => x)),
    preferredStrategyCountries: List<dynamic>.from(json["preferred_strategy_countries"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "prefered_stop_loss": preferedStopLoss,
    "prefered_take_profit": preferedTakeProfit,
    "maximum_security_allocation": maximumSecurityAllocation,
    "minimum_securities_per_portfolio": minimumSecuritiesPerPortfolio,
    "max_issuer_concentration": maxIssuerConcentration,
    "maximum_product_participation": maximumProductParticipation,
    "maximum_srri": maximumSrri,
    "preferred_yearly_volatility": preferredYearlyVolatility,
    "maximum_drawdown": maximumDrawdown,
    "min_bond_rating": minBondRating,
    "minimum_cash_allocation": minimumCashAllocation,
    "max_top_5_pct": maxTop5Pct,
    "short_selling": shortSelling,
    "spot_above_10_pct": spotAbove10Pct,
    "auth_to_send_trade": authToSendTrade,
    "nigth_shift": nigthShift,
    "mifid_optout": mifidOptout,
    "lsfin_optout": lsfinOptout,
    "mifid_optout_description": mifidOptoutDescription,
    "lsfin_optout_description": lsfinOptoutDescription,
    "preferred_strategy_industries": preferredStrategyIndustries==null?[]:List<dynamic>.from(preferredStrategyIndustries!.map((x) => x)),
    "preferred_strategy_asset_classes": preferredStrategyAssetClasses==null?[]:List<dynamic>.from(preferredStrategyAssetClasses!.map((x) => x)),
    "preferred_strategy_currencies": preferredStrategyCurrencies==null?[]:List<dynamic>.from(preferredStrategyCurrencies!.map((x) => x)),
    "preferred_strategy_countries": preferredStrategyCountries==null?[]:List<dynamic>.from(preferredStrategyCountries!.map((x) => x)),
  };
}

class Concentration {
  List<String>? concentrationLists;
  List<ConcentrationListIssuer>? concentrationListIssuers;

  Concentration({
    this.concentrationLists,
    this.concentrationListIssuers,
  });

  factory Concentration.fromRawJson(String str) => Concentration.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Concentration.fromJson(Map<String, dynamic> json) => Concentration(
    concentrationLists: List<String>.from(json["concentration_lists"].map((x) => x)),
    concentrationListIssuers: List<ConcentrationListIssuer>.from(json["concentration_list_issuers"].map((x) => ConcentrationListIssuer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "concentration_lists": concentrationLists==null?[]:List<dynamic>.from(concentrationLists!.map((x) => x)),
    "concentration_list_issuers": concentrationListIssuers==null?[]:List<dynamic>.from(concentrationListIssuers!.map((x) => x.toJson())),
  };
}

class ConcentrationListIssuer {
  String? issuerName;
  String? finsaSecurity;
  double? totalAllocation;
  List<Security>? securities;

  ConcentrationListIssuer({
    this.issuerName,
    this.finsaSecurity,
    this.totalAllocation,
    this.securities,
  });

  factory ConcentrationListIssuer.fromRawJson(String str) => ConcentrationListIssuer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConcentrationListIssuer.fromJson(Map<String, dynamic> json) => ConcentrationListIssuer(
    issuerName: json["issuer_name"],
    finsaSecurity: json["finsa_security"],
    totalAllocation: json["total_allocation"].toDouble(),
    securities: List<Security>.from(json["securities"].map((x) => Security.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "issuer_name": issuerName,
    "finsa_security": finsaSecurity,
    "total_allocation": totalAllocation,
    "securities": securities==null?[]:List<dynamic>.from(securities!.map((x) => x.toJson())),
  };
}

class Security {
  String? name;
  double? allocationPct;

  Security({
    this.name,
    this.allocationPct,
  });

  factory Security.fromRawJson(String str) => Security.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Security.fromJson(Map<String, dynamic> json) => Security(
    name: json["name"],
    allocationPct: json["allocation_pct"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "allocation_pct": allocationPct,
  };
}

class PerformanceChart {
  DateTime? date;
  double? amount;
  double? twrPercentage;

  PerformanceChart({
    this.date,
    this.amount,
    this.twrPercentage,
  });

  factory PerformanceChart.fromRawJson(String str) => PerformanceChart.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerformanceChart.fromJson(Map<String, dynamic> json) => PerformanceChart(
    date: DateTime.parse(json["date"]),
    amount: json["amount"].toDouble(),
    twrPercentage: json["twr_percentage"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "amount": amount,
    "twr_percentage": twrPercentage,
  };
}
