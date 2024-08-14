import 'dart:convert';

class DocumentModel {
  List<Document>? folders;
  List<Document>? documents;

  DocumentModel({
    this.folders,
    this.documents,
  });

  factory DocumentModel.fromRawJson(String str) => DocumentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    List<Document> docList=json["documents"] == null ? [] : List<Document>.from(json["documents"]!.map((x) => Document.fromJson(x)));
    return DocumentModel(
      folders: json["folders"] == null ? [] : List<Document>.from(json["folders"]!.map((x) => Document.fromJson(x)))..addAll(docList),
      documents: [],
    );
  }

  Map<String, dynamic> toJson() => {
        "folders": folders == null ? [] : List<dynamic>.from(folders!.map((x) => x.toJson())),
        "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
      };
}

class Document {
  int? id;
  String? folderName;
  int? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic ancestry;
  int? clientId;
  bool? shareOnClientPortal;
  int? creatorId;
  int? lastModifierId;
  bool? notifyByEmail;
  String? clientType;
  String? documentStatus;
  String? url;
  bool? isRead;
  String? documentType;
  dynamic approverId;
  dynamic approvedAt;
  int? disapproverId;
  DateTime? disapprovedAt;

  Document({
    this.id,
    this.folderName,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.ancestry,
    this.clientId,
    this.shareOnClientPortal,
    this.creatorId,
    this.lastModifierId,
    this.notifyByEmail,
    this.clientType,
    this.documentStatus,
    this.url,
    this.isRead,
    this.documentType,
    this.approverId,
    this.approvedAt,
    this.disapproverId,
    this.disapprovedAt,
  });

  factory Document.fromRawJson(String str) => Document.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json["id"],
    folderName: json["folder_name"]??json["original_filename"],
    companyId: json["company_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    ancestry: json["ancestry"],
    clientId: json["client_id"],
    shareOnClientPortal: json["share_on_client_portal"],
    creatorId: json["creator_id"],
    lastModifierId: json["last_modifier_id"],
    notifyByEmail: json["notify_by_email"],
    clientType: json["client_type"],
    documentStatus: json["document_status"],
    url: json["url"],
    isRead: json["is_read"],
    documentType: json["document_type"],
    approverId: json["approver_id"],
    approvedAt: json["approved_at"],
    disapproverId: json["disapprover_id"],
    disapprovedAt: json["disapproved_at"] == null ? null : DateTime.parse(json["disapproved_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "folder_name": folderName,
    "company_id": companyId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "ancestry": ancestry,
    "client_id": clientId,
    "share_on_client_portal": shareOnClientPortal,
    "creator_id": creatorId,
    "last_modifier_id": lastModifierId,
    "notify_by_email": notifyByEmail,
    "client_type": clientType,
    "document_status": documentStatus,
    "url": url,
    "is_read": isRead,
    "document_type": documentType,
    "approver_id": approverId,
    "approved_at": approvedAt,
    "disapprover_id": disapproverId,
    "disapproved_at": disapprovedAt?.toIso8601String(),
  };
}
