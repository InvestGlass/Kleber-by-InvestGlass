// To parse this JSON data, do
//
//     final accountsModel = accountsModelFromJson(jsonString);

import 'dart:convert';

List<AccountsModel> accountsModelFromJson(String str) => List<AccountsModel>.from(json.decode(str).map((x) => AccountsModel.fromJson(x)));

String accountsModelToJson(List<AccountsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountsModel {
  int? id;
  String? name;
  int? companyId;
  int? creatorId;
  List<Tag>? tags;
  List<dynamic>? resourcePipelines;
  dynamic relationshipManagerId;
  dynamic relationshipManager2Id;
  CustomFields? customFields;
  int? accountStatus;
  bool? mandatoryKycFieldsPresent;
  List<dynamic>? relations;
  List<Contact>? contacts;
  DateTime? createdAt;
  DateTime? updatedAt;

  AccountsModel({
    this.id,
    this.name,
    this.companyId,
    this.creatorId,
    this.tags,
    this.resourcePipelines,
    this.relationshipManagerId,
    this.relationshipManager2Id,
    this.customFields,
    this.accountStatus,
    this.mandatoryKycFieldsPresent,
    this.relations,
    this.contacts,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountsModel.fromJson(Map<String, dynamic> json) => AccountsModel(
    id: json["id"],
    name: json["name"],
    companyId: json["company_id"],
    creatorId: json["creator_id"],
    tags: json["tags"] == null ? [] : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
    resourcePipelines: json["resource_pipelines"] == null ? [] : List<dynamic>.from(json["resource_pipelines"]!.map((x) => x)),
    relationshipManagerId: json["relationship_manager_id"],
    relationshipManager2Id: json["relationship_manager2_id"],
    customFields: json["custom_fields"] == null ? null : CustomFields.fromJson(json["custom_fields"]),
    accountStatus: json["account_status"],
    mandatoryKycFieldsPresent: json["mandatory_kyc_fields_present"],
    relations: json["relations"] == null ? [] : List<dynamic>.from(json["relations"]!.map((x) => x)),
    contacts: json["contacts"] == null ? [] : List<Contact>.from(json["contacts"]!.map((x) => Contact.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "company_id": companyId,
    "creator_id": creatorId,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toJson())),
    "resource_pipelines": resourcePipelines == null ? [] : List<dynamic>.from(resourcePipelines!.map((x) => x)),
    "relationship_manager_id": relationshipManagerId,
    "relationship_manager2_id": relationshipManager2Id,
    "custom_fields": customFields?.toJson(),
    "account_status": accountStatus,
    "mandatory_kyc_fields_present": mandatoryKycFieldsPresent,
    "relations": relations == null ? [] : List<dynamic>.from(relations!.map((x) => x)),
    "contacts": contacts == null ? [] : List<dynamic>.from(contacts!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Contact {
  int? id;
  String? name;

  Contact({
    this.id,
    this.name,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class CustomFields {
  String? fax;
  String? phone;
  String? website;
  String? finSaClassification;
  String? countryOfIncorporationOfOperatingCompany;
  String? countryOfIncorporationOfDomiciliaryCompany;
  String? addressStreet;

  CustomFields({
    this.fax,
    this.phone,
    this.website,
    this.finSaClassification,
    this.countryOfIncorporationOfOperatingCompany,
    this.countryOfIncorporationOfDomiciliaryCompany,
    this.addressStreet,
  });

  factory CustomFields.fromJson(Map<String, dynamic> json) => CustomFields(
    fax: json["Fax"],
    phone: json["Phone"],
    website: json["Website"],
    finSaClassification: json["FinSAClassification"],
    countryOfIncorporationOfOperatingCompany: json["Country of Incorporation of Operating company"],
    countryOfIncorporationOfDomiciliaryCompany: json["Country of Incorporation of Domiciliary company"],
    addressStreet: json["Address Street"],
  );

  Map<String, dynamic> toJson() => {
    "Fax": fax,
    "Phone": phone,
    "Website": website,
    "FinSAClassification": finSaClassification,
    "Country of Incorporation of Operating company": countryOfIncorporationOfOperatingCompany,
    "Country of Incorporation of Domiciliary company": countryOfIncorporationOfDomiciliaryCompany,
    "Address Street": addressStreet,
  };
}

class Tag {
  int? id;
  String? name;
  int? taggingsCount;

  Tag({
    this.id,
    this.name,
    this.taggingsCount,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json["id"],
    name: json["name"],
    taggingsCount: json["taggings_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "taggings_count": taggingsCount,
  };
}
