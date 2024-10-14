import 'dart:convert';

class ProposalModel {
  int? id;
  String? documentId;
  int? portfolioId;
  int? clientId;
  dynamic accountId;
  Advisor? advisor;
  String? state;
  bool isChecked;
  bool? tradeBlotterGenerated;
  String? name;
  String? proposalType;
  String? token;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? expiration;
  dynamic rebalancing;
  bool? applied;
  dynamic answeredAt;
  bool? answeredByRm;
  bool? requestProposalApproval;
  dynamic answerRmId;
  ProposalContent? proposalContent;
  int? creatorId;
  int? lastModifierId;
  dynamic pipelineId;
  String? stage;
  DateTime? lastUpdated;
  DateTime? acceptedDate;

  ProposalModel({
    this.id,
    this.documentId,
    this.portfolioId,
    this.clientId,
    this.accountId,
    this.advisor,
    this.requestProposalApproval,
    this.state,
    this.tradeBlotterGenerated,
    this.name,
    this.proposalType,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.isChecked=false,
    this.expiration,
    this.rebalancing,
    this.applied,
    this.answeredAt,
    this.answeredByRm,
    this.answerRmId,
    this.proposalContent,
    this.creatorId,
    this.lastModifierId,
    this.pipelineId,
    this.stage,
    this.lastUpdated,
    this.acceptedDate,
  });

  factory ProposalModel.fromRawJson(String str) => ProposalModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProposalModel.fromJson(Map<String, dynamic> json) => ProposalModel(
    id: json["id"],
    documentId: json["document_id"],
    portfolioId: json["portfolio_id"],
    requestProposalApproval: json["request_proposal_approval"]??false,
    clientId: json["client_id"],
    accountId: json["account_id"],
    advisor: json["advisor"] == null ? null : Advisor.fromJson(json["advisor"]),
    state: json["state"],
    tradeBlotterGenerated: json["trade_blotter_generated"],
    name: json["name"],
    proposalType: json["proposal_type"],
    token: json["token"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    expiration: json["expiration"] == null ? null : DateTime.parse(json["expiration"]),
    rebalancing: json["rebalancing"],
    applied: json["applied"],
    answeredAt: json["answered_at"],
    answeredByRm: json["answered_by_rm"],
    answerRmId: json["answer_rm_id"],
    proposalContent: json["proposal_content"] == null ? null : ProposalContent.fromJson(json["proposal_content"]),
    creatorId: json["creator_id"],
    lastModifierId: json["last_modifier_id"],
    pipelineId: json["pipeline_id"],
    stage: json["stage"],
    lastUpdated: json["last_updated"] == null ? null : DateTime.parse(json["last_updated"]),
    acceptedDate: json["accepted_date"] == null ? null : DateTime.parse(json["accepted_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "document_id": documentId,
    "portfolio_id": portfolioId,
    "client_id": clientId,
    "account_id": accountId,
    "advisor": advisor?.toJson(),
    "state": state,
    "trade_blotter_generated": tradeBlotterGenerated,
    "name": name,
    "proposal_type": proposalType,
    "request_proposal_approval": requestProposalApproval,
    "token": token,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "expiration": expiration?.toIso8601String(),
    "rebalancing": rebalancing,
    "applied": applied,
    "answered_at": answeredAt,
    "answered_by_rm": answeredByRm,
    "answer_rm_id": answerRmId,
    "proposal_content": proposalContent?.toJson(),
    "creator_id": creatorId,
    "last_modifier_id": lastModifierId,
    "pipeline_id": pipelineId,
    "stage": stage,
    "last_updated": lastUpdated?.toIso8601String(),
    "accepted_date": acceptedDate,
  };
}

class Advisor {
  int? id;
  String? name;
  String? phoneMobile;
  String? phoneHome;
  String? phoneOffice;
  String? email;
  String? avatar;
  dynamic publicAgenda;

  Advisor({
    this.id,
    this.name,
    this.phoneMobile,
    this.phoneHome,
    this.phoneOffice,
    this.email,
    this.avatar,
    this.publicAgenda,
  });

  factory Advisor.fromRawJson(String str) => Advisor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Advisor.fromJson(Map<String, dynamic> json) => Advisor(
    id: json["id"],
    name: json["name"],
    phoneMobile: json["phone_mobile"],
    phoneHome: json["phone_home"],
    phoneOffice: json["phone_office"]??json["phone_mobile"]??json["phone_home"]??'',
    email: json["email"],
    avatar: json["avatar"],
    publicAgenda: json["public_agenda"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone_mobile": phoneMobile,
    "phone_home": phoneHome,
    "phone_office": phoneOffice,
    "email": email,
    "avatar": avatar,
    "public_agenda": publicAgenda,
  };
}

class ProposalContent {
  List<dynamic>? rates;
  String? client;
  dynamic account;
  String? balance;
  String? manager;
  List<dynamic>? cashflow;
  dynamic override;
  Map<String, dynamic>? allRates;
  dynamic benchmark;
  String? portfolio;
  List<Currency>? currencies;
  String? ratesDate;
  List<dynamic>? securities;
  dynamic chartsType;
  dynamic performance;
  dynamic stressTest;
  DateTime? benchmarkTo;
  HealthCheck? healthCheck;
  dynamic attachedPdfs;
  String? baseCurrency;
  dynamic proposedOnly;
  DateTime? benchmarkFrom;
  dynamic advisedContact;
  dynamic benchmarkModel;
  dynamic isCashAccount;
  dynamic includeStrategy;
  String? operationOption;
  PortfolioScores? portfolioScores;
  String? amountCashOption;
  String? operationCurrency;
  String? proposalNetValue;
  dynamic benchmarkPortfolio;
  dynamic transactionsHistory;
  List<String>? benchmarkSecurityIds;
  String? proposedRefCurrAlloc;
  String? analysisPerAssetClass;
  String? proposalAmountInvested;
  String? proposalCashOptionFxRate;
  String? proposalAmountCashOptionSecCurr;

  ProposalContent({
    this.rates,
    this.client,
    this.account,
    this.balance,
    this.manager,
    this.cashflow,
    this.override,
    this.allRates,
    this.benchmark,
    this.portfolio,
    this.currencies,
    this.ratesDate,
    this.securities,
    this.chartsType,
    this.performance,
    this.stressTest,
    this.benchmarkTo,
    this.healthCheck,
    this.attachedPdfs,
    this.baseCurrency,
    this.proposedOnly,
    this.benchmarkFrom,
    this.advisedContact,
    this.benchmarkModel,
    this.isCashAccount,
    this.includeStrategy,
    this.operationOption,
    this.portfolioScores,
    this.amountCashOption,
    this.operationCurrency,
    this.proposalNetValue,
    this.benchmarkPortfolio,
    this.transactionsHistory,
    this.benchmarkSecurityIds,
    this.proposedRefCurrAlloc,
    this.analysisPerAssetClass,
    this.proposalAmountInvested,
    this.proposalCashOptionFxRate,
    this.proposalAmountCashOptionSecCurr,
  });

  factory ProposalContent.fromRawJson(String str) => ProposalContent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProposalContent.fromJson(Map<String, dynamic> json) => ProposalContent(
    rates: json["rates"] == null ? [] : List<dynamic>.from(json["rates"]!.map((x) => x)),
    client: json["client"],
    account: json["account"],
    balance: json["balance"],
    manager: json["manager"],
    cashflow: json["cashflow"] == null ? [] : List<dynamic>.from(json["cashflow"]!.map((x) => x)),
    override: json["override"],
    allRates: Map.from(json["all_rates"]!).map((k, v) => MapEntry<String, String>(k, v.toString())),
    benchmark: json["benchmark"],
    portfolio: json["portfolio"],
    currencies: json["currencies"] == null ? [] : List<Currency>.from(json["currencies"]!.map((x) => Currency.fromJson(x))),
    ratesDate: json["rates_date"],
    securities: json["securities"] == null ? [] : List<dynamic>.from(json["securities"]!.map((x) => x)),
    chartsType: json["charts_type"],
    performance: json["performance"],
    stressTest: json["stress_test"],
    benchmarkTo: json["benchmark_to"] == null ? null : DateTime.parse(json["benchmark_to"]),
    healthCheck: json["health_check"] == null ? null : HealthCheck.fromJson(json["health_check"]),
    attachedPdfs: json["attached_pdfs"],
    baseCurrency: json["base_currency"],
    proposedOnly: json["proposed_only"],
    benchmarkFrom: json["benchmark_from"] == null ? null : DateTime.parse(json["benchmark_from"]),
    advisedContact: json["advised_contact"],
    benchmarkModel: json["benchmark_model"],
    isCashAccount: json["is_cash_account"],
    includeStrategy: json["include_strategy"],
    operationOption: json["operation_option"],
    portfolioScores: json["portfolio_scores"] == null ? null : PortfolioScores.fromJson(json["portfolio_scores"]),
    amountCashOption: json["amount_cash_option"],
    operationCurrency: json["operation_currency"],
    proposalNetValue: json["proposal_net_value"],
    benchmarkPortfolio: json["benchmark_portfolio"],
    transactionsHistory: json["transactions_history"],
    benchmarkSecurityIds: json["benchmark_security_ids"] == null ? [] : List<String>.from(json["benchmark_security_ids"]!.map((x) => x)),
    proposedRefCurrAlloc: json["proposed_ref_curr_alloc"],
    analysisPerAssetClass: json["analysis_per_asset_class"],
    proposalAmountInvested: json["proposal_amount_invested"],
    proposalCashOptionFxRate: json["proposal_cash_option_fx_rate"],
    proposalAmountCashOptionSecCurr: json["proposal_amount_cash_option_sec_curr"],
  );

  Map<String, dynamic> toJson() => {
    "rates": rates == null ? [] : List<dynamic>.from(rates!.map((x) => x)),
    "client": client,
    "account": account,
    "balance": balance,
    "manager": manager,
    "cashflow": cashflow == null ? [] : List<dynamic>.from(cashflow!.map((x) => x)),
    "override": override,
    "all_rates": Map.from(allRates!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "benchmark": benchmark,
    "portfolio": portfolio,
    "currencies": currencies == null ? [] : List<dynamic>.from(currencies!.map((x) => x.toJson())),
    "rates_date": ratesDate,
    "securities": securities == null ? [] : List<dynamic>.from(securities!.map((x) => x)),
    "charts_type": chartsType,
    "performance": performance,
    "stress_test": stressTest,
    "benchmark_to": "${benchmarkTo!.year.toString().padLeft(4, '0')}-${benchmarkTo!.month.toString().padLeft(2, '0')}-${benchmarkTo!.day.toString().padLeft(2, '0')}",
    "health_check": healthCheck?.toJson(),
    "attached_pdfs": attachedPdfs,
    "base_currency": baseCurrency,
    "proposed_only": proposedOnly,
    "benchmark_from": "${benchmarkFrom!.year.toString().padLeft(4, '0')}-${benchmarkFrom!.month.toString().padLeft(2, '0')}-${benchmarkFrom!.day.toString().padLeft(2, '0')}",
    "advised_contact": advisedContact,
    "benchmark_model": benchmarkModel,
    "is_cash_account": isCashAccount,
    "include_strategy": includeStrategy,
    "operation_option": operationOption,
    "portfolio_scores": portfolioScores?.toJson(),
    "amount_cash_option": amountCashOption,
    "operation_currency": operationCurrency,
    "proposal_net_value": proposalNetValue,
    "benchmark_portfolio": benchmarkPortfolio,
    "transactions_history": transactionsHistory,
    "benchmark_security_ids": benchmarkSecurityIds == null ? [] : List<dynamic>.from(benchmarkSecurityIds!.map((x) => x)),
    "proposed_ref_curr_alloc": proposedRefCurrAlloc,
    "analysis_per_asset_class": analysisPerAssetClass,
    "proposal_amount_invested": proposalAmountInvested,
    "proposal_cash_option_fx_rate": proposalCashOptionFxRate,
    "proposal_amount_cash_option_sec_curr": proposalAmountCashOptionSecCurr,
  };
}

class CashflowClass {
  List<String>? labels;
  Options? options;
  List<Dataset>? datasets;

  CashflowClass({
    this.labels,
    this.options,
    this.datasets,
  });

  factory CashflowClass.fromRawJson(String str) => CashflowClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashflowClass.fromJson(Map<String, dynamic> json) => CashflowClass(
    labels: json["labels"] == null ? [] : List<String>.from(json["labels"]!.map((x) => x)),
    options: json["options"] == null ? null : Options.fromJson(json["options"]),
    datasets: json["datasets"] == null ? [] : List<Dataset>.from(json["datasets"]!.map((x) => Dataset.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "labels": labels == null ? [] : List<dynamic>.from(labels!.map((x) => x)),
    "options": options?.toJson(),
    "datasets": datasets == null ? [] : List<dynamic>.from(datasets!.map((x) => x.toJson())),
  };
}

class Dataset {
  List<int>? data;
  String? label;
  YAxisId? yAxisId;
  String? backgroundColor;

  Dataset({
    this.data,
    this.label,
    this.yAxisId,
    this.backgroundColor,
  });

  factory Dataset.fromRawJson(String str) => Dataset.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dataset.fromJson(Map<String, dynamic> json) => Dataset(
    data: json["data"] == null ? [] : List<int>.from(json["data"]!.map((x) => x)),
    label: json["label"],
    yAxisId: yAxisIdValues.map[json["yAxisID"]]!,
    backgroundColor: json["backgroundColor"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    "label": label,
    "yAxisID": yAxisIdValues.reverse[yAxisId],
    "backgroundColor": backgroundColor,
  };
}

enum YAxisId {
  COUP,
  PRIN
}

final yAxisIdValues = EnumValues({
  "coup": YAxisId.COUP,
  "prin": YAxisId.PRIN
});

class Options {
  Scales? scales;

  Options({
    this.scales,
  });

  factory Options.fromRawJson(String str) => Options.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    scales: json["scales"] == null ? null : Scales.fromJson(json["scales"]),
  );

  Map<String, dynamic> toJson() => {
    "scales": scales?.toJson(),
  };
}

class Scales {
  Coup? coup;
  Coup? prin;

  Scales({
    this.coup,
    this.prin,
  });

  factory Scales.fromRawJson(String str) => Scales.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Scales.fromJson(Map<String, dynamic> json) => Scales(
    coup: json["coup"] == null ? null : Coup.fromJson(json["coup"]),
    prin: json["prin"] == null ? null : Coup.fromJson(json["prin"]),
  );

  Map<String, dynamic> toJson() => {
    "coup": coup?.toJson(),
    "prin": prin?.toJson(),
  };
}

class Coup {
  Grid? grid;
  Title? title;
  String? position;

  Coup({
    this.grid,
    this.title,
    this.position,
  });

  factory Coup.fromRawJson(String str) => Coup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coup.fromJson(Map<String, dynamic> json) => Coup(
    grid: json["grid"] == null ? null : Grid.fromJson(json["grid"]),
    title: json["title"] == null ? null : Title.fromJson(json["title"]),
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "grid": grid?.toJson(),
    "title": title?.toJson(),
    "position": position,
  };
}

class Grid {
  bool? display;

  Grid({
    this.display,
  });

  factory Grid.fromRawJson(String str) => Grid.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Grid.fromJson(Map<String, dynamic> json) => Grid(
    display: json["display"],
  );

  Map<String, dynamic> toJson() => {
    "display": display,
  };
}

class Title {
  String? text;
  bool? display;

  Title({
    this.text,
    this.display,
  });

  factory Title.fromRawJson(String str) => Title.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    text: json["text"],
    display: json["display"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "display": display,
  };
}

class Currency {
  int? id;
  String? isin;
  String? rate;
  String? type;
  String? amount;
  dynamic market;
  String? currency;
  String? movement;
  String? security;
  dynamic direction;
  String? difference;
  String? lastPrice;
  String? assetClass;
  String? currencyId;
  String? targetAllocation;
  String? currentAllocation;
  String? targetAllocationPercent;
  String? currentAllocationPercent;

  Currency({
    this.id,
    this.isin,
    this.rate,
    this.type,
    this.amount,
    this.market,
    this.currency,
    this.movement,
    this.security,
    this.direction,
    this.difference,
    this.lastPrice,
    this.assetClass,
    this.currencyId,
    this.targetAllocation,
    this.currentAllocation,
    this.targetAllocationPercent,
    this.currentAllocationPercent,
  });

  factory Currency.fromRawJson(String str) => Currency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    isin: json["isin"],
    rate: json["rate"],
    type: json["type"],
    amount: json["amount"],
    market: json["market"],
    currency: json["currency"],
    movement: json["movement"],
    security: json["security"],
    direction: json["direction"],
    difference: json["difference"].toString(),
    lastPrice: json["last_price"],
    assetClass: json["asset_class"],
    currencyId: json["currency_id"],
    targetAllocation: json["target_allocation"],
    currentAllocation: json["current_allocation"],
    targetAllocationPercent: json["target_allocation_percent"],
    currentAllocationPercent: json["current_allocation_percent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isin": isin,
    "rate": rate,
    "type": type,
    "amount": amount,
    "market": market,
    "currency": currency,
    "movement": movement,
    "security": security,
    "direction": direction,
    "difference": difference,
    "last_price": lastPrice,
    "asset_class": assetClass,
    "currency_id": currencyId,
    "target_allocation": targetAllocation,
    "current_allocation": currentAllocation,
    "target_allocation_percent": targetAllocationPercent,
    "current_allocation_percent": currentAllocationPercent,
  };
}

class HealthCheck {
  List<dynamic>? universe;
  List<dynamic>? concentration;
  List<dynamic>? appropriateness;

  HealthCheck({
    this.universe,
    this.concentration,
    this.appropriateness,
  });

  factory HealthCheck.fromRawJson(String str) => HealthCheck.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HealthCheck.fromJson(Map<String, dynamic> json) => HealthCheck(
    universe: json["universe"] == null ? [] : List<dynamic>.from(json["universe"]!.map((x) => x)),
    concentration: json["concentration"] == null ? [] : List<dynamic>.from(json["concentration"]!.map((x) => x)),
    appropriateness: json["appropriateness"] == null ? [] : List<dynamic>.from(json["appropriateness"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "universe": universe == null ? [] : List<dynamic>.from(universe!.map((x) => x)),
    "concentration": concentration == null ? [] : List<dynamic>.from(concentration!.map((x) => x)),
    "appropriateness": appropriateness == null ? [] : List<dynamic>.from(appropriateness!.map((x) => x)),
  };
}

class PortfolioScores {
  CustomFields? tags;
  Allocations? allocations;
  SavesStatus? savesStatus;
  CustomFields? customFields;
  CustomFields? healthCheckStatus;
  SingleLinesCashflow? singleLinesCashflow;
  HealthCheckSecurityStatus? healthCheckSecurityStatus;
  Rates? rates;
  Map<String, String>? allRates;

  PortfolioScores({
    this.tags,
    this.allocations,
    this.savesStatus,
    this.customFields,
    this.healthCheckStatus,
    this.singleLinesCashflow,
    this.healthCheckSecurityStatus,
    this.rates,
    this.allRates,
  });

  factory PortfolioScores.fromRawJson(String str) => PortfolioScores.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PortfolioScores.fromJson(Map<String, dynamic> json) => PortfolioScores(
    tags: json["tags"] == null ? null : CustomFields.fromJson(json["tags"]),
    allocations: json["allocations"] == null ? null : Allocations.fromJson(json["allocations"]),
    savesStatus: json["saves_status"] == null ? null : SavesStatus.fromJson(json["saves_status"]),
    customFields: json["custom_fields"] == null ? null : CustomFields.fromJson(json["custom_fields"]),
    healthCheckStatus: json["health_check_status"] == null ? null : CustomFields.fromJson(json["health_check_status"]),
    singleLinesCashflow: json["single_lines_cashflow"] == null ? null : SingleLinesCashflow.fromJson(json["single_lines_cashflow"]),
    healthCheckSecurityStatus: json["health_check_security_status"] == null ? null : HealthCheckSecurityStatus.fromJson(json["health_check_security_status"]),
    rates: json["rates"] == null ? null : Rates.fromJson(json["rates"]),
    allRates: json["all_rates"]==null?null:Map.from(json["all_rates"]!).map((k, v) => MapEntry<String, String>(k, v.toString())),
  );

  Map<String, dynamic> toJson() => {
    "tags": tags?.toJson(),
    "allocations": allocations?.toJson(),
    "saves_status": savesStatus?.toJson(),
    "custom_fields": customFields?.toJson(),
    "health_check_status": healthCheckStatus?.toJson(),
    "single_lines_cashflow": singleLinesCashflow?.toJson(),
    "health_check_security_status": healthCheckSecurityStatus?.toJson(),
    "rates": rates?.toJson(),
    "all_rates": Map.from(allRates!).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class Allocations {
  CustomFields? countries;
  Currencies? currencies;
  Industries? industries;
  Securities? securities;
  CashAccount? cashAccount;
  AssetClasses? assetClasses;
  CustomFields? tagCategories;
  PerAssetCountries? perAssetCountries;
  PerAssetCurrencies? perAssetCurrencies;
  PerAssetIndustries? perAssetIndustries;

  Allocations({
    this.countries,
    this.currencies,
    this.industries,
    this.securities,
    this.cashAccount,
    this.assetClasses,
    this.tagCategories,
    this.perAssetCountries,
    this.perAssetCurrencies,
    this.perAssetIndustries,
  });

  factory Allocations.fromRawJson(String str) => Allocations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Allocations.fromJson(Map<String, dynamic> json) => Allocations(
    countries: json["countries"] == null ? null : CustomFields.fromJson(json["countries"]),
    currencies: json["currencies"] == null ? null : Currencies.fromJson(json["currencies"]),
    industries: json["industries"] == null ? null : Industries.fromJson(json["industries"]),
    securities: json["securities"] == null ? null : Securities.fromJson(json["securities"]),
    // cashAccount: json["cash_account"] == null ? null : CashAccount.fromJson(json["cash_account"]),
    assetClasses: json["asset_classes"] == null ? null : AssetClasses.fromJson(json["asset_classes"]),
    tagCategories: json["tag_categories"] == null ? null : CustomFields.fromJson(json["tag_categories"]),
    perAssetCountries: json["per_asset_countries"] == null ? null : PerAssetCountries.fromJson(json["per_asset_countries"]),
    perAssetCurrencies: json["per_asset_currencies"] == null ? null : PerAssetCurrencies.fromJson(json["per_asset_currencies"]),
    perAssetIndustries: json["per_asset_industries"] == null ? null : PerAssetIndustries.fromJson(json["per_asset_industries"]),
  );

  Map<String, dynamic> toJson() => {
    "countries": countries?.toJson(),
    "currencies": currencies?.toJson(),
    "industries": industries?.toJson(),
    "securities": securities?.toJson(),
    // "cash_account": cashAccount?.toJson(),
    "asset_classes": assetClasses?.toJson(),
    "tag_categories": tagCategories?.toJson(),
    "per_asset_countries": perAssetCountries?.toJson(),
    "per_asset_currencies": perAssetCurrencies?.toJson(),
    "per_asset_industries": perAssetIndustries?.toJson(),
  };
}

class AssetClasses {
  List<dynamic>? cash;

  AssetClasses({
    this.cash,
  });

  factory AssetClasses.fromRawJson(String str) => AssetClasses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssetClasses.fromJson(Map<String, dynamic> json) => AssetClasses(
    cash: json["Cash"] == null ? [] : List<dynamic>.from(json["Cash"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Cash": cash == null ? [] : List<dynamic>.from(cash!.map((x) => x)),
  };
}

class CashAccount {
  String? the4True;
  int? the4ChfTrue;

  CashAccount({
    this.the4True,
    this.the4ChfTrue,
  });

  factory CashAccount.fromRawJson(String str) => CashAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashAccount.fromJson(Map<String, dynamic> json) => CashAccount(
    the4True: json["[4, true]"],
    the4ChfTrue: json["[4, \"CHF\", true]"],
  );

  Map<String, dynamic> toJson() => {
    "[4, true]": the4True,
    "[4, \"CHF\", true]": the4ChfTrue,
  };
}

class CustomFields {
  CustomFields();

  factory CustomFields.fromRawJson(String str) => CustomFields.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomFields.fromJson(Map<String, dynamic> json) => CustomFields(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Currencies {
  List<dynamic>? chf;

  Currencies({
    this.chf,
  });

  factory Currencies.fromRawJson(String str) => Currencies.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Currencies.fromJson(Map<String, dynamic> json) => Currencies(
    chf: json["CHF"] == null ? [] : List<dynamic>.from(json["CHF"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "CHF": chf == null ? [] : List<dynamic>.from(chf!.map((x) => x)),
  };
}

class Industries {
  List<dynamic>? noIndustry;

  Industries({
    this.noIndustry,
  });

  factory Industries.fromRawJson(String str) => Industries.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Industries.fromJson(Map<String, dynamic> json) => Industries(
    noIndustry: json["No Industry"] == null ? [] : List<dynamic>.from(json["No Industry"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "No Industry": noIndustry == null ? [] : List<dynamic>.from(noIndustry!.map((x) => x)),
  };
}

class PerAssetCountries {
  CustomFields? cash;

  PerAssetCountries({
    this.cash,
  });

  factory PerAssetCountries.fromRawJson(String str) => PerAssetCountries.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerAssetCountries.fromJson(Map<String, dynamic> json) => PerAssetCountries(
    cash: json["Cash"] == null ? null : CustomFields.fromJson(json["Cash"]),
  );

  Map<String, dynamic> toJson() => {
    "Cash": cash?.toJson(),
  };
}

class PerAssetCurrencies {
  Currencies? cash;

  PerAssetCurrencies({
    this.cash,
  });

  factory PerAssetCurrencies.fromRawJson(String str) => PerAssetCurrencies.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerAssetCurrencies.fromJson(Map<String, dynamic> json) => PerAssetCurrencies(
    cash: json["Cash"] == null ? null : Currencies.fromJson(json["Cash"]),
  );

  Map<String, dynamic> toJson() => {
    "Cash": cash?.toJson(),
  };
}

class PerAssetIndustries {
  Cash? cash;

  PerAssetIndustries({
    this.cash,
  });

  factory PerAssetIndustries.fromRawJson(String str) => PerAssetIndustries.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PerAssetIndustries.fromJson(Map<String, dynamic> json) => PerAssetIndustries(
    cash: json["Cash"] == null ? null : Cash.fromJson(json["Cash"]),
  );

  Map<String, dynamic> toJson() => {
    "Cash": cash?.toJson(),
  };
}

class Cash {
  List<dynamic>? blend;

  Cash({
    this.blend,
  });

  factory Cash.fromRawJson(String str) => Cash.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cash.fromJson(Map<String, dynamic> json) => Cash(
    blend: json["Blend"] == null ? [] : List<dynamic>.from(json["Blend"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Blend": blend == null ? [] : List<dynamic>.from(blend!.map((x) => x)),
  };
}

class Securities {
  List<String>? item196;

  Securities({
    this.item196,
  });

  factory Securities.fromRawJson(String str) => Securities.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Securities.fromJson(Map<String, dynamic> json) => Securities(
    item196: json["Item-196"] == null ? [] : List<String>.from(json["Item-196"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Item-196": item196 == null ? [] : List<dynamic>.from(item196!.map((x) => x)),
  };
}

class HealthCheckSecurityStatus {
  List<dynamic>? universeLists;
  List<dynamic>? appropriateness;
  List<dynamic>? concentrationLists;
  List<dynamic>? concentrationListIssuers;

  HealthCheckSecurityStatus({
    this.universeLists,
    this.appropriateness,
    this.concentrationLists,
    this.concentrationListIssuers,
  });

  factory HealthCheckSecurityStatus.fromRawJson(String str) => HealthCheckSecurityStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HealthCheckSecurityStatus.fromJson(Map<String, dynamic> json) => HealthCheckSecurityStatus(
    universeLists: json["universe_lists"] == null ? [] : List<dynamic>.from(json["universe_lists"]!.map((x) => x)),
    appropriateness: json["appropriateness"] == null ? [] : List<dynamic>.from(json["appropriateness"]!.map((x) => x)),
    concentrationLists: json["concentration_lists"] == null ? [] : List<dynamic>.from(json["concentration_lists"]!.map((x) => x)),
    concentrationListIssuers: json["concentration_list_issuers"] == null ? [] : List<dynamic>.from(json["concentration_list_issuers"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "universe_lists": universeLists == null ? [] : List<dynamic>.from(universeLists!.map((x) => x)),
    "appropriateness": appropriateness == null ? [] : List<dynamic>.from(appropriateness!.map((x) => x)),
    "concentration_lists": concentrationLists == null ? [] : List<dynamic>.from(concentrationLists!.map((x) => x)),
    "concentration_list_issuers": concentrationListIssuers == null ? [] : List<dynamic>.from(concentrationListIssuers!.map((x) => x)),
  };
}

class Rates {
  The4? the4;

  Rates({
    this.the4,
  });

  factory Rates.fromRawJson(String str) => Rates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rates.fromJson(Map<String, dynamic> json) => Rates(
    the4: json["4"] == null ? null : The4.fromJson(json["4"]),
  );

  Map<String, dynamic> toJson() => {
    "4": the4?.toJson(),
  };
}

class The4 {
  String? the4;

  The4({
    this.the4,
  });

  factory The4.fromRawJson(String str) => The4.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory The4.fromJson(Map<String, dynamic> json) => The4(
    the4: json["4"],
  );

  Map<String, dynamic> toJson() => {
    "4": the4,
  };
}

class SavesStatus {
  List<dynamic>? the459081;

  SavesStatus({
    this.the459081,
  });

  factory SavesStatus.fromRawJson(String str) => SavesStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SavesStatus.fromJson(Map<String, dynamic> json) => SavesStatus(
    the459081: json["459081"] == null ? [] : List<dynamic>.from(json["459081"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "459081": the459081 == null ? [] : List<dynamic>.from(the459081!.map((x) => x)),
  };
}

class SingleLinesCashflow {
  Map<String, CustomFields>? cashflow;

  SingleLinesCashflow({
    this.cashflow,
  });

  factory SingleLinesCashflow.fromRawJson(String str) => SingleLinesCashflow.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SingleLinesCashflow.fromJson(Map<String, dynamic> json) => SingleLinesCashflow(
    cashflow: Map.from(json["cashflow"]!).map((k, v) => MapEntry<String, CustomFields>(k, CustomFields.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "cashflow": Map.from(cashflow!).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
